//
//  UploadQueue+DAO.h
//  gFaves
//
//  Created by Adarsh M on 6/11/13.
//  Copyright (c) 2013 Greg Roberts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UploadQueue.h"

@interface UploadQueue (DAO)

+ (NSArray*)allUploadQueueObjectsInManagedObjectContext;
+ (NSArray*)uploadQueueObjectsByQueueId:(NSNumber*)queueId;

+ (NSArray*)allPendingUploadQueueObjectsInManagedObjectContext;

// Insert a new object.
+ (UploadQueue *)insert:(NSMutableDictionary *)details;

// Populate an object by using the values of a dictionary.
+ (UploadQueue *)populateObjectWithDic:(UploadQueue*)obj dictionary:(NSMutableDictionary *)details;

+ (UploadQueue *)update:(UploadQueue *)obj;
+ (BOOL)deleteUploadQueue:(UploadQueue*)obj;

@end
