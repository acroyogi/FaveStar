//
//  StreamPhotoScreen.m
//  FaveStar
//
//  Created by Greg Roberts on 05/25/2013.
//  Copyright (c) 2013 Greg Roberts. All rights reserved.
//

// THIS VIEW SHOWS A SINGLE FAVE WITH TITLE

#import "StreamPhotoScreen.h"
#import "API.h"

#define kAPIIconImgPathX @"http://www.favestar.net/_img/ui/icons/cats/numbers/"

@implementation StreamPhotoScreen

@synthesize IdPhoto;
@synthesize IdCat;

@synthesize totalPhotoCount;
@synthesize dataList;
@synthesize currentImageId;

-(void)viewDidLoad {
    
	[super viewDidLoad];
    loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(60, 160, 200, 80)];
    [self hideLoadingView];

    [self loadVewWithData];
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRecognizer:)];
    [rightSwipe setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:rightSwipe];
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRecognizer:)];
    [leftSwipe setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:leftSwipe];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self showLoadingView];
}

- (void)swipeRecognizer:(UISwipeGestureRecognizer *)sender {
    
    int imageId = self.currentImageId;
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        imageId = (imageId > 0) ? (imageId  - 1) : 0;
    }
    else if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        imageId = (imageId < (self.totalPhotoCount - 2)) ? (imageId  + 1) : (self.totalPhotoCount - 1);
    }
    if(imageId != self.currentImageId) {
        self.currentImageId = imageId;
        [self loadVewWithData];
    }
}

- (void)loadVewWithData {

//    [self showLoadingView];
    NSDictionary *data = [self.dataList objectAtIndex:self.currentImageId];

    self.IdPhoto = [NSNumber numberWithInt:[[data objectForKey:@"IdPhoto"] intValue]];
    
    //lblTitle.text = [data objectForKey:@"title"];
    
	//load the caption of the selected photo
	[[API sharedInstance] commandWithParams:[NSMutableDictionary
                            dictionaryWithObjectsAndKeys:
                            @"stream", @"command",
                            self.IdPhoto, @"IdPhoto",
                            nil]
              onCompletion:^(NSDictionary *json) {
                  [self hideLoadingView];
                  //show the text in the label
                  NSArray* list = [json objectForKey:@"result"];
                  NSDictionary* photo = [list objectAtIndex:0];
                  lblTitle.text = [photo objectForKey:@"title"];
              }
     ];
    
	//load the big size photo
	NSURL* imageURL = [[API sharedInstance] urlForImageWithId:self.IdPhoto isThumb:NO];
	[photoView setImageWithURL: imageURL];
    
    NSURL* catURL = [[API sharedInstance] urlForCatWithId:[data objectForKey:@"CAT_ID"]];
    [catIconView setImageWithURL: catURL];
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

/*
- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape; // etc
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        return YES;
    }
    return NO;
}
 */

- (void)showLoadingView {
    
    if(loadingView != nil) {
        [self hideLoadingView];
        loadingView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
        [self.view performSelectorOnMainThread:@selector(addSubview:) withObject:loadingView waitUntilDone:NO];
    }
}

- (void)hideLoadingView {
    
    if(loadingView != nil) {
        [loadingView performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
    }
}

- (IBAction)closeView:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

@end
