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

@synthesize isInitialLoadDone;

#pragma mark - View lifecycle

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.streamList = [NSArray array];
    listView.refreshDelegate = self;
    
    self.navigationItem.title = @"FaveStar";
    [self hideCameraButton];

    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@""
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(showSettingsView)];
    
    [settingsButton setImage:[UIImage imageNamed:@"settings.png"]];
    settingsButton.tintColor = btnCompose.tintColor;
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:btnRefresh, settingsButton, nil]];
    
    [Utility addHeaderLogo:self.navigationController logo:HeaderLogoImage];
    [APP_DELEGATE.window addSubview:cameraButton];
    
    [listView showLoading];
	[self refreshStream]; //show the photo stream
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self addCameraButton];
    
    if ([[API sharedInstance] isAuthorized] && self.isInitialLoadDone == NO) {
        
        self.isInitialLoadDone = YES;
        [self showCameraView];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self hideCameraButton];
}

- (void)addCameraButton {
    
    cameraButton.frame = CGRectMake((self.view.bounds.size.height - (cameraButton.frame.size.width - 30)), (self.view.bounds.size.width - (cameraButton.frame.size.height)), cameraButton.frame.size.width, cameraButton.frame.size.height);
    [APP_DELEGATE.window addSubview:cameraButton];
    [Utility animateViewWithAlpha:1 duration:1 view:cameraButton];
}

- (void)hideCameraButton {
    
    [cameraButton removeFromSuperview];
    [Utility animateViewWithAlpha:0 duration:0 view:cameraButton];
}

-(IBAction)btnRefreshTapped {
    
	[self refreshStream];
}

-(void)refreshStream {
    
    self.totalStreamCount = 0;
    
    if([Utility isNetworkAvailable] && [Utility isAPIServerAvailable]) {
        //just call the "stream" command from the web API
        [[API sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"stream", @"command", nil] onCompletion:^(NSDictionary *json) {
            //got stream
            [listView stopLoading];
            self.streamList = ([json objectForKey:@"result"] != nil) ? [json objectForKey:@"result"] : self.streamList;
            self.totalStreamCount = (self.streamList != nil) ? [self.streamList count] : 0;
            [self showStream:self.streamList];
            
            [Utility writeArrayToPlist:FAVES_DATA_FILE data:self.streamList ];
        }];
    }
    else {
        [self loadFavesFromDevice];
        [listView stopLoading];
    }
}

- (void)loadFavesFromDevice {
    
    self.streamList = [Utility arrayFromFile:FAVES_DATA_FILE];
    self.totalStreamCount = (self.streamList != nil) ? [self.streamList count] : 0;
    [self showStream:self.streamList];
}

-(void)showStream:(NSArray*)stream {
    // 1 remove old photos
    for (UIView* view in listView.subviews) {
        if(view.tag != RefreshHeaderViewTag) {
            [view removeFromSuperview];
        }
    }
    // 2 add new photo views
    for (int i=0;i<[stream count];i++) {
        NSDictionary* photo = [stream objectAtIndex:i];
        PhotoView* photoView = [[PhotoView alloc] initWithIndex:i andData:photo];
        photoView.delegate = self;
        [listView addSubview: photoView];
    }    
    // 3 update scroll list's height
    int listHeight = ([stream count]/((IS_IPHONE_5) ? 3 : 2) + 1)*(kThumbSideH+kPadding);
    [listView setContentSize:CGSizeMake(320, listHeight)];
    [listView scrollRectToVisible:CGRectMake(0, 0, 10, 10) animated:YES];
}

-(void)didSelectPhoto:(PhotoView*)sender {
    //photo selected - show it full screen
    [self performSegueWithIdentifier:@"ShowPhoto" sender:[NSNumber numberWithInt:sender.tag]];   
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([@"ShowPhoto" compare: segue.identifier] == NSOrderedSame) {
        
        StreamPhotoScreen* streamPhotoScreen = segue.destinationViewController;
        streamPhotoScreen.currentImageId = [sender intValue];
        streamPhotoScreen.totalPhotoCount = self.totalStreamCount;
        streamPhotoScreen.dataList = self.streamList;
    }
    else if ([@"ShowCategory" compare: segue.identifier] == NSOrderedSame) {
        
        CatScreen *catScreen = segue.destinationViewController;
        catScreen.favImage = self.favImage;
        catScreen.favImageName = self.favName;
        catScreen.delegate = self;
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


- (void)showSettingsView {
    
    [self performSegueWithIdentifier:@"ShowSettings" sender:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    self.favImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum([info objectForKey:UIImagePickerControllerOriginalImage], nil, nil, nil);
    }
    
    [imagePicker dismissModalViewControllerAnimated:YES];
    [self performSegueWithIdentifier:@"ShowCategory" sender:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    self.favImage = nil;
    [picker dismissModalViewControllerAnimated:YES];
}

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

#pragma mark - GalleryDataDelegate

- (void)galleryDataDidChange {
    
    [self refreshStream];
}

#pragma mark - PullToRefreshScrollViewDelegate

-(void)refreshScrollView {
    
    [self refreshStream];
}

@end
