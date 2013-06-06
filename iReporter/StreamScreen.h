//
//  StreamScreen.h
//  FaveStar
//
//  Created by Greg Roberts on 05/25/2013.
//  Copyright (c) 2013 Greg Roberts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoView.h"

@interface StreamScreen : UIViewController <PhotoViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, UITextFieldDelegate> {
    IBOutlet UIBarButtonItem* btnCompose;
    IBOutlet UIBarButtonItem* btnRefresh;
    IBOutlet UIScrollView* listView;
    
    UIImagePickerController *imagePicker;
    UIAlertView *inputAlert;
    
    UIImage *favImage;
    NSString *favName;
    
    int totalStreamCount;
    NSArray *streamList;
}

@property (nonatomic, strong) UIImage *favImage;
@property (nonatomic, strong) NSString *favName;

@property int totalStreamCount;
@property (nonatomic, strong) NSArray *streamList;

//refresh the photo stream
-(IBAction)btnRefreshTapped;
- (IBAction)showCameraView;

@end
