//
//  SettingsScreen.m
//  gFaves
//
//  Created by Adarsh M on 6/10/13.
//  Copyright (c) 2013 Greg Roberts. All rights reserved.
//

#import "SettingsScreen.h"

@interface SettingsScreen ()

@end

@implementation SettingsScreen

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self updateView];
}


- (void)updateView {
    
    [Utility setButtonTitleAllState:loginButton text:(![[API sharedInstance] isAuthorized]) ? @"  Login" : @"  Logout"];
}

- (IBAction)loginOrLogout:(id)sender {

    (![[API sharedInstance] isAuthorized]) ? [self login] : [self logout];
}

- (void)login {
    [self performSegueWithIdentifier:@"ShowLogin" sender:nil];
}

- (void)logout {
    
    //logout the user from the server, and also upon success destroy the local authorization
	[[API sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"logout", @"command", nil] onCompletion:^(NSDictionary *json) {
        //logged out from server
        [[API sharedInstance] setUser:nil];
        [Utility syncDefaults:kLoggedInUserDetails dataToSync:[NSDictionary dictionary]];
        [self performSelectorOnMainThread:@selector(updateView) withObject:nil waitUntilDone:NO];
        [self performSelectorOnMainThread:@selector(showLogoutSuccessMessage) withObject:nil waitUntilDone:NO];
	}];
}

- (void)showLogoutSuccessMessage {
    [Utility showAlertWithTitle:nil message:@"User logged out!" delegate:nil];
}

- (IBAction)cancel:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showOfflineFaves:(id)sender {
    [self performSegueWithIdentifier:@"ShowOfflineFaves" sender:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
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
 */

@end
