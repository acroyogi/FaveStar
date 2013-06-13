//
//  StreamPhotoScreen.h
//  FaveStar
//
//  Created by Greg Roberts on 05/25/2013.
//  Copyright (c) 2013 Greg Roberts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
#import "UILabel+AdjustFontSize.h"
#import "Utility.h"

@interface StreamPhotoScreen : UIViewController<UIScrollViewDelegate>
{
    //just the photo view and the photo title
    IBOutlet UIImageView* photoView;
    IBOutlet UIImageView* catIconView;
    IBOutlet UILabel* lblTitle;
    IBOutlet UILabel* lblLocation;
    IBOutlet UILabel* lblDate;
    IBOutlet UILabel* lblUserName;
    
    IBOutlet UIScrollView *scrollView;
    
    int totalPhotoCount;
    int currentImageId;
    NSArray *dataList;
    
    LoadingView *loadingView;
    NSNumber* IdPhoto;
}

@property (nonatomic, strong) NSNumber* IdPhoto;
@property (assign, nonatomic) NSInteger* IdCat;
@property (nonatomic, strong) NSArray *dataList;

@property int totalPhotoCount;
@property int currentImageId;

- (IBAction)closeView:(id)sender;

@end
