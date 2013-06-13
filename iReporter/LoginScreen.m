//
//  LoginScreen.m
//  FaveStar
//
//  Created by Greg Roberts on 05/25/2013.
//  Copyright (c) 2013 Greg Roberts. All rights reserved.
//

#import "LoginScreen.h"
#import "UIAlertView+error.h"
#import "API.h"
#include <CommonCrypto/CommonDigest.h>

#define kSalt @"adlfu3489tyh2jnkLIUGI&%EV(&0982cbgrykxjnk8855"

@implementation LoginScreen

@synthesize delegate;

-(void)viewDidLoad {
    [super viewDidLoad];
    
    //focus on the username field / show keyboard
    [fldUsername becomeFirstResponder];

}

#pragma mark - View lifecycle
/*
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait; 
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        return YES;
    }
    return NO;
}
*/
-(IBAction)btnLoginRegisterTapped:(UIButton*)sender {
	//form fields validation
	if (fldUsername.text.length < 4 || fldPassword.text.length < 4) {
		[UIAlertView error:@"Enter username and password over 4 chars each."];
		return;
	}
	//salt the password
	NSString* saltedPassword = [NSString stringWithFormat:@"%@%@", fldPassword.text, kSalt];
	//prepare the hashed storage
	NSString* hashedPassword = nil;
	unsigned char hashedPasswordData[CC_SHA1_DIGEST_LENGTH];
	//hash the pass
	NSData *data = [saltedPassword dataUsingEncoding: NSUTF8StringEncoding];
	if (CC_SHA1([data bytes], [data length], hashedPasswordData)) {
		hashedPassword = [[NSString alloc] initWithBytes:hashedPasswordData length:sizeof(hashedPasswordData) encoding:NSASCIIStringEncoding];
	} else {
		[UIAlertView error:@"Password can't be sent"];
		return;
	}
	//check whether it's a login or register
	NSString* command = (sender.tag==1)?@"register":@"login";
	NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:command, @"command", fldUsername.text, @"username", hashedPassword, @"password", nil];
	//make the call to the web API
	[[API sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
		//result returned
		NSDictionary* res = [[json objectForKey:@"result"] objectAtIndex:0];
		if ([json objectForKey:@"error"]==nil && [[res objectForKey:@"IdUser"] intValue]>0) {
			
            [[API sharedInstance] setUser: res];
            [Utility syncDefaults:kLoggedInUserDetails dataToSync:res];
            
			[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
			//show message to the user
			[[[UIAlertView alloc] initWithTitle:@"Logged in" message:[NSString stringWithFormat:@"Welcome back, %@!",[res objectForKey:@"username"]] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil] show];
		} else {
			//error
			[UIAlertView error:[json objectForKey:@"error"]];
		}
	}];

}

- (IBAction)cancel:(id)sender {
    
    NSLog(@"self.delegate -- %@", self.delegate);

    if(self.delegate != nil) {
        
        
        [self.delegate loginViewCancelled];
        [self dismissModalViewControllerAnimated:NO];

        
    }
    else {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationLandscapeRight;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        return YES;
    }
    return NO;
}

@end
