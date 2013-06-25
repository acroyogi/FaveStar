//
//  UploadDataQueue+DAO.h
//  gFaves
//
//  Created by Adarsh M on 6/11/13.
//  Copyright (c) 2013 Greg Roberts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UploadDataQueue.h"

@interface UploadDataQueue (DAO)

+ (NSArray*)allUploadDataQueueObjectsInManagedObjectContext;
+ (NSArray*)uploadQueueObjectsByQueueId:(NSNumber*)queueId;

+ (NSArray*)allPendingUploadDataQueueObjectsInManagedObjectContext;

+ (int)pendingUploadDataQueueCount;

// Insert a new object.
+ (UploadDataQueue *)insert:(NSMutableDictionary *)details;

// Populate an object by using the values of a dictionary.
+ (UploadDataQueue *)populateObjectWithDic:(UploadDataQueue*)obj dictionary:(NSMutableDictionary *)details;

+ (UploadDataQueue *)update:(UploadDataQueue *)obj;
+ (BOOL)deleteUploadDataQueue:(UploadDataQueue*)obj;

@end
