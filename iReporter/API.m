//
//  API.m
//  FaveStar
//
//  Created by Greg Roberts on 05/25/2013.
//  Copyright (c) 2013 Greg Roberts. All rights reserved.
//

#import "API.h"

//the web location of the service
#define kAPIHost @"http://www.glassfaves.com"
#define kAPIPath @"ios/"
#define kAPIImgPath @"_imgbank/"
#define kAPIIconImgPath @"http://www.favestar.net/_img/ui/icons/cats/numbers/"

@implementation API

@synthesize user;

#pragma mark - Singleton methods
/**
 * Singleton methods
 */
+(API*)sharedInstance {
    static API *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:kAPIHost]];
    });
    
    return sharedInstance;
}

#pragma mark - init
//intialize the API class with the deistination host name

-(API*)init {
    //call super init
    self = [super init];
    if (self != nil) {
        //initialize the object
        user = nil;
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    return self;
}

-(BOOL)isAuthorized {
    return [[user objectForKey:@"IdUser"] intValue]>0;
}




// this function sends an API call to the server

-(void)commandWithParams:(NSMutableDictionary*)params onCompletion:(JSONResponseBlock)completionBlock {
    
    [MBMNetworkActivity pushNetworkActivity];
    
	NSData* uploadFile = nil;
	if ([params objectForKey:@"file"]) {
		uploadFile = (NSData*)[params objectForKey:@"file"];
		[params removeObjectForKey:@"file"];
	}

    NSMutableURLRequest *apiRequest = [self multipartFormRequestWithMethod:@"POST" path:kAPIPath parameters:params constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
		if (uploadFile) {
			[formData appendPartWithFileData:uploadFile name:@"file" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
		}
	}];
    AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest: apiRequest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //success!
        [MBMNetworkActivity popNetworkActivity];
        completionBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //failure :(
        [MBMNetworkActivity popNetworkActivity];
        completionBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];
    [operation start];
}




// this function creates the URL for a single image from the server

-(NSURL*)urlForImageWithId:(NSNumber*)IdPhoto isThumb:(BOOL)isThumb {
    NSString* urlString = [NSString stringWithFormat:@"%@/%@upload/%@%@.jpg", kAPIHost, kAPIImgPath, IdPhoto, (isThumb)?@"_t":@"_m"];
    return [NSURL URLWithString:urlString];
}

// this function creates the URL for a category icon from the server

-(NSURL*)urlForCatWithId:(NSString*)IdCat {
    // NSString* urlString = [NSString stringWithFormat:@"%@%@.png", kAPIIconImgPath, IdCat];
    NSString* urlString = [NSString stringWithFormat:@"%@%@.png", kAPIIconImgPath, IdCat];
    return [NSURL URLWithString:urlString];
}

@end
