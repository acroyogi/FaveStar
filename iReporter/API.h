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

//the web location of the service
//#define kAPIHost @"http://www.glassfaves.com"
#define kAPIHost @"http://www.favestar.net"

// favestar.net/_api/

//#define kAPIPath @"ios/"
#define kAPIPath @"_api/"
#define kAPIImgPath @"_imgbank/"
#define kAPIIconImgPath @"http://www.favestar.net/_img/ui/icons/cats/numbers/"

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

@end
