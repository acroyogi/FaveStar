//
//  PhotoScreen.m
//  FaveStar
//
//  Created by Greg Roberts on 05/25/2013.
//  Copyright (c) 2013 Greg Roberts. All rights reserved.
//

#import "PhotoScreen.h"
#import "API.h"
#import "UIImage+Resize.h"
#import "UIAlertView+error.h"

NSString *gdataType = @"gperson";

@interface PhotoScreen(private)
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
@end

@implementation PhotoScreen

#pragma mark - View lifecycle
-(void)viewDidLoad {
    [super viewDidLoad];
    // Custom initialization
    // self.navigationItem.rightBarButtonItem = btnAction;

    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: btnAction, btnCamera, nil];
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
	if (![[API sharedInstance] isAuthorized]) {
		[self performSegueWithIdentifier:@"ShowLogin" sender:nil];
	}
    
    // attempt to launch cam immediately upon screen start
    // [self takePhoto];

}

/*
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait; 
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        return YES;
    }
    return NO;
}
 */

#pragma mark - menu

-(IBAction)btnCameraTapped:(id)sender {
    [self takePhoto];
}

-(IBAction)btnActionTapped:(id)sender {
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
    gdataType = @"gperson";
    [self uploadTrick];
}

-(void)uploadPlace {
    gdataType = @"gplace";
    [self uploadTrick];
}

-(void)uploadThing {
    gdataType = @"gthing";
    [self uploadTrick];
}

-(void)uploadSong {
    gdataType = @"gsong";
    [self uploadTrick];
}

-(void)uploadQuote {
    gdataType = @"gquote";
    [self uploadTrick];
}

-(void)uploadIdea {
    gdataType = @"gidea";
    [self uploadTrick];
}

-(void)uploadEvent {
    gdataType = @"gevent";
    [self uploadTrick];
}

-(void)uploadMeal {
    gdataType = @"gmeal";
    [self uploadTrick];
}



-(void)uploadTrick {
    //upload the image and the title to the web service
    [[API sharedInstance] commandWithParams:[NSMutableDictionary
                                             dictionaryWithObjectsAndKeys:
                                             gdataType, @"command",
                                             UIImageJPEGRepresentation(photo.image,70), @"file",
                                             fldTitle.text, @"title",
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
-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
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

@end
