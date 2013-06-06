//
//  StreamPhotoScreen.h
//  FaveStar
//
//  Created by Greg Roberts on 05/25/2013.
//  Copyright (c) 2013 Greg Roberts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"

@interface StreamPhotoScreen : UIViewController
{
    //just the photo view and the photo title
    IBOutlet UIImageView* photoView;
    IBOutlet UIImageView* catIconView;
    IBOutlet UILabel* lblTitle;
    
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
