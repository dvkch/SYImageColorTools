//
//  UIImage+SYImageColorTools.h
//  SYImageColorTools
//
//  Created by Stanislas Chevallier on 04/02/15.
//  Copyright (c) 2015 Syan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYImageColorTools.h"

@interface UIImage (SYImageColorTools)

- (SYImageInfo)sy_imageInfo;
- (UIColor *)sy_colorAtPoint:(CGPoint)pixelPoint;
- (UIImage *)sy_imageByTrimmingTransparentPixels;

@end
