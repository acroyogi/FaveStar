//
//  PullToRefreshScrollView.m
//  PullToRefreshScroll
//
//  Created by Joshua Grenon on 2/21/11.
//  Copyright 2011 Josh Grenon. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PullToRefreshScrollView.h"
#define REFRESH_HEADER_HEIGHT 60.0f

@implementation PullToRefreshScrollView

@synthesize refreshDelegate;
@synthesize refreshHeaderView, refreshIndicatorImageView, refreshSpinner;

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoading];
    }
}

- (void)startLoading {
    
    [self showLoading];	
    // Refresh action!
    [self refresh];
}

- (void)showLoading {
    
    isLoading = YES;
	
    bgImageView.image = [UIImage imageNamed:@"FS_spinner_bg.png"];
    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
    refreshIndicatorImageView.hidden = YES;
    [refreshSpinner startAnimating];
    [UIView commitAnimations];
}

- (void)stopLoading {
    
    isLoading = NO;
	
    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    self.contentInset = UIEdgeInsetsZero;
    [UIView commitAnimations];
}

-(void)awakeFromNib
{
	refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, APP_DELEGATE.window.bounds.size.height, REFRESH_HEADER_HEIGHT)];
	refreshHeaderView.backgroundColor = [UIColor lightGrayColor];
	refreshHeaderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    refreshHeaderView.tag = RefreshHeaderViewTag;
    
    bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FS_reload-pull-bg.png"]];
    bgImageView.frame = CGRectMake(0, 0, APP_DELEGATE.window.bounds.size.height, refreshHeaderView.frame.size.height);
    [refreshHeaderView addSubview:bgImageView];
	
    refreshIndicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refresh_icon.png"]];
    refreshIndicatorImageView.frame = CGRectMake(0, 0, 40, 40);
    refreshIndicatorImageView.center = CGPointMake(APP_DELEGATE.window.bounds.size.height / 2, 30);
    refreshIndicatorImageView.hidden = NO;
	
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    refreshSpinner.frame = CGRectMake((REFRESH_HEADER_HEIGHT - 20) / 2, (REFRESH_HEADER_HEIGHT - 20) / 2, 20, 20);
    refreshSpinner.center = CGPointMake(APP_DELEGATE.window.bounds.size.height / 2, 30);
    refreshSpinner.hidesWhenStopped = YES;

    [refreshHeaderView addSubview:refreshSpinner];
    [refreshHeaderView addSubview:refreshIndicatorImageView];
	
	[self addSubview:refreshHeaderView];
	
	self.delegate = self;
	
	[super awakeFromNib];		
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    // Reset the header
    refreshIndicatorImageView.hidden = NO;
    [refreshSpinner stopAnimating];
    bgImageView.image = [UIImage imageNamed:@"FS_reload-pull-bg.png"];
}

- (void)refresh {
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
	[self.refreshDelegate refreshScrollView];
}


@end
