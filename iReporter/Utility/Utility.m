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

+ (UIImage *)imageFromColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (void)setButtonTitleAllState:(UIButton*)btn text:(NSString *)text {
    
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitle:text forState:UIControlStateHighlighted];
    [btn setTitle:text forState:UIControlStateDisabled];
    [btn setTitle:text forState:UIControlStateSelected];
    [btn setTitle:text forState:UIControlStateApplication];
    [btn setTitle:text forState:UIControlStateReserved];
}

+ (BOOL)writeArrayToPlist:(NSString*)fileName data:(NSArray*)plistArray {
    
	NSString *writablePath = [[self documentsDirectory] stringByAppendingPathComponent:fileName];
	return [plistArray writeToFile:writablePath atomically:YES];
}

+ (NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSArray *)arrayFromFile:(NSString *)fileName {
    
	NSString *resourcePath = [[self documentsDirectory] stringByAppendingPathComponent:fileName];
	NSArray *fileData = [NSArray arrayWithContentsOfFile:resourcePath];
	return fileData;
}

+ (BOOL)isNetworkAvailable {

    //check whether connection is available
    Reachability *internetReach;
    internetReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [internetReach currentReachabilityStatus];
    if(netStatus == NotReachable) {
        return NO;
    }

    return YES;
}

+ (BOOL)isAPIServerAvailable {
    
    NSString *host = [kAPIHost stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    host = [host stringByReplacingOccurrencesOfString:@"https://" withString:@""];

    Reachability *reachability = [Reachability reachabilityWithHostname:host];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if(internetStatus == NotReachable) {
        return NO;
    }
    
    return YES;
}

+ (void)addHeaderLogo:(UINavigationController*)navController logo:(NSString*)logoName { 
    
    UIImage *image = [UIImage imageNamed:logoName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [navController.navigationBar.topItem setTitleView:imageView];
}

+ (NSString*)timeToString:(NSDate*)time {
    
    NSTimeInterval timeInterval = [time timeIntervalSinceNow];
    NSTimeInterval cTimeInterval = [[NSDate date] timeIntervalSinceNow];
    NSTimeInterval diff = cTimeInterval - timeInterval;
    
    if(diff == 0) {
        return @"now";
    }
    else if(diff > 0) {
        
        int day_diff = floor(diff / 86400);
        
        if(day_diff == 0){
            if(diff < 60) return @"just now";
            if(diff < 120) return @"1 minute ago";
            if(diff < 3600) return [NSString stringWithFormat:@"%.0f minutes ago", floor(diff / 60)] ;
            if(diff < 7200) return @"1 hour ago";
            if(diff < 86400) return [NSString stringWithFormat:@"%.0f hours ago", floor(diff / 3600)] ;
        }
        if(day_diff == 1) return @"Yesterday";
        if(day_diff < 7) return [NSString stringWithFormat:@"%d days ago", day_diff] ;
        if(day_diff < 31) return [NSString stringWithFormat:@"%.0f weeks ago", ceil(day_diff / 7)] ;;
        if(day_diff < 60) return @"last month";
        return @"a long time ago"; //date('F Y', $ts);
    }
    else {
        
        diff = abs(diff);
        int day_diff = floor(diff / 86400);
        
        if(day_diff == 0) {
            if(diff < 120) return @"in a minute";
            if(diff < 3600) return [NSString stringWithFormat:@"in @%.0f minutes", floor(diff / 60)];
            if(diff < 7200) return @"in an hour";
            if(diff < 86400) return [NSString stringWithFormat:@"in @%.0f hours", floor(diff / 3600)];
        }
        
        if(day_diff == 1) return @"Tomorrow";
        /*
        if(day_diff < 4) return date('l', $ts);
        if(day_diff < 7 + (7 - date('w'))) return 'next week";
        if(ceil(day_diff / 7) < 4) return 'in ' . ceil(day_diff / 7) . ' weeks";
        if(date('n', $ts) == date('n') + 1) return 'next month";
        return date('F Y', $ts);
         */
        return @"";
    }
    
    
}


#pragma mark -
#pragma mark Date Conversion Methods

static NSArray *dateFormats = nil;
static NSString *kSQLiteDateFormat = @"yyyy/MM/dd HH:mm:ss Z";

+ (NSArray *)dateFormats {
    if (!dateFormats) {
        dateFormats = [[NSArray alloc] initWithObjects:
                       kSQLiteDateFormat,
					   @"MMM-YYYY",
                       @"yyyy-MM-dd",
					   @"yyyy-12",
                       @"yyyy/MM/dd",
                       @"yyyy/mm/dd",
					   @"yyyy-MM-dd HH:mm:ss Z",
					   @"yyyy-MM-dd HH:mm:ss K",
					   @"yyyy-MM-dd HH:mm:ss ZZ",
					   @"yyyy/MM/dd HH:mm:ss",
                       @"yyyy-MM-dd HH:mm:ss zzz",
                       @"MMM dd, YYYY",
                       nil];
    }
    return dateFormats;
}

//To get date as NSDate from NSString with the specified format.
+ (NSDate *)dateFromString:(NSString *)dateString {
    
	if (!dateString) {
		return nil;
	}
	
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
	for (NSString *format in [self dateFormats]) {
		[formatter setDateFormat:format];
		NSDate *date = [formatter dateFromString:dateString];
		if (date) {
			return date;
		}
	}
	
	return nil;
}

//To get date as NSString from NSDate with specified format.
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString*)format {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:format];
    NSString *result = [formatter stringFromDate:date];
	return result;
}


static NSDateFormatter *uploadDateFormatter = nil;

+ (NSDate*)formattedDate:(NSString*)dateString zone:(NSString*)zoneString {
    
    if(uploadDateFormatter == nil) {
        uploadDateFormatter = [[NSDateFormatter alloc] init];
    }
    
    [uploadDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:zoneString]];
    [uploadDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] ];
    [uploadDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *formattedDate = [uploadDateFormatter dateFromString:dateString];
    
    return formattedDate;
}


+ (NSString*)catImageNameById:(int)catId {
    
    int identifier = 0;
    
    switch (catId) {
        case 1: // PEOPLE favorite human beings
            identifier = 1000;
            break;
        case 2: // PLACES favorite places on planet earth
            identifier = 1001;
            break;
        case 3: // THINGS favorite material objects in the universe
            identifier = 1002;
            break;
        case 4:// EVENTS events that catch my interest
            identifier = 1003;
            break;
        case 5: // MEALS my favorite foods and drinks
            identifier = 1004;
            break;
        case 7: // SONGS my favorite music
            identifier = 1005;
            break;
        case 8: // QUOTES written or verbal expressions that stimulate
            identifier = 1006;
            break;
        case 11: // IDEAS thoughts that make me happy
            identifier = 1007;
            break;
        default:
            break;
    }
    
    return [NSString stringWithFormat:@"fave-cat-%d-512.png", identifier];
}

+ (int)categoryIdByType:(id)sender {
    
    UIButton *btn = (UIButton*)sender;

    int catId = 0;
    
    switch (btn.tag) {
        case 1000: // PEOPLE favorite human beings
            catId = 1;
            break;
        case 1001: // PLACES favorite places on planet earth
            catId = 2;
            break;
        case 1002: // THINGS favorite material objects in the universe
            catId = 3;
            break;
        case 1003:// EVENTS events that catch my interest
            catId = 4;
            break;
        case 1004: // MEALS my favorite foods and drinks
            catId = 5;
            break;
        case 1005: // SONGS my favorite music
            catId = 7;
            break;
        case 1006: // QUOTES written or verbal expressions that stimulate
            catId = 8;
            break;
        case 1007: // IDEAS thoughts that make me happy
            catId = 11;
            break;
        default:
            break;
    }
    
    return catId;
}
 
@end
