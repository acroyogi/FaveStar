//
//  SettingsScreen.h
//  gFaves
//
//  Created by Adarsh M on 6/10/13.
//  Copyright (c) 2013 Greg Roberts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "LoginScreen.h"

@interface SettingsScreen : UIViewController<LoginScreenDelegate> {
    
    IBOutlet UIButton *loginButton;
    IBOutlet UILabel *userNamelabel;
    IBOutlet UILabel *queueCountLabel;
}

- (IBAction)loginOrLogout:(id)sender;
- (IBAction)showOfflineFaves:(id)sender;
- (IBAction)cancel:(id)sender;

@end
