//
//  StreamScreen.h
//  FaveStar
//
//  Created by Greg Roberts on 05/25/2013.
//  Copyright (c) 2013 Greg Roberts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoView.h"
#import "GalleryDataDelegate.h"
#import "Utility.h"
#import "PullToRefreshScrollView.h"

@interface StreamScreen : UIViewController <PhotoViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, GalleryDataDelegate, PullToRefreshScrollViewDelegate> {
    IBOutlet UIBarButtonItem* btnCompose;
    IBOutlet UIBarButtonItem* btnRefresh;
    IBOutlet PullToRefreshScrollView* listView;
    IBOutlet UIButton *cameraButton;
    
    UIImagePickerController *imagePicker;
    UIAlertView *inputAlert;
    
    UIImage *favImage;
    NSString *favName;
    
    int totalStreamCount;
    NSArray *streamList;
    
    BOOL isInitialLoadDone;
}

@property (nonatomic, strong) UIImage *favImage;
@property (nonatomic, strong) NSString *favName;

@property int totalStreamCount;
@property (nonatomic, strong) NSArray *streamList;

@property BOOL isInitialLoadDone;

//refresh the photo stream
- (IBAction)btnRefreshTapped;
- (IBAction)showCameraView;

@end
