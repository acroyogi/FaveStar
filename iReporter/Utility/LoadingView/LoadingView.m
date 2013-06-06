//
//  LoadingView.m
//  FaveStar
//
//  Created by Adarsh M on 2/8/12.
//  Copyright (c) 2012 Mobomo LLC. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_loading_view.png"]];
        [imageView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:imageView];
        
        UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, frame.size.width, frame.size.height - 20)];
        loadingLabel.backgroundColor = [UIColor clearColor];
        loadingLabel.textAlignment = UITextAlignmentCenter;
        loadingLabel.font = [UIFont systemFontOfSize:16]; //[UIFont fontWithName:APPLICATION_FONT_NAME size:18];
        loadingLabel.textColor = [UIColor whiteColor];
        [self addSubview:loadingLabel];
        loadingLabel.text = @"Loading...";
//        [loadingLabel release];
        
        UIActivityIndicatorView *loadingIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		loadingIndicatorView.center = CGPointMake((frame.size.width/2), (frame.size.height/2) - 10);
        loadingIndicatorView.hidesWhenStopped = YES;
        [loadingIndicatorView startAnimating];
		[self addSubview:loadingIndicatorView];
//        [loadingIndicatorView release];
        
    }
    self.backgroundColor = [UIColor clearColor];
    return self;
}

@end
