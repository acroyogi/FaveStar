//
//  UploadQueue.h
//  gFaves
//
//  Created by Adarsh M on 6/11/13.
//  Copyright (c) 2013 Greg Roberts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UploadQueue : NSManagedObject

@property (nonatomic, retain) NSNumber * queueId;
@property (nonatomic, retain) NSString * faveTitle;
@property (nonatomic, retain) NSString * cat;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSNumber * isUploaded;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * lat;
@property (nonatomic, retain) NSString * lon;

@end
