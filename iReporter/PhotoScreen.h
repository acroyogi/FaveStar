//
//  PhotoScreen.h
//  FaveStar
//
//  Created by Greg Roberts on 05/25/2013.
//  Copyright (c) 2013 Greg Roberts. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoScreen : UIViewController<UIImagePickerControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate>
{
    IBOutlet UIImageView* photo;
    IBOutlet UIBarButtonItem* btnAction;
    IBOutlet UIBarButtonItem* btnCamera;
    IBOutlet UITextField* fldTitle;
}

//show the app menu 
-(IBAction)btnActionTapped:(id)sender;
-(IBAction)btnCameraTapped:(id)sender;


@end
