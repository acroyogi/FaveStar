//
//  PhotoScreen.h
//  FaveStar
//
//  Created by Greg Roberts on 05/25/2013.
//  Copyright (c) 2013 Greg Roberts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GalleryDataDelegate.h"
#import "Utility.h"
#import "UploadQueue+DAO.h"
#import "LoginScreen.h"

#define TotalNoOfcategories 8

@interface CatScreen : UIViewController<UIImagePickerControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate, LoginScreenDelegate>
{
    IBOutlet UIImageView* photo;
    IBOutlet UIBarButtonItem* btnCamera;
    IBOutlet UITextField* fldTitle;
    IBOutlet UILabel *messageLabel;
    IBOutlet UIView *messageView;
    
    UIImage *favImage;
    NSString *favImageName;
    
    id<GalleryDataDelegate> delegate;
    
    BOOL loginViewDismissed;
    
//    int currentUploadId;
    
    UploadQueue *uploadQueueObj;
    
    int selectedCatId;
}

@property (nonatomic, strong) UIImage *favImage;
@property (nonatomic, strong) NSString *favImageName;

@property (nonatomic, strong) id<GalleryDataDelegate> delegate;
@property BOOL loginViewDismissed;;

//@property int currentUploadId;
@property (nonatomic, strong) UploadQueue *uploadQueueObj;

@property int selectedCatId;

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
