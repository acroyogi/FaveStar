//
//  PhotoView.m
//  FaveStar
//
//  Created by Greg Roberts on 05/25/2013.
//  Copyright (c) 2013 Greg Roberts. All rights reserved.
//

// THIS VIEW SHOWS THE 36 MOST RECENT FAVES AS THUMBNAILS in 3 COLUMNS


#import "PhotoView.h"
#import "API.h"

@implementation PhotoView

@synthesize delegate;

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithIndex:(int)i andData:(NSDictionary*)data {
    self = [super init];
    if (self !=nil) {
        
        //initialize
        self.tag = i; //[[data objectForKey:@"IdPhoto"] intValue];
        
        int row = i/((IS_IPHONE_5) ? 3 : 2);
        int col = i % ((IS_IPHONE_5) ? 3 : 2);
        
        self.frame = CGRectMake(
                                1.5*kPadding+col*(kThumbSideW+kPadding),
                                2.5*kPadding+row*(kThumbSideH+kPadding),
                                kThumbSideW,
                                kThumbSideH);
        self.backgroundColor = [UIColor grayColor];
        
        //add the photo caption
        UILabel* caption = [[UILabel alloc] initWithFrame:CGRectMake(0, kThumbSideH-16, kThumbSideW, 16)];
        caption.backgroundColor = [UIColor blackColor];
        caption.textColor = [UIColor whiteColor];
        caption.textAlignment = UITextAlignmentLeft;
        caption.font = [UIFont systemFontOfSize:12];
        caption.text = [NSString stringWithFormat:@"       %@ : +%@", [data objectForKey:@"title"], [data objectForKey:@"username"]];
        //caption.text = [NSString stringWithFormat:@" %@ : %@ : +%@", [data objectForKey:@"CAT_ID"], [data objectForKey:@"title"], [data objectForKey:@"username"]];
        // caption.text = [NSString stringWithFormat:@" %@ : +%@", [data objectForKey:@"title"], [data objectForKey:@"username"]];
        // caption.text = [NSString stringWithFormat:@" %@ : @%@",[data objectForKey:@"username"]];
        [self addSubview: caption];
        
		//add touch event
		[self addTarget:delegate action:@selector(didSelectPhoto:) forControlEvents:UIControlEventTouchUpInside];
        
		//load the image
		API* api = [API sharedInstance];

        // load the thumbnail
        int IdPhoto = [[data objectForKey:@"IdPhoto"] intValue];
		NSURL* imageURL = [api urlForImageWithId:[NSNumber numberWithInt: IdPhoto] isThumb:YES];
        
		AFImageRequestOperation* imageOperation = [AFImageRequestOperation imageRequestOperationWithRequest: [NSURLRequest requestWithURL:imageURL] success:^(UIImage *image) {
			//create an image view, add it to the view
			UIImageView* thumbView = [[UIImageView alloc] initWithImage: image];
            thumbView.frame = CGRectMake(0,0,kThumbSideW,kThumbSideH);
            thumbView.contentMode = UIViewContentModeScaleAspectFill;
            thumbView.clipsToBounds = YES;

            
			[self insertSubview: thumbView belowSubview: caption];
		}];
        
        NSURL* catImageURL = [api urlForCatWithId:[data objectForKey:@"CAT_ID"]];
        
		AFImageRequestOperation* catImageOperation = [AFImageRequestOperation imageRequestOperationWithRequest: [NSURLRequest requestWithURL:catImageURL] success:^(UIImage *image) {
			//create an image view, add it to the view
			UIImageView* catImageView = [[UIImageView alloc] initWithImage: image];
            catImageView.frame = CGRectMake(3,kThumbSideH-20,18,18);
            catImageView.contentMode = UIViewContentModeScaleAspectFill;
            catImageView.clipsToBounds = YES;
			[self insertSubview: catImageView aboveSubview:caption];
		}];

        NSOperationQueue* queue = [[NSOperationQueue alloc] init];
		[queue addOperation:imageOperation];
        [queue addOperation:catImageOperation];
    }
    
    self.backgroundColor = [UIColor clearColor];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    
    return self;
}

@end
