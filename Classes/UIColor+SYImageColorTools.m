//
//  UIColor+SYImageColorTools.m
//  TicTacDoh
//
//  Created by rominet on 04/02/15.
//  Copyright (c) 2015 Syan. All rights reserved.
//

#import "UIColor+SYImageColorTools.h"

@implementation UIColor (SYImageColorTools)

+ (UIColor *)colorWithSYPixel:(SYPixel)pixel
{
    return [self colorWithRed:pixel.r green:pixel.g blue:pixel.b alpha:pixel.a];
}

@end
