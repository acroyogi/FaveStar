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

#pragma mark - View lifecycle

-(void)viewDidLoad {
    
    [super viewDidLoad];
    [self updateViewWithDetails];
    
    if(self.favImageName == nil) {
        [self hideCategoryButtons];
    }
    
    // Custom initialization
    self.navigationItem.rightBarButtonItem = btnCamera;

    // [NSArray arrayWithObjects: btnCamera, btnAction, nil];

    // self.navigationItem.rightBarButtonItem = [self takePhoto];
    
    /*
    THIS PART WORKS FOR APPEARANCS
    NOW NEED TO MAKE THE BUTTONS ACTUALLY FUNCTION
     
    UIBarButtonItem *searchButton         = [[UIBarButtonItem alloc]
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                             target:self
                                             action:@selector(searchItem:)];
                                             // initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                             // action:@selector(takePhoto)];
    
    UIBarButtonItem *editButton          = [[UIBarButtonItem alloc]
                                            //initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                            target:self action:@selector(editItem:)];

     */
    
    self.navigationItem.title = @"Fave It";

}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if (![[API sharedInstance] isAuthorized]) {
		[self performSegueWithIdentifier:@"ShowLogin" sender:nil];
	}
    else {
        [fldTitle setBorderStyle:UITextBorderStyleRoundedRect];
        [fldTitle setTextColor:[UIColor darkGrayColor]];
        [fldTitle becomeFirstResponder];
    }
}

- (void)updateViewWithDetails {
    
    if(self.favImage != nil) {
        UIImage *scaledImage = [self.favImage
                                resizedImageWithContentMode:UIViewContentModeScaleAspectFill
                                bounds:CGSizeMake(1600, 1200)
                                //bounds:CGSizeMake(photo.frame.size.width,
                                //                  photo.frame.size.height)
                                interpolationQuality:kCGInterpolationHigh];
        
        photo.image = scaledImage;
    }
    
    fldTitle.text = (self.favImageName != nil) ? self.favImageName : @"";
}

#pragma mark - buttons

-(IBAction)btnCameraTapped:(id)sender {
    
    [self selectCategoryButton:sender];
    [self takePhoto];
}

-(IBAction)btnCatPersonTapped:(id)sender {
    
    [self selectCategoryButton:sender];
    [self updateInstructionText:@"Person"];
    gXdataType = @"gperson";
    [self uploadTrick];
}

-(IBAction)btnCatPlaceTapped:(id)sender {
    
    [self selectCategoryButton:sender];
    [self updateInstructionText:@"Place"];
    gXdataType = @"gplace";
    [self uploadTrick];
}

-(IBAction)btnCatThingTapped:(id)sender {
    
    [self selectCategoryButton:sender];
    [self updateInstructionText:@"Thing"];
    gXdataType = @"gthing";
    [self uploadTrick];
}

-(IBAction)btnCatEventTapped:(id)sender {
    
    [self selectCategoryButton:sender];
    [self updateInstructionText:@"Event"];
    gXdataType = @"gevent";
    [self uploadTrick];
}

-(IBAction)btnCatMealTapped:(id)sender {
    
    [self selectCategoryButton:sender];
    [self updateInstructionText:@"Meal"];
    gXdataType = @"gmeal";
    [self uploadTrick];
}

-(IBAction)btnCatSongTapped:(id)sender {
    
    [self selectCategoryButton:sender];
    [self updateInstructionText:@"Song"];
    gXdataType = @"gsong";
    [self uploadTrick];
}

-(IBAction)btnCatQuoteTapped:(id)sender {
    
    [self selectCategoryButton:sender];
    [self updateInstructionText:@"Quote"];
    gXdataType = @"gquote";
    [self uploadTrick];
}

-(IBAction)btnCatIdeaTapped:(id)sender {
    
    [self selectCategoryButton:sender];
    [self updateInstructionText:@"Idea"];
    gXdataType = @"gidea";
    [self uploadTrick];
}

-(IBAction)btnActionTapped:(id)sender {
    
    [self selectCategoryButton:sender];
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
    [self uploadTrick];
}

-(void)uploadPlace {
    gXdataType = @"gplace";
    [self updateInstructionText:@"Place"];
    [self uploadTrick];
}

-(void)uploadThing {
    gXdataType = @"gthing";
    [self updateInstructionText:@"Thing"];
    [self uploadTrick];
}

-(void)uploadSong {
    gXdataType = @"gsong";
    [self updateInstructionText:@"Song"];
    [self uploadTrick];
}

-(void)uploadQuote {
    gXdataType = @"gquote";
    [self updateInstructionText:@"Quote"];
    [self uploadTrick];
}

-(void)uploadIdea {
    gXdataType = @"gidea";
    [self updateInstructionText:@"Idea"];
    [self uploadTrick];
}

-(void)uploadEvent {
    gXdataType = @"gevent";
    [self updateInstructionText:@"Event"];
    [self uploadTrick];
}

-(void)uploadMeal {
    gXdataType = @"gmeal";
    [self updateInstructionText:@"Meal"];
    [self uploadTrick];
}



-(void)uploadTrick {
    
    fldTitle.enabled = NO;
    
    //upload the image and the title to the web service
    [[API sharedInstance] commandWithParams:[NSMutableDictionary
                                             dictionaryWithObjectsAndKeys:
                                             gXdataType, @"command",
                                             UIImageJPEGRepresentation(photo.image,70), @"file",
                                             [NSString stringWithFormat:@"%f", APP_DELEGATE.userLocation.coordinate.latitude], @"lat",
                                             [NSString stringWithFormat:@"%f", APP_DELEGATE.userLocation.coordinate.longitude], @"lon",
                                             self.favImageName, @"title",
                                             
                                             nil]
                               onCompletion:^(NSDictionary *json) {
                                   
                                   //completion
                                   if (![json objectForKey:@"error"]) {
                                       //success
                                       [[[UIAlertView alloc]initWithTitle:@"Success!" message:@"Your fave is saved" delegate:nil cancelButtonTitle:@"Yay!" otherButtonTitles: nil] show];
                                       
                                       
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
        
        if((catButton.tag != btn.tag)) {
            [Utility animateViewWithAlpha:0.0 duration:4 view:catButton];
        }
    }
    
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
    
    [self showOrHideCategoryButtons:NO];
}

- (void)showCategoryButtons {
    
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

@end
