//
//  UIImage+SYImageColorTools.h
//  TicTacDoh
//
//  Created by rominet on 04/02/15.
//  Copyright (c) 2015 Syan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYImageColorTools.h"

@interface UIImage (SYImageColorTools)

- (SYImageInfo)imageInfo;
- (UIColor *)colorAtPoint:(CGPoint)pixelPoint;
- (UIImage *)imageByTrimmingTransparentPixels;

@end
