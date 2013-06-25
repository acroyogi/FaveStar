//
//  Constants.h


#define DEFAULT_LOCATION ((CLLocation*)[[CLLocation alloc] initWithLatitude:38.891751 longitude:-77.039834])

#define kLoggedInUserDetails @"kLoggedInUserDetails"

#define IS_WIDESCREEN (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define IS_IPHONE_5 (IS_IPHONE && IS_WIDESCREEN)

#define DATA_STORE_NAME @"gFavesV5"
#define DATA_STORE_SQLITE_FILE_NAME [NSString stringWithFormat:@"%@.sqlite", DATA_STORE_NAME]

#define FAVES_DATA_FILE @"faves.plist"

#define HeaderLogoImage @"favestar_logotype_30h.png"