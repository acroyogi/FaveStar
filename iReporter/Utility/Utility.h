//
//  Utility.h

#import <Foundation/Foundation.h>

@interface Utility : NSObject {
	
}

+ (void)showAlertWithTitle:(NSString *)titleString message:(NSString *)messageString delegate:(id)delegate;
+ (void)setButtonImageForAllState:(UIButton*)btn image:(NSString*)imageName;
+ (void)animateViewWithAlpha:(float)alpha duration:(float)duration view:(id)view;
+ (void)syncDefaults:(NSString *)userDefaultKey dataToSync:(id)data;
+ (void)setButtonTitleAllState:(UIButton*)btn text:(NSString *)text;

@end