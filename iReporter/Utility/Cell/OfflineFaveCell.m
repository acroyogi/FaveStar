//
//  OfflineFaveCell.m
//  gFaves
//
//  Created by Adarsh M on 6/11/13.
//  Copyright (c) 2013 Greg Roberts. All rights reserved.
//


#import "OfflineFaveCell.h"


@implementation OfflineFaveCell

@synthesize faveNameLabel;
@synthesize uploadButton;
@synthesize faveImageView;

@synthesize delegate;

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)dealloc {
    
    self.faveNameLabel = nil;
    self.uploadButton = nil;
    self.faveImageView = nil;
}

- (IBAction)upload:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    btn.userInteractionEnabled = NO;
    
    [Utility setButtonTitleAllState:btn text:@"Uploading.."];
    blockingView.hidden = NO;
    loadingIndicator.hidden = NO;
    [loadingIndicator startAnimating];
    
    [btn setBackgroundImage:[Utility imageFromColor:[UIColor colorWithRed:0.234152 green:0.660499 blue:0.554894 alpha:1]] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    btn.layer.borderColor = [UIColor blackColor].CGColor;
    btn.layer.borderWidth = 0.2f;
    btn.layer.cornerRadius = 8.0f;
    [btn setClipsToBounds:YES];
    
    if(self.delegate != nil) {
        [self.delegate uploadOfflineFaveData:btn.tag];
    }
}

- (IBAction)deleteItem:(id)sender {

    UIButton *btn = (UIButton*)sender;
    
    if(self.delegate != nil) {
        [self.delegate deleteOfflineFaveItem:btn.tag];
    }
}
@end
