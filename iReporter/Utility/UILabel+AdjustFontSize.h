//
//  UILabel+AdjustFontSize.h
//  gFaves
//
//  Created by Adarsh M on 6/13/13.
//  Copyright (c) 2013 Greg Roberts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UILabel (UILabel_AdjustFontSize)

- (void) adjustsFontSizeToFitWidthWithMultipleLinesFromFontWithName:(NSString*)fontName size:(NSInteger)fsize andDescreasingFontBy:(NSInteger)dSize;

@end
