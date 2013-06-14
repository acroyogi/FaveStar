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
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self loadScrollViewWithImages];
    [self setInitialPage];
    [self loadVewWithData];
}

- (void)loadVewWithData {

    NSDictionary *data = [self.dataList objectAtIndex:self.currentImageId];

    NSString *date = [[data objectForKey:@"DATETIME_CREATE"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *zone = [[data objectForKey:@"TIMEZONE_CREATE"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    zone = ([zone hasPrefix:@"+"] == NO && [zone hasPrefix:@"-"] == NO) ? [NSString stringWithFormat:@"GMT+%@", zone ] : [NSString stringWithFormat:@"GMT%@", zone ];
    
    NSString *dateString = [NSString stringWithFormat:@"%@ %@", date, zone];

    self.IdPhoto = [NSNumber numberWithInt:[[data objectForKey:@"IdPhoto"] intValue]];
    lblTitle.text = [data objectForKey:@"title"];
    lblDate.text = [Utility timeToString:[Utility dateFromString:dateString]]; // @"Yesterday";
    lblLocation.text = [data objectForKey:@"LOC_ID"];
    lblUserName.text = [NSString stringWithFormat:@"★%@", [data objectForKey:@"username"]];
    
    [lblTitle adjustsFontSizeToFitWidthWithMultipleLinesFromFontWithName:lblTitle.font.fontName size:23 andDescreasingFontBy:5];
    
    catIconView.image = [UIImage imageNamed:[Utility catImageNameById:[[data objectForKey:@"CAT_ID"] intValue]]];
}

- (void)loadScrollViewWithImages {
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * dataList.count, self.view.frame.size.height);
    scrollView.pagingEnabled = YES;
    
    CGFloat xPos = 0.0;
    
    for (NSDictionary *imageDetails in self.dataList) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(xPos, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [scrollView addSubview:imageView];
        xPos += self.view.frame.size.width;
        
        NSURL* imageURL = [[API sharedInstance] urlForImageWithId:[NSNumber numberWithInt:[[imageDetails objectForKey:@"IdPhoto"] intValue]] isThumb:NO];
        [imageView setImageWithURL: imageURL];
    }

}

- (void)setInitialPage {
    [scrollView setContentOffset:CGPointMake(scrollView.frame.size.width * self.currentImageId, 0.0f) animated:YES];
}

#pragma mark - UIScrollView delegate method

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if(page != self.currentImageId) {
        self.currentImageId = page;
        [self loadVewWithData];
    }
}

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

@end
