//
//  UploadDataQueue+DAO.m
//  gFaves
//
//  Created by Adarsh M on 6/11/13.
//  Copyright (c) 2013 Greg Roberts. All rights reserved.
//

#import "UploadDataQueue+DAO.h"

@implementation UploadDataQueue (DAO)

+ (NSArray*)allUploadDataQueueObjectsInManagedObjectContext {
    
    NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"UploadDataQueue" inManagedObjectContext:context]];
    
    NSArray *objects = [context executeFetchRequest:request error:nil];
    
    return objects;
    
}

+ (NSArray*)UploadDataQueueObjectsByQueueId:(NSNumber*)queueId {
    
    NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"UploadDataQueue" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"queueId = %@", queueId]];
    
    NSArray *objects = [context executeFetchRequest:request error:nil];
    
    return objects;
}


+ (NSArray*)allPendingUploadDataQueueObjectsInManagedObjectContext {
    
    NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"UploadDataQueue" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"detailsUploaded = %@ OR imageUploaded = %@", [NSNumber numberWithInt:0], [NSNumber numberWithInt:0]]];
    
    NSArray *objects = [context executeFetchRequest:request error:nil];
    
    return objects;
}

+ (int)pendingUploadDataQueueCount {
    
    NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"UploadDataQueue" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"detailsUploaded = %@ OR imageUploaded = %@", [NSNumber numberWithInt:0], [NSNumber numberWithInt:0]]];
    
    return [[context executeFetchRequest:request error:nil] count];
}

// Insert a new object.
+ (UploadDataQueue *)insert:(NSMutableDictionary *)details {
    
    NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
    
    UploadDataQueue *obj = [NSEntityDescription insertNewObjectForEntityForName:@"UploadDataQueue" inManagedObjectContext:context];
    obj = [UploadDataQueue populateObjectWithDic:obj dictionary:details];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Error in inserting UploadDataQueue Object - error:%@" ,error);
    }
    
    return obj;
}

// Populate an object by using the values of a dictionary.
+ (UploadDataQueue *)populateObjectWithDic:(UploadDataQueue*)obj dictionary:(NSMutableDictionary *)details {

    [obj setFaveTitle:[details objectForKey:@"faveTitle"]];
    [obj setCat:[details objectForKey:@"cat"]];
    //[obj setTimestamp:[NSDate date]];
   // [obj setIsUploaded:[NSNumber numberWithInt:[[details objectForKey:@"isUploaded"] intValue]]];
    [obj setUserId:[NSNumber numberWithInt:[[details objectForKey:@"userId"] intValue]]];
    [obj setImage:[details objectForKey:@"image"]];
    [obj setLat:[details objectForKey:@"lat"]];
    [obj setLon:[details objectForKey:@"lon"]];
    [obj setDetailsUploaded:[details objectForKey:@"detailsUploaded"]];
    [obj setImageUploaded:[details objectForKey:@"imageUploaded"]];    
    [obj setCatId:[details objectForKey:@"catId"]];
    [obj setCreatedate:[details objectForKey:@"createdate"]];
    [obj setTimezone:[details objectForKey:@"timezone"]];
    [obj setServerPhotoId:[details objectForKey:@"serverPhotoId"]];

    return obj;
}

+ (UploadDataQueue *)update:(UploadDataQueue *)obj {
    
    if(obj != nil) {
        
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];

        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Error in updating UploadDataQueue Object - error:%@" ,error);
        }
    }
    return obj;
}

+ (BOOL)deleteUploadDataQueue:(UploadDataQueue*)obj {
    
    NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
    
    if(obj != nil) {
        [context deleteObject:obj];
    }
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Error in deleting UploadDataQueue Object - error: %@" ,error);
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
