//
//  Utility.m


#import "Utility.h"

@implementation Utility

+ (void)showAlertWithTitle:(NSString *)titleString message:(NSString *)messageString delegate:(id)delegate {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleString message:messageString
												   delegate:delegate cancelButtonTitle:@"OK" otherButtonTitles:  nil];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
}


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

// To save data to defaults
+ (void)syncDefaults:(NSString *)userDefaultKey dataToSync:(id)data {
    
	NSUserDefaults	*defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:data forKey:userDefaultKey];
	[defaults synchronize];
}

+ (void)setButtonTitleAllState:(UIButton*)btn text:(NSString *)text {
    
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitle:text forState:UIControlStateHighlighted];
    [btn setTitle:text forState:UIControlStateDisabled];
    [btn setTitle:text forState:UIControlStateSelected];
    [btn setTitle:text forState:UIControlStateApplication];
    [btn setTitle:text forState:UIControlStateReserved];
}

@end
