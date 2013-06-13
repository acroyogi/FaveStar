//
//  UILabel+AdjustFontSize.m
//  gFaves
//
//  Created by Adarsh M on 6/13/13.
//  Copyright (c) 2013 Greg Roberts. All rights reserved.
//

#import "UILabel+AdjustFontSize.h"

@implementation UILabel (UILabel_AdjustFontSize)

- (void) adjustsFontSizeToFitWidthWithMultipleLinesFromFontWithName:(NSString*)fontName size:(NSInteger)fsize andDescreasingFontBy:(NSInteger)dSize{
    
    //Largest size used
    self.font = [UIFont fontWithName:fontName size:fsize];
    
    //Calculate size of the rendered string with the current parameters
    float height = [self.text sizeWithFont:self.font
                         constrainedToSize:CGSizeMake(self.bounds.size.width,99999)
                             lineBreakMode:UILineBreakModeWordWrap].height;
    
    //Reduce font size by dSize while too large, break if no height (empty string)
    while (height > self.bounds.size.height && height != 0) {
        fsize -= dSize;
        self.font = [UIFont fontWithName:fontName size:fsize];
        height = [self.text sizeWithFont:self.font
                       constrainedToSize:CGSizeMake(self.bounds.size.width,99999)
                           lineBreakMode:UILineBreakModeWordWrap].height;
    };
    
    // Loop through words in string and resize to fit
    for (NSString *word in [self.text componentsSeparatedByString:@" "]) {
        float width = [word sizeWithFont:self.font].width;
        while (width > self.bounds.size.width && width != 0) {
            fsize -= dSize;
            self.font = [UIFont fontWithName:fontName size:fsize];
            width = [word sizeWithFont:self.font].width;
        }
    }
}

@end
