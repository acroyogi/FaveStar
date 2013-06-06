//
//  PhotoScreen.h
//  FaveStar
//
//  Created by Greg Roberts on 05/25/2013.
//  Copyright (c) 2013 Greg Roberts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"

@interface CatScreen : UIViewController<UIImagePickerControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate>
{
    IBOutlet UIImageView* photo;
    IBOutlet UIBarButtonItem* btnCamera;
    IBOutlet UITextField* fldTitle;
    
    UIImage *favImage;
    NSString *favImageName;
    LoadingView *loadingView;
}

@property (nonatomic, strong) UIImage *favImage;
@property (nonatomic, strong) NSString *favImageName;

// launch the camera 
-(IBAction)btnCameraTapped:(id)sender;

-(IBAction)btnCatPersonTapped:(id)sender;
-(IBAction)btnCatPlaceTapped:(id)sender;
-(IBAction)btnCatThingTapped:(id)sender;
-(IBAction)btnCatEventTapped:(id)sender;
-(IBAction)btnCatMealTapped:(id)sender;
-(IBAction)btnCatSongTapped:(id)sender;
-(IBAction)btnCatQuoteTapped:(id)sender;
-(IBAction)btnCatIdeaTapped:(id)sender;


@end
