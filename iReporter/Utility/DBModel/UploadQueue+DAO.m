//
//  UploadQueue+DAO.m
//  gFaves
//
//  Created by Adarsh M on 6/11/13.
//  Copyright (c) 2013 Greg Roberts. All rights reserved.
//

#import "UploadQueue+DAO.h"

@implementation UploadQueue (DAO)

+ (NSArray*)allUploadQueueObjectsInManagedObjectContext {
    
    NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"UploadQueue" inManagedObjectContext:context]];
    
    NSArray *objects = [context executeFetchRequest:request error:nil];
    
    return objects;
    
}

+ (NSArray*)uploadQueueObjectsByQueueId:(NSNumber*)queueId {
    
    NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"UploadQueue" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"queueId = %@", queueId]];
    
    NSArray *objects = [context executeFetchRequest:request error:nil];
    
    return objects;
}


+ (NSArray*)allPendingUploadQueueObjectsInManagedObjectContext {
    
    NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"UploadQueue" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"isUploaded = %@", [NSNumber numberWithInt:0]]];
    
    NSArray *objects = [context executeFetchRequest:request error:nil];
    
    return objects;
}

// Insert a new object.
+ (UploadQueue *)insert:(NSMutableDictionary *)details {
    
    NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
    
    UploadQueue *obj = [NSEntityDescription insertNewObjectForEntityForName:@"UploadQueue" inManagedObjectContext:context];
    obj = [UploadQueue populateObjectWithDic:obj dictionary:details];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Error in inserting UploadQueue Object - error:%@" ,error);
    }
    
    return obj;
}

// Populate an object by using the values of a dictionary.
+ (UploadQueue *)populateObjectWithDic:(UploadQueue*)obj dictionary:(NSMutableDictionary *)details {

    [obj setFaveTitle:[details objectForKey:@"faveTitle"]];
    [obj setCat:[details objectForKey:@"cat"]];
    [obj setTimestamp:[NSDate date]];
    [obj setIsUploaded:[NSNumber numberWithInt:[[details objectForKey:@"isUploaded"] intValue]]];
    [obj setUserId:[NSNumber numberWithInt:[[details objectForKey:@"userId"] intValue]]];
    [obj setImage:[details objectForKey:@"image"]];
    [obj setLat:[details objectForKey:@"lat"]];
    [obj setLon:[details objectForKey:@"lon"]];

    return obj;
}

+ (UploadQueue *)update:(UploadQueue *)obj {
    
    if(obj != nil) {
        
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];

        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Error in updating UploadQueue Object - error:%@" ,error);
        }
    }
    return obj;
}

+ (BOOL)deleteUploadQueue:(UploadQueue*)obj {
    
    NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
    
    if(obj != nil) {
        [context deleteObject:obj];
    }
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Error in deleting UploadQueue Object - error: %@" ,error);
        return NO;
    }
    
    return YES;
}

// Call this method when an object is inserted.
- (void)awakeFromInsert {
    
    //[super awakeFromInesrt];
    NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[self entity]];
    [request setFetchLimit:1];
    
    NSArray *propertiesArray = [[NSArray alloc] initWithObjects:@"queueId", nil];
    [request setPropertiesToFetch:propertiesArray];
    propertiesArray = nil;
    
    NSSortDescriptor *indexSort = [[NSSortDescriptor alloc] initWithKey:@"queueId" ascending:NO];
    
    NSArray *array = [[NSArray alloc] initWithObjects:indexSort, nil];
    [request setSortDescriptors:array];
    array = nil;
    indexSort = nil;
    
    NSError *error = nil;
    NSManagedObject *maxIndexedObject = [[context executeFetchRequest:request error:&error] lastObject];
    request = nil;
    
    NSInteger myIndex = 1;
    if (maxIndexedObject) {
        myIndex = [[maxIndexedObject valueForKey:@"queueId"] integerValue] + 1;
    }
    
    [self setValue:[NSNumber numberWithInteger:myIndex] forKey:@"queueId"];
}



@end
