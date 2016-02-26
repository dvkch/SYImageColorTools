//
//  UIImage+SYImageColorTools.m
//  SYImageColorTools
//
//  Created by Stanislas Chevallier on 04/02/15.
//  Copyright (c) 2015 Syan. All rights reserved.
//

#import "UIImage+SYImageColorTools.h"
#import "SYImageColorTools.h"
#import "UIColor+SYImageColorTools.h"

@implementation UIImage (SYImageColorTools)

- (SYImageInfo)sy_imageInfo
{
    CGImageRef cgImage = self.CGImage;
    
    SYImageInfo info;
    info.width = CGImageGetWidth(cgImage);
    info.height = CGImageGetHeight(cgImage);
    info.bytesPerRow = CGImageGetBytesPerRow(cgImage);
    
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(cgImage);
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(cgImage);
    
    info.alphaPremultiplied = (alphaInfo & kCGImageAlphaPremultipliedLast) || (alphaInfo & kCGImageAlphaPremultipliedFirst);
    info.alphaFirst = (alphaInfo & kCGImageAlphaFirst) ? YES : NO;
    info.bigEndian = (bitmapInfo & kCGBitmapByteOrder32Big) ? YES : NO;
    info.alphaOnly = NO; //(alphaInfo & kCGImageAlphaOnly);
    
    return info;
}

- (UIColor *)sy_colorAtPoint:(CGPoint)pixelPoint
{
    if (pixelPoint.x > self.size.width || pixelPoint.y > self.size.height)
        return nil;
    
    CGDataProviderRef provider = CGImageGetDataProvider(self.CGImage);
    CFDataRef pixelData = CGDataProviderCopyData(provider);
    const UInt8* data = CFDataGetBytePtr(pixelData);
    
    UIColor *color = [UIColor sy_colorWithSYPixel:SYImageGetPixelValue(data, self.sy_imageInfo, (NSUInteger)pixelPoint.x, (NSUInteger)pixelPoint.y, NO)];
    
    CFRelease(pixelData);
    //CGDataProviderRelease(provider);
    
    return color;
}


// https://gist.github.com/spinogrizz/3549921
- (UIImage *)sy_imageByTrimmingTransparentPixels
{
    SYImageInfo imageInfo = self.sy_imageInfo;
    
    if (imageInfo.width < 2 || imageInfo.height < 2)
        return self;
    
    //allocate array to hold alpha channel
    uint8_t *bitmapData = calloc(imageInfo.width * imageInfo.height, sizeof(uint8_t));
    
    //create alpha-only bitmap context
    CGContextRef contextRef = CGBitmapContextCreate(bitmapData, imageInfo.width, imageInfo.height, 8, imageInfo.width, NULL, (CGBitmapInfo)kCGImageAlphaOnly);
    
    //draw our image on that context
    CGImageRef cgImage = self.CGImage;
    CGRect rect = CGRectMake(0, 0, imageInfo.width, imageInfo.height);
    CGContextDrawImage(contextRef, rect, cgImage);
    
    imageInfo.alphaOnly = YES;
    imageInfo.bytesPerRow = imageInfo.width;
    UIEdgeInsets crop = SYImageDetermineEdgeInsetsToTrimTransparentPixels(bitmapData, imageInfo, 0.);
    
    free(bitmapData);
    CFRelease(contextRef);
    
    if (crop.top == 0 && crop.bottom == 0 && crop.left == 0 && crop.right == 0) {
        return self;
    }
    else {
        //calculate new crop bounds
        rect.origin.x += crop.left;
        rect.origin.y += crop.top;
        rect.size.width -= crop.left + crop.right;
        rect.size.height -= crop.top + crop.bottom;
        
        //crop it
        CGImageRef newImage = CGImageCreateWithImageInRect(cgImage, rect);
        UIImage *image = [UIImage imageWithCGImage:newImage];
        
        if(newImage)
            CFRelease(newImage);
        
        return image;
    }
}

@end
