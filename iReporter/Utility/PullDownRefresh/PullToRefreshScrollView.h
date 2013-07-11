//
//  PullToRefreshScrollView.h
//  PullToRefreshScroll
//
//  Created by Joshua Grenon on 2/21/11.
//  Copyright 2011 Josh Grenon. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PullToRefreshScrollViewDelegate;

#define RefreshHeaderViewTag 70707

@interface PullToRefreshScrollView : UIScrollView<UIScrollViewDelegate> {

	UIView *refreshHeaderView;
    UIActivityIndicatorView *refreshSpinner;
    UIImageView *bgImageView;
    UIImageView *refreshIndicatorImageView;
    
    BOOL isDragging;
    BOOL isLoading;
	id <PullToRefreshScrollViewDelegate> refreshDelegate;
}

@property (nonatomic, retain) UIView *refreshHeaderView;
@property (nonatomic, retain) UILabel *refreshLabel;
@property (nonatomic, retain) UIImageView *refreshIndicatorImageView;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;

@property (nonatomic, assign) id <PullToRefreshScrollViewDelegate> refreshDelegate; 
 
-(void)startLoading;
-(void)stopLoading;
-(void)refresh; 
- (void)showLoading;

@end

@protocol PullToRefreshScrollViewDelegate

-(void)refreshScrollView;

@end
