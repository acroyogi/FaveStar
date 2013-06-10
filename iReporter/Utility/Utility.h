//
//  Utility.h

#import <Foundation/Foundation.h>


@interface Utility : NSObject {
	
}

+ (void)setButtonImageForAllState:(UIButton*)btn image:(NSString*)imageName;
+ (void)animateViewWithAlpha:(float)alpha duration:(float)duration view:(id)view;

@end