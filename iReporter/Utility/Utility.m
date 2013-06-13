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


- (NSString*)timeToString:(NSDate*)time {
    
    
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
            if(diff < 3600) return [NSString stringWithFormat:@"%f  minutes ago", floor(diff / 60)] ;
            if(diff < 7200) return @"1 hour ago";
            if(diff < 86400) return [NSString stringWithFormat:@"%f  hours ago", floor(diff / 3600)] ;
        }
        if(day_diff == 1) return @"Yesterday";
        if(day_diff < 7) return [NSString stringWithFormat:@"%d  days ago", day_diff] ;
        if(day_diff < 31) return [NSString stringWithFormat:@"%f   weeks ago", ceil(day_diff / 7)] ;;
        if(day_diff < 60) return @"last month";
        return @"++todo"; //date('F Y', $ts);
    }
    else {
        
        diff = abs(diff);
        int day_diff = floor(diff / 86400);
        
        if(day_diff == 0) {
            if(diff < 120) return @"in a minute";
            if(diff < 3600) return [NSString stringWithFormat:@"in @%f minutes", floor(diff / 60)];
            if(diff < 7200) return @"in an hour";
            if(diff < 86400) return [NSString stringWithFormat:@"in @%f hours", floor(diff / 3600)];
        }
        /*
        if(day_diff == 1) return @"Tomorrow";
        if(day_diff < 4) return date('l', $ts);
        if(day_diff < 7 + (7 - date('w'))) return 'next week";
        if(ceil(day_diff / 7) < 4) return 'in ' . ceil(day_diff / 7) . ' weeks";
        if(date('n', $ts) == date('n') + 1) return 'next month";
        return date('F Y', $ts);
         */
        return @"";
    }
    
    
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
 
 
@end
