//
//  PhotoView.h
//  FaveStar
//
//  Created by Greg Roberts on 05/25/2013.
//  Copyright (c) 2013 Greg Roberts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

//1 layout config
//(([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight) ? 176 : 145)
#define kThumbSideW ((IS_IPHONE_5) ? 176 : 225) 
#define kThumbSideH ((IS_IPHONE_5) ? 99 : 110) 
#define kPadding 8

//2 define the thumb delegate protocol
@protocol PhotoViewDelegate <NSObject>
-(void)didSelectPhoto:(id)sender;
@end

//3 define the thumb view interface
@interface PhotoView : UIButton
@property (assign, nonatomic) id<PhotoViewDelegate> delegate;

-(id)initWithIndex:(int)i andData:(NSDictionary*)data;

@end
