//
//  API.h
//  FaveStar
//
//  Created by Greg Roberts on 05/25/2013.
//  Copyright (c) 2013 Greg Roberts. All rights reserved.
//

#import "AFHTTPClient.h"
#import "AFNetworking.h"
#import "MBMNetworkActivity.h"

//the web locations of the service

#define kAPIHost @"http://api.favestar.net"
//#define kAPIPath @"_api/"
#define kAPIPath @"_api/142/"
#define kAPIVersion @"v0.30i"

#define kAPIImageHost @"http://cimg.favestar.net"
#define kAPIImgPath @"upload/"
// #define kAPIImgPath @"_imgbank/"

#define kAPIIconImgPath @"http://uimg.favestar.net/ui/icons/cats/numbers/"

typedef void (^JSONResponseBlock)(NSDictionary* json);

@interface API : AFHTTPClient

@property (strong, nonatomic) NSDictionary* user;

+(API*)sharedInstance;
//check whether there's an authorized user
-(BOOL)isAuthorized;
//send an API command to the server
-(void)commandWithParams:(NSMutableDictionary*)params onCompletion:(JSONResponseBlock)completionBlock;
-(NSURL*)urlForImageWithId:(NSNumber*)IdPhoto isThumb:(BOOL)isThumb;
//-(NSURL*)urlForCatWithId:(NSInteger*)IdCat;
-(NSURL*)urlForCatWithId:(NSString*)IdCat;

- (NSString*)loggedInUserId;

@end
