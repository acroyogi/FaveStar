//
//  OfflineFaves.m
//  gFaves
//
//  Created by Adarsh M on 6/11/13.
//  Copyright (c) 2013 Greg Roberts. All rights reserved.
//

#import "OfflineFaves.h"

@interface OfflineFaves ()

@end

@implementation OfflineFaves

@synthesize offlineFaves;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.offlineFaves = [UploadQueue allPendingUploadQueueObjectsInManagedObjectContext];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - UITableViewdelegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  [self.offlineFaves count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier =  @"OfflineFaveCellIdentifier";
    OfflineFaveCell *cell = (OfflineFaveCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OfflineFaveCell"  owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
        
    UploadQueue *data = [self.offlineFaves objectAtIndex:indexPath.row];
    cell.faveNameLabel.text = data.faveTitle;
    cell.faveNameLabel.textColor = [UIColor darkGrayColor];
    
    cell.faveNameLabel.font = [UIFont systemFontOfSize:13];
    
    cell.uploadButton.tag = indexPath.row;
    [cell.uploadButton addTarget:self action:@selector(upload:) forControlEvents:UIControlEventTouchDown];
    
    cell.faveImageView.image = [UIImage imageWithData:data.image];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return  [[UIView alloc ] init];
}

/*
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationLandscapeRight;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        return YES;
    }
    return NO;
}
 */

- (void)upload:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    
    UploadQueue *obj = [self.offlineFaves objectAtIndex:btn.tag];
    
    if([obj.isImageUploaded boolValue] == NO && [obj.serverPhotoId intValue] == 0) {
        [self initialImageUpload:obj];
    }
    else if([obj.serverPhotoId intValue] != 0 && [obj.isImageUploaded boolValue] == YES) {
        [self uploadMetadata:obj];
    }
}

- (void)initialImageUpload:(UploadQueue*)obj {

    if([Utility isNetworkAvailable] && [Utility isAPIServerAvailable]) {
        
        //upload the image and the title to the web service
        [[API sharedInstance] commandWithParams:[NSMutableDictionary
                                                 dictionaryWithObjectsAndKeys:
                                                 @"fastimage", @"command",
                                                 obj.image, @"file",
                                                 obj.lat, @"lat",
                                                 obj.lon, @"lon",
                                                 obj.faveTitle, @"title",
                                                 obj.createdate, @"createdate",
                                                 obj.timezone, @"timezone",
                                                 nil]
                                   onCompletion:^(NSDictionary *json) {
                                       //completion
                                       if (![json objectForKey:@"error"]) {
                                           //                                           self.currentUploadId = [[json objectForKey:@"successful"] intValue];
                                           
                                           [obj setServerPhotoId:[NSNumber numberWithInt:[[json objectForKey:@"successful"] intValue]]];
                                           [obj setIsImageUploaded:[NSNumber numberWithInt:1]];
                                           [UploadQueue update:obj];
                                           
                                           if([obj.catId intValue] != 0 && [obj.isMetadataUploaded boolValue] == NO) {
                                               [self uploadMetadata:obj];
                                           }
                                           
                                           [self performSelectorOnMainThread:@selector(refreshViewWithData) withObject:nil waitUntilDone:NO];
                                           
                                       } else {
                                           //error, check for expired session and if so - authorize the user
                                           NSString* errorMsg = [json objectForKey:@"error"];
                                           [UIAlertView error:errorMsg];
                                           if ([@"Authorization required" compare:errorMsg]==NSOrderedSame) {
                                               [self performSegueWithIdentifier:@"ShowLogin" sender:nil];
                                           }
                                       }
                                       
                                   }];
    }
    else {
        [UIAlertView error:@"No network"];
    }
    
    
}



- (void)uploadMetadata:(UploadQueue*)obj {
    
    
    if([obj.serverPhotoId intValue] != 0 && [obj.isImageUploaded boolValue] == YES) {
        
        if([Utility isNetworkAvailable] && [Utility isAPIServerAvailable]) {
            
            //upload the image and the title to the web service
            [[API sharedInstance] commandWithParams:[NSMutableDictionary
                                                     dictionaryWithObjectsAndKeys:
                                                     @"fastmeta", @"command",
                                                     obj.faveTitle, @"title",
                                                     [NSString stringWithFormat:@"%d", [obj.serverPhotoId intValue]], @"IdPhoto",
                                                     [NSString stringWithFormat:@"%d", [obj.catId intValue]], @"catID",
                                                     nil]
                                       onCompletion:^(NSDictionary *json) {
                                           //completion
                                           if (![json objectForKey:@"error"]) {
                                               //success
                                               [[[UIAlertView alloc]initWithTitle:@"Success!" message:@"Your fave is saved" delegate:nil cancelButtonTitle:@"Yay!" otherButtonTitles: nil] show];
                                               
                                               [obj setIsMetadataUploaded:[NSNumber numberWithInt:1]];
                                               [UploadQueue update:obj];
                                               
                                               [self performSelectorOnMainThread:@selector(refreshViewWithData) withObject:nil waitUntilDone:NO];
                                               
                                           } else {
                                               //error, check for expired session and if so - authorize the user
                                               NSString* errorMsg = [json objectForKey:@"error"];
                                               [UIAlertView error:errorMsg];
                                               if ([@"Authorization required" compare:errorMsg]==NSOrderedSame) {
                                                   [self performSegueWithIdentifier:@"ShowLogin" sender:nil];
                                               }
                                           }
                                       }];
        }
        else {
           [UIAlertView error:@"No network"];
        }
    }
    
}

- (void)refreshViewWithData {
    
    self.offlineFaves = [UploadQueue allPendingUploadQueueObjectsInManagedObjectContext];
    [listTableView reloadData];
}

/*
 
 
 - (void)upload:(id)sender {
 
 UIButton *btn = (UIButton*)sender;
 
 UploadQueue *obj = [self.offlineFaves objectAtIndex:btn.tag];
 
 if([obj.isImageUploaded boolValue] == NO && [obj.serverPhotoId intValue] == 0) {
 [self initialImageUpload:obj];
 }
 else if([obj.serverPhotoId intValue] != 0 && [obj.isImageUploaded boolValue] == YES) {
 [self uploadMetadata:obj];
 }
 
 if([Utility isNetworkAvailable]) {
 
 //upload the image and the title to the web service
 [[API sharedInstance] commandWithParams:[NSMutableDictionary
 dictionaryWithObjectsAndKeys:
 obj.cat, @"command",
 obj.image, @"file",
 obj.faveTitle, @"title",
 obj.lat, @"lat",
 obj.lon, @"lon",
 
 nil]
 onCompletion:^(NSDictionary *json) {
 
 //completion
 if (![json objectForKey:@"error"]) {
 //success
 [[[UIAlertView alloc]initWithTitle:@"Success!" message:@"Your fave is saved" delegate:nil cancelButtonTitle:@"Yay!" otherButtonTitles: nil] show];
 
 [obj setIsImageUploaded:[NSNumber numberWithInt:1]];
 [UploadQueue update:obj];
 //[UploadQueue deleteUploadQueue:obj];
 [self performSelectorOnMainThread:@selector(refreshViewWithData) withObject:nil waitUntilDone:NO];
 
 } else {
 //error, check for expired session and if so - authorize the user
 NSString* errorMsg = [json objectForKey:@"error"];
 [UIAlertView error:errorMsg];
 if ([@"Authorization required" compare:errorMsg]==NSOrderedSame) {
 [self performSegueWithIdentifier:@"ShowLogin" sender:nil];
 }
 }
 
 }];
 }
 else {
 [UIAlertView error:@"No network"];
 }
 }
 */

@end
