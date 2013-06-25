//
//  CatScreen.m
//  FaveStar
//
//  Created by Greg Roberts on 05/25/2013.
//  Copyright (c) 2013 Greg Roberts. All rights reserved.
//

#import "CatScreen.h"
#import "API.h"
#import "UIImage+Resize.h"
#import "UIAlertView+error.h"
#import "Utility.h"

NSString *gXdataType = @"gperson";

@interface CatScreen(private)

-(void)takePhoto;

-(void)uploadPerson;
-(void)uploadPlace;
-(void)uploadThing;
-(void)uploadSong;
-(void)uploadQuote;
-(void)uploadIdea;
-(void)uploadEvent;
-(void)uploadMeal;

-(void)uploadPhoto;
-(void)effects;
-(void)logout;

- (void)updateViewWithDetails;

@end

@implementation CatScreen


@synthesize favImage;
@synthesize favImageName;

@synthesize delegate;
@synthesize loginViewDismissed;

//@synthesize currentUploadId;
@synthesize uploadQueueObj;

@synthesize selectedCatId;

#pragma mark - View lifecycle

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    categoryTitleLabel.alpha = 0;
    self.loginViewDismissed = NO;
    self.favImageName = @"";
    
    [self updateViewWithDetails];
    
    if(self.favImageName == nil) {
        [self hideCategoryButtons];
    }
    
    // Custom initialization
    //self.navigationItem.rightBarButtonItem = btnCamera;
    
    [Utility addHeaderLogo:self.navigationController logo:HeaderLogoImage];    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if (![[API sharedInstance] isAuthorized] && self.loginViewDismissed == NO) {
		[self performSegueWithIdentifier:@"ShowLogin" sender:nil];
	}
    else {
        
        [self initialImageUpload];
        [fldTitle setBorderStyle:UITextBorderStyleRoundedRect];
        [fldTitle setTextColor:[UIColor darkGrayColor]];
        [fldTitle becomeFirstResponder];
    }
}

- (void)updateViewWithDetails {
    
    if(self.favImage != nil) {        
        photo.image = [self modifiedImage];        
    }
    
    fldTitle.text = (self.favImageName != nil) ? self.favImageName : @"";
}


- (UIImage*)modifiedImage {
    
    UIImage *scaledImage = [self.favImage
                            resizedImageWithContentMode:UIViewContentModeScaleAspectFill
                            bounds:CGSizeMake(1920, 1080)
                            interpolationQuality:kCGInterpolationHigh];
    
    UIImage *croppedImage = [scaledImage
                             croppedImage:CGRectMake(0,
                                                     (scaledImage.size.height - 1080)/2,
                                                     1920, 1080)];
    
    self.favImage = croppedImage;
    
    return self.favImage;
}

#pragma mark - buttons

-(IBAction)btnCameraTapped:(id)sender {
    
    [self selectCategoryButton:sender];
    
    self.selectedCatId = [Utility categoryIdByType:sender];
    
    [self takePhoto];
}

-(IBAction)btnCatPersonTapped:(id)sender {
    
    [self selectCategoryButton:sender];
    self.selectedCatId = [Utility categoryIdByType:sender];
    [self updateInstructionText:@"Person"];
    gXdataType = @"gperson";
    [self uploadMetadata];
}

-(IBAction)btnCatPlaceTapped:(id)sender {
    
    [self selectCategoryButton:sender];
    self.selectedCatId = [Utility categoryIdByType:sender];
    [self updateInstructionText:@"Place"];
    gXdataType = @"gplace";
    [self uploadMetadata];
}

-(IBAction)btnCatThingTapped:(id)sender {
    
    [self selectCategoryButton:sender];
    self.selectedCatId = [Utility categoryIdByType:sender];
    [self updateInstructionText:@"Thing"];
    gXdataType = @"gthing";
    [self uploadMetadata];
}

-(IBAction)btnCatEventTapped:(id)sender {
    
    [self selectCategoryButton:sender];
    self.selectedCatId = [Utility categoryIdByType:sender];
    [self updateInstructionText:@"Event"];
    gXdataType = @"gevent";
    [self uploadMetadata];
}

-(IBAction)btnCatMealTapped:(id)sender {
    
    [self selectCategoryButton:sender];
    self.selectedCatId = [Utility categoryIdByType:sender];
    [self updateInstructionText:@"Meal"];
    gXdataType = @"gmeal";
    [self uploadMetadata];
}

-(IBAction)btnCatSongTapped:(id)sender {
    
    [self selectCategoryButton:sender];
    self.selectedCatId = [Utility categoryIdByType:sender];
    [self updateInstructionText:@"Song"];
    gXdataType = @"gsong";
    [self uploadMetadata];
}

-(IBAction)btnCatQuoteTapped:(id)sender {
    
    [self selectCategoryButton:sender];
    self.selectedCatId = [Utility categoryIdByType:sender];
    [self updateInstructionText:@"Quote"];
    gXdataType = @"gquote";
    [self uploadMetadata];
}

-(IBAction)btnCatIdeaTapped:(id)sender {
    
    [self selectCategoryButton:sender];
    self.selectedCatId = [Utility categoryIdByType:sender];
    [self updateInstructionText:@"Idea"];
    gXdataType = @"gidea";
    [self uploadMetadata];
}

-(IBAction)btnActionTapped:(id)sender {
    
    [self selectCategoryButton:sender];
    self.selectedCatId = [Utility categoryIdByType:sender];
	[fldTitle resignFirstResponder];
    
    //[self takePhoto];
    
	//show the app menu
	[[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Close" destructiveButtonTitle:nil otherButtonTitles:
      // @"Add a Fave",
      @"+Person",
      @"+Place",
      @"+Thing",
      @"+Song",
      @"+Quote",
      @"+Idea",
      @"+Event",
      @"+Meal",
      // @"Logout",
      nil]
	 showInView:self.view];
}

-(void)takePhoto {
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
#if TARGET_IPHONE_SIMULATOR
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
#else
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
#endif
    imagePickerController.editing = YES;
    imagePickerController.delegate = (id)self;
    
    [self presentModalViewController:imagePickerController animated:YES];
}

-(void)effects {
    
    //apply sepia filter - taken from the Beginning Core Image from iOS5 by Tutorials
    CIImage *beginImage = [CIImage imageWithData: UIImagePNGRepresentation(photo.image)];
    CIContext *context = [CIContext contextWithOptions:nil];
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone" keysAndValues: kCIInputImageKey, beginImage, @"inputIntensity", [NSNumber numberWithFloat:0.8], nil];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    photo.image = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
}

// the next three functions are specific types of fave uploads
// literally the only diggerence is the @command to the API in the third line

-(void)uploadPerson {
    gXdataType = @"gperson";
    [self updateInstructionText:@"Person"];
    [self uploadMetadata];
}

-(void)uploadPlace {
    gXdataType = @"gplace";
    [self updateInstructionText:@"Place"];
    [self uploadMetadata];
}

-(void)uploadThing {
    gXdataType = @"gthing";
    [self updateInstructionText:@"Thing"];
    [self uploadMetadata];
}

-(void)uploadSong {
    gXdataType = @"gsong";
    [self updateInstructionText:@"Song"];
    [self uploadMetadata];
}

-(void)uploadQuote {
    gXdataType = @"gquote";
    [self updateInstructionText:@"Quote"];
    [self uploadMetadata];
}

-(void)uploadIdea {
    gXdataType = @"gidea";
    [self updateInstructionText:@"Idea"];
    [self uploadMetadata];
}

-(void)uploadEvent {
    gXdataType = @"gevent";
    [self updateInstructionText:@"Event"];
    [self uploadMetadata];
}

-(void)uploadMeal {
    gXdataType = @"gmeal";
    [self updateInstructionText:@"Meal"];
    [self uploadMetadata];
}

- (void)initialImageUpload {
    
    NSString *createdate = [Utility stringFromDate:[NSDate date] format:@"YYYY-MM-dd HH:mm:ss"];
    NSString *zone = [[Utility stringFromDate:[NSDate date] format:@"zzz"] stringByReplacingOccurrencesOfString:@"GMT" withString:@""];
    
    if(self.uploadQueueObj == nil) {
        
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        
        [data setObject:UIImageJPEGRepresentation(photo.image,70) forKey:@"image"];
        [data setObject:((self.favImageName != nil) ? self.favImageName : @"") forKey:@"faveTitle"];
        [data setObject:[NSString stringWithFormat:@"%f", APP_DELEGATE.userLocation.coordinate.latitude] forKey:@"lat"];
        [data setObject:[NSString stringWithFormat:@"%f", APP_DELEGATE.userLocation.coordinate.longitude] forKey:@"lon"];
        
        [data setObject:[NSNumber numberWithInt:0] forKey:@"imageUploaded"];
        [data setObject:[NSNumber numberWithInt:0] forKey:@"detailsUploaded"];        
        [data setObject:[NSNumber numberWithInt:0] forKey:@"catId"];
        [data setObject:[NSNumber numberWithInt:0] forKey:@"serverPhotoId"];
        
        [data setObject:createdate forKey:@"createdate"];
        [data setObject:zone forKey:@"timezone"];
        
        if([[API sharedInstance] isAuthorized]) {
            [data setObject:([API sharedInstance].user != nil) ? [[API sharedInstance].user objectForKey:@"IdUser"] : @"0" forKey:@"userId"];
        }
        else {
            [data setObject:@"0" forKey:@"userId"];
        }
        
        [data setObject:@"" forKey:@"cat"];
        
        self.uploadQueueObj = [UploadDataQueue insert:data];
    }
    
    if([Utility isNetworkAvailable] && [Utility isAPIServerAvailable]) {
        
        //upload the image and the title to the web service
        [[API sharedInstance] commandWithParams:[NSMutableDictionary
                                                 dictionaryWithObjectsAndKeys:
                                                 @"fastimage", @"command",
                                                 UIImageJPEGRepresentation(photo.image,70), @"file",
                                                 [NSString stringWithFormat:@"%f", APP_DELEGATE.userLocation.coordinate.latitude], @"lat",
                                                 [NSString stringWithFormat:@"%f", APP_DELEGATE.userLocation.coordinate.longitude], @"lon",
                                                 self.favImageName, @"title",
                                                 createdate, @"createdate",
                                                 zone, @"timezone",                                                 
                                                 nil]
                                   onCompletion:^(NSDictionary *json) {
                                       //completion
                                       if (![json objectForKey:@"error"]) {
                                           
                                           [self.uploadQueueObj setServerPhotoId:[NSNumber numberWithInt:[[json objectForKey:@"successful"] intValue]]];
                                           [self.uploadQueueObj setImageUploaded:[NSNumber numberWithInt:1]];
                                           [UploadDataQueue update:self.uploadQueueObj];
                                           
                                           if([self.uploadQueueObj.catId intValue] != 0 && [self.uploadQueueObj.detailsUploaded  intValue] == 1) {
                                               [self uploadMetadata];
                                           }                                            
                                           
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
    
}


- (void)uploadMetadata {
    
    fldTitle.enabled = NO;
    
    [self.uploadQueueObj setCatId:[NSNumber numberWithInt:self.selectedCatId]];
    [self.uploadQueueObj setCat:gXdataType];
    [self.uploadQueueObj setFaveTitle:self.favImageName];
    
    [UploadDataQueue update:self.uploadQueueObj];
    
    if([Utility isNetworkAvailable] && [Utility isAPIServerAvailable]) {
        
        if([self.uploadQueueObj.serverPhotoId intValue] != 0 && [self.uploadQueueObj.imageUploaded intValue] == 1) {

            //upload the image and the title to the web service
            [[API sharedInstance] commandWithParams:[NSMutableDictionary
                                                     dictionaryWithObjectsAndKeys:
                                                     @"fastmeta", @"command",
                                                     self.favImageName, @"title",
                                                     [NSString stringWithFormat:@"%d", [self.uploadQueueObj.serverPhotoId intValue]], @"IdPhoto",
                                                     [NSString stringWithFormat:@"%d", self.selectedCatId], @"catID",
                                                     nil]
                                       onCompletion:^(NSDictionary *json) {
                                           //completion
                                           if (![json objectForKey:@"error"]) {
                                               //success
                                               [[[UIAlertView alloc]initWithTitle:@"Success!" message:@"Your fave is saved" delegate:nil cancelButtonTitle:@"Yay!" otherButtonTitles: nil] show];
                                               
                                               [self.uploadQueueObj setDetailsUploaded:[NSNumber numberWithInt:1]];
                                               [UploadDataQueue update:self.uploadQueueObj];
                                               
                                               if(self.delegate != nil) {
                                                   [self.delegate galleryDataDidChange];
                                               }
                                               
                                           [self  performSelectorOnMainThread:@selector(cancelView) withObject:nil waitUntilDone:YES];
                                           
                                           } else {
                                               //error, check for expired session and if so - authorize the user
                                               NSString* errorMsg = [json objectForKey:@"error"];
                                               [UIAlertView error:errorMsg];
                                               if ([@"Authorization required" compare:errorMsg]==NSOrderedSame) {
                                                   [self performSegueWithIdentifier:@"ShowLogin" sender:nil];
                                               }
                                           }
                                           fldTitle.enabled = YES;
                                           fldTitle.text = self.favImageName;
                                           [self hideMessageView];
                                       }];
            
        }
    }
    else {
        NSLog(@"No Network");
        
        [Utility showAlertWithTitle:@"" message:[NSString stringWithFormat:@"Saved to your local Favefeeds, it will be updated to server once your connection goes online."] delegate:nil];
        
        fldTitle.enabled = YES;
        fldTitle.text = self.favImageName;
        [self hideMessageView];
    }
    
}

- (void)cancelView {

    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)logout {
    
	//logout the user from the server, and also upon success destroy the local authorization
	[[API sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"logout", @"command", nil] onCompletion:^(NSDictionary *json) {
        //logged out from server
        [API sharedInstance].user = nil;
        [self performSegueWithIdentifier:@"ShowLogin" sender:nil];
	}];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            [self uploadPerson];
			break;
        case 1:
            [self uploadPlace];
			break;
        case 2:
            [self uploadThing];
			break;
        case 3:
            [self uploadSong];
			break;
        case 4:
            [self uploadQuote];
			break;
        case 5:
            [self uploadIdea];
			break;
        case 6:
            [self uploadEvent];
			break;
        case 7:
            [self uploadMeal];
			break;
    }
}

#pragma mark - Image picker delegate methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
	UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    photo.image = [self modifiedImage];
    
    /*
     // Resize the image from the camera
     UIImage *scaledImage = [image
     resizedImageWithContentMode:UIViewContentModeScaleAspectFill
     bounds:CGSizeMake(1600, 1200)
     //bounds:CGSizeMake(photo.frame.size.width,
     //                  photo.frame.size.height)
     interpolationQuality:kCGInterpolationHigh];
     
     // Crop the image to a square (yikes, fancy!)
     UIImage *croppedImage = [scaledImage
     croppedImage:CGRectMake(0,
     0,
     1600, 1200)];
     //                             croppedImage:CGRectMake((1600 -1024)/2,
     //                                                     (1200 -1024)/2,
     //                                                     1024, 1024)];
     //                             croppedImage:CGRectMake((scaledImage.size.width -photo.frame.size.width)/2,
     //                                                     (scaledImage.size.height -photo.frame.size.height)/2,
     //                                                     photo.frame.size.width, photo.frame.size.height)];
     
     // Show the photo on the screen
     // photo.image = croppedImage;
     photo.image = scaledImage;
     */
    
    [picker dismissModalViewControllerAnimated:NO];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:NO];
}

- (void)selectCategoryButton:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    
    int i = 1000;
    int limit = 1000 + TotalNoOfcategories;
    
    for (; i < limit; i++) {
        
        UIButton *catButton = (UIButton *)[self.view viewWithTag:i];
        NSString *imageName = [NSString stringWithFormat:@"fave-cat-%d%@-512.png", i, (catButton.tag == btn.tag) ?  @"": @"-50g"];
        [Utility setButtonImageForAllState:catButton image:imageName];
        catButton.userInteractionEnabled = NO;
        
        if((catButton.tag != btn.tag)) {
            [Utility animateViewWithAlpha:0.0 duration:4 view:catButton];
        }
        else {
            [self animateSelectedCatButton:btn];
            [Utility animateViewWithAlpha:0.0 duration:0.0 view:categoryTitleLabel];
        }
    }
    
}

- (void)animateSelectedCatButton:(UIButton*)btn {
    
    [btn removeFromSuperview];
    btn.frame = CGRectMake(categoryView.frame.origin.x + btn.frame.origin.x, categoryView.frame.origin.y + btn.frame.origin.y, btn.frame.size.width, btn.frame.size.height);
    [self.view addSubview:btn];

    CGRect frame = CGRectMake(5, messageView.frame.origin.y - 10, 40, 40);
    
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:2.0];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[btn setFrame:frame];
	[UIView commitAnimations];
}

- (void)updateInstructionText:(NSString*)category {
    
    messageView.alpha = 0;
    [Utility animateViewWithAlpha:1 duration:1 view:messageView];
    messageLabel.text = [NSString stringWithFormat:@"Saving %@ to your FaveFeed...", [category lowercaseString]];
}

- (void)hideMessageView {
    
    [Utility animateViewWithAlpha:0 duration:1 view:messageView];
}

- (void)hideCategoryButtons {
    
    [Utility animateViewWithAlpha:0.0 duration:1.0 view:categoryTitleLabel];
    [self showOrHideCategoryButtons:NO];
}

- (void)showCategoryButtons {
    
    [Utility animateViewWithAlpha:0.699999988079071 duration:1.0 view:categoryTitleLabel];
    [self showOrHideCategoryButtons:YES];
}

- (void)showOrHideCategoryButtons:(BOOL)isShow {
    
    int i = 1000;
    int limit = 1000 + TotalNoOfcategories;
    
    for (; i < limit; i++) {
        
        UIButton *catButton = (UIButton *)[self.view viewWithTag:i];
        [Utility animateViewWithAlpha:((isShow == YES) ? 1.0 : 0.0) duration:((isShow == YES) ? 1.0 : 0.0) view:catButton];
    }
}

#pragma mark - UITextField delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [fldTitle setBorderStyle:UITextBorderStyleRoundedRect];
    [fldTitle setBackgroundColor:[UIColor whiteColor]];
    [fldTitle setTextColor:[UIColor darkGrayColor]];
    
    [self hideCategoryButtons];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField; {
    
    self.favImageName = (textField != nil) ? textField.text : @"";
    
    if(self.favImageName != nil && [self.favImageName length] > 0) {
        [textField resignFirstResponder];
        [fldTitle setBorderStyle:UITextBorderStyleNone];
        [fldTitle setTextColor:[UIColor whiteColor]];
        [fldTitle setBackgroundColor:[UIColor clearColor]];
        [self showCategoryButtons];
        return YES;
    }
    else {
        [self hideCategoryButtons];
        return NO;
    }
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([@"ShowLogin" compare: segue.identifier] == NSOrderedSame) {
        
        LoginScreen *loginScreen = segue.destinationViewController;
        loginScreen.delegate = self;
    }
}

#pragma - LoginScreenDelegate

- (void)loginViewCancelled {
    
    self.loginViewDismissed = YES;
}

@end
