//
//  StreamScreen.m
//  FaveStar
//
//  Created by Greg Roberts on 05/25/2013.
//  Copyright (c) 2013 Greg Roberts. All rights reserved.
//

#import "StreamScreen.h"
#import "API.h"
#import "PhotoView.h"
#import "StreamPhotoScreen.h"
#import "CatScreen.h"

@interface StreamScreen(private)

-(void)refreshStream;
-(void)showStream:(NSArray*)stream;

@end

@implementation StreamScreen

@synthesize favImage;
@synthesize favName;
@synthesize totalStreamCount;
@synthesize streamList;

#pragma mark - View lifecycle

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.streamList = [NSArray array];
    self.navigationItem.title = @"FaveStar";
    self.navigationItem.rightBarButtonItem = btnCompose;
    self.navigationItem.leftBarButtonItem = btnRefresh;
	//show the photo stream
	[self refreshStream];
}



- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationLandscapeRight;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        return YES;
    }
    return NO;
}
 


//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//    [self showStream:self.streamList];
//}

-(IBAction)btnRefreshTapped {
    
	[self refreshStream];
}

-(void)refreshStream {
    
    self.totalStreamCount = 0;
    //just call the "stream" command from the web API
    [[API sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"stream", @"command", nil] onCompletion:^(NSDictionary *json) {
		//got stream
        self.totalStreamCount = ([json objectForKey:@"result"] != nil) ? [[json objectForKey:@"result"] count] : 0;
        self.streamList = ([json objectForKey:@"result"] != nil) ? [json objectForKey:@"result"] : [NSArray array];
		[self showStream:[json objectForKey:@"result"]];
	}];
}

-(void)showStream:(NSArray*)stream {
    // 1 remove old photos
    for (UIView* view in listView.subviews) {
        [view removeFromSuperview];
    }
    // 2 add new photo views
    for (int i=0;i<[stream count];i++) {
        NSDictionary* photo = [stream objectAtIndex:i];
        PhotoView* photoView = [[PhotoView alloc] initWithIndex:i andData:photo];
        photoView.delegate = self;
        [listView addSubview: photoView];
    }    
    // 3 update scroll list's height
    int listHeight = ([stream count]/3 + 1)*(kThumbSideH+kPadding);
    [listView setContentSize:CGSizeMake(320, listHeight)];
    [listView scrollRectToVisible:CGRectMake(0, 0, 10, 10) animated:YES];
}

-(void)didSelectPhoto:(PhotoView*)sender {
    //photo selected - show it full screen
    [self performSegueWithIdentifier:@"ShowPhoto" sender:[NSNumber numberWithInt:sender.tag]];   
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([@"ShowPhoto" compare: segue.identifier]==NSOrderedSame) {
        StreamPhotoScreen* streamPhotoScreen = segue.destinationViewController;
        
        
//        streamPhotoScreen.IdPhoto = sender;
        streamPhotoScreen.currentImageId = [sender intValue];
        streamPhotoScreen.totalPhotoCount = self.totalStreamCount;
        streamPhotoScreen.dataList = self.streamList;
    }
    else if ([@"ShowCategory" compare: segue.identifier] == NSOrderedSame) {
        CatScreen *catScreen = segue.destinationViewController;
        catScreen.favImage = self.favImage;
        catScreen.favImageName = self.favName;
    }
}


- (IBAction)showCameraView {
    
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
#if TARGET_IPHONE_SIMULATOR
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
#else
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
#endif
    [self presentModalViewController:imagePicker animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    self.favImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum([info objectForKey:UIImagePickerControllerOriginalImage], nil, nil, nil);
    }
    
    /*
    inputAlert = [[UIAlertView alloc] initWithTitle:@""
                                                      message:@"Name this fave.."
                                                     delegate:nil
                                            cancelButtonTitle:nil
                                            otherButtonTitles:nil];
    [inputAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    UITextField * alertTextField = [inputAlert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeDefault;
    [alertTextField setDelegate:self];
    [inputAlert show];
     */
    [imagePicker dismissModalViewControllerAnimated:YES];
    [self performSegueWithIdentifier:@"ShowCategory" sender:nil];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    self.favImage = nil;
    [picker dismissModalViewControllerAnimated:YES];
}

/*

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if(buttonIndex == 1) {
        UITextField *textField = ((UITextField*)[alertView textFieldAtIndex:0] != nil) ? (UITextField*)[alertView textFieldAtIndex:0] : nil;
        self.favName = (textField != nil) ? textField.text : @"";
        [self performSegueWithIdentifier:@"ShowCategory" sender:nil];
    }

    [imagePicker dismissModalViewControllerAnimated:YES];
}



- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [textField resignFirstResponder];
    self.favName = (textField != nil) ? textField.text : @"";
    [self performSegueWithIdentifier:@"ShowCategory" sender:nil];
    [inputAlert dismissWithClickedButtonIndex:1 animated:YES];
    [imagePicker dismissModalViewControllerAnimated:YES];
}
*/

@end
