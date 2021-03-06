//
//  UploadQueue.h
//  gFaves
//
//  Created by Adarsh M on 6/14/13.
//  Copyright (c) 2013 Greg Roberts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UploadQueue : NSManagedObject

@property (nonatomic, retain) NSString * cat;
@property (nonatomic, retain) NSString * faveTitle;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSNumber * isImageUploaded;
@property (nonatomic, retain) NSString * lat;
@property (nonatomic, retain) NSString * lon;
@property (nonatomic, retain) NSNumber * queueId;
@property (nonatomic, retain) NSString * createdate;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSNumber * catId;
@property (nonatomic, retain) NSNumber * isMetadataUploaded;
@property (nonatomic, retain) NSString * timezone;
@property (nonatomic, retain) NSNumber * serverPhotoId;

@end
