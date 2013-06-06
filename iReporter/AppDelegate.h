//
//  AppDelegate.h
//  FaveStar
//
//  Created by Greg Roberts on 05/25/2013.
//  Copyright (c) 2013 Greg Roberts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate> {
    
    CLLocationManager *locationManager;
	CLLocation *userLocation;
}

@property (strong, nonatomic) UIWindow *window;

// AppDelegate.h
@property (nonatomic, strong) UINavigationController *navController;

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *userLocation;

@end
