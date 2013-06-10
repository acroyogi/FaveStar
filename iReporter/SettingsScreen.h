//
//  SettingsScreen.h
//  gFaves
//
//  Created by Adarsh M on 6/10/13.
//  Copyright (c) 2013 Greg Roberts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"

@interface SettingsScreen : UIViewController {
    
    IBOutlet UIButton *loginButton;
}

- (IBAction)loginOrLogout:(id)sender;
- (IBAction)cancel:(id)sender;

@end
