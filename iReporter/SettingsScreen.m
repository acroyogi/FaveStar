//
//  SettingsScreen.m
//  gFaves
//
//  Created by Adarsh M on 6/10/13.
//  Copyright (c) 2013 Greg Roberts. All rights reserved.
//

#import "SettingsScreen.h"

@interface SettingsScreen ()

@property BOOL loginViewDismissed;

@end

@implementation SettingsScreen

@synthesize loginViewDismissed;

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
    self.loginViewDismissed = NO;
    
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self updateView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if(loginViewDismissed == YES) {;
        [self cancel:nil];
    }
}

- (void)updateView {
    
    [Utility setButtonTitleAllState:loginButton text:(![[API sharedInstance] isAuthorized]) ? @"  Login" : @"  Logout"];
    userNamelabel.text = ([[API sharedInstance] isAuthorized]) ? [NSString stringWithFormat:@"★%@", [[API sharedInstance].user objectForKey:@"username"]] : @"";    
    queueCountLabel.text = [NSString stringWithFormat:@"%d", [UploadDataQueue pendingUploadDataQueueCount]];
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
        //[self performSelectorOnMainThread:@selector(updateView) withObject:nil waitUntilDone:NO];
        [self performSelectorOnMainThread:@selector(cancel:) withObject:nil waitUntilDone:NO];
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

- (void)loginViewCancelled {
    self.loginViewDismissed = YES;
//    [self cancel:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([@"ShowLogin" compare: segue.identifier] == NSOrderedSame) {
        LoginScreen *loginScreen = segue.destinationViewController;
        loginScreen.delegate = self;
    }
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
