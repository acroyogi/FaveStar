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


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)dealloc {
    
    self.faveNameLabel = nil;
    self.uploadButton = nil;
    self.faveImageView = nil;
}

@end
