//
//  Utility.h

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "API.h"

@interface Utility : NSObject {
	
}

+ (void)showAlertWithTitle:(NSString *)titleString message:(NSString *)messageString delegate:(id)delegate;
+ (void)setButtonImageForAllState:(UIButton*)btn image:(NSString*)imageName;
+ (void)animateViewWithAlpha:(float)alpha duration:(float)duration view:(id)view;
+ (void)syncDefaults:(NSString *)userDefaultKey dataToSync:(id)data;
+ (void)setButtonTitleAllState:(UIButton*)btn text:(NSString *)text;

+ (BOOL)writeArrayToPlist:(NSString*)fileName data:(NSArray*)plistArray;
+ (NSArray *)arrayFromFile:(NSString *)fileName;

+ (BOOL)isNetworkAvailable;
+ (BOOL)isAPIServerAvailable;

+ (NSDate *)dateFromString:(NSString *)dateString;
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString*)format;

+ (NSString*)catImageNameById:(int)catId;

+ (NSString*)timeToString:(NSDate*)time;
+ (int)categoryIdByType:(id)sender;

@end