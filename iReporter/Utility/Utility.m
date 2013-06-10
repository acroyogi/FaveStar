//
//  Utility.m


#import "Utility.h"

@implementation Utility

+ (void)setButtonImageForAllState:(UIButton*)btn image:(NSString*)imageName {
    
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateSelected];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateDisabled];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateApplication];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateReserved];
}

+ (void)animateViewWithAlpha:(float)alpha duration:(float)duration view:(id)view {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:duration];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[view setAlpha:alpha];
	[UIView commitAnimations];
}

@end
