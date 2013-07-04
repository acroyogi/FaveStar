//
//  OfflineFaveCell.h
//  gFaves
//
//  Created by Adarsh M on 6/11/13.
//  Copyright (c) 2013 Greg Roberts. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Utility.h"
#import <QuartzCore/QuartzCore.h>

@protocol OfflineFaveDelegate

- (void)deleteOfflineFaveItem:(int)itemIndex;
- (void)uploadOfflineFaveData:(int)itemIndex;

@end

@interface OfflineFaveCell : UITableViewCell {
    
    IBOutlet UILabel *faveNameLabel;
    IBOutlet UIButton *uploadButton;
    IBOutlet UIImageView *faveImageView;
    
    IBOutlet UILabel *blockingView;
    IBOutlet UIActivityIndicatorView *loadingIndicator;
    
    id<OfflineFaveDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet UILabel *faveNameLabel;
@property (nonatomic, retain) IBOutlet UIButton *uploadButton;
@property (nonatomic, retain) IBOutlet UIImageView *faveImageView;

@property (nonatomic, strong) id<OfflineFaveDelegate> delegate;

- (IBAction)upload:(id)sender;
- (IBAction)deleteItem:(id)sender;

@end