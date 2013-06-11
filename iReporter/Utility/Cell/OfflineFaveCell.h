//
//  OfflineFaveCell.h
//  gFaves
//
//  Created by Adarsh M on 6/11/13.
//  Copyright (c) 2013 Greg Roberts. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface OfflineFaveCell : UITableViewCell {
    
    IBOutlet UILabel *faveNameLabel;
    IBOutlet UIButton *uploadButton;
    IBOutlet UIImageView *faveImageView;
}

@property (nonatomic, retain) IBOutlet UILabel *faveNameLabel;
@property (nonatomic, retain) IBOutlet UIButton *uploadButton;
@property (nonatomic, retain) IBOutlet UIImageView *faveImageView;

@end