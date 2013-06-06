//
//  MBMNetworkActivity.h
//  FaveStar
//
//  Created by Adarsh M on 06/29/2010.
//  Copyright 2010 Mobomo LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MBMNetworkActivity : NSObject {
}

// balance these calls with each other.
// i.e. for each push there should be one corresponding pop
+ (void)pushNetworkActivity;
+ (void)popNetworkActivity;

@end
