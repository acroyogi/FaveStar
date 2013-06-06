//
//  LoginScreen.h
//  FaveStar
//
//  Created by Greg Roberts on 05/25/2013.
//  Copyright (c) 2013 Greg Roberts. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginScreen : UIViewController
{
    //the login form fields
    IBOutlet UITextField* fldUsername;
    IBOutlet UITextField* fldPassword;
}

//action for when either button is pressed
-(IBAction)btnLoginRegisterTapped:(id)sender;

@end