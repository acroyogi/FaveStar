//
//  OfflineFaves.h
//  gFaves
//
//  Created by Adarsh M on 6/11/13.
//  Copyright (c) 2013 Greg Roberts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UploadQueue+DAO.h"
#import "OfflineFaveCell.h"
#import "Utility.h"
#import "UIAlertView+error.h"

@interface OfflineFaves : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    
    NSArray *offlineFaves;
    
    IBOutlet UITableView *listTableView;
}

@property (nonatomic, strong) NSArray *offlineFaves;

- (IBAction)cancel:(id)sender;

@end
