//
//  SYImageColorTools.m
//  TicTacDoh
//
//  Created by rominet on 04/02/15.
//  Copyright (c) 2015 Syan. All rights reserved.
//

#import "SYImageColorTools.h"

SYImageInfo SYImageInfoCreateForOpenGLTexture(NSUInteger w, NSUInteger h)
{
    SYImageInfo info;
    info.width = w;
    info.height = h;
    info.bytesPerRow = w * 4;
    info.alphaOnly = NO;
    info.alphaFirst = NO;
    info.alphaPremultiplied = YES;
    info.bigEndian = YES;
    return info;
}

SYPixel SYImageGetPixelValue(const uint8_t *data, SYImageInfo info, NSUInteger x, NSUInteger y, BOOL onlyAlpha)
{
    NSUInteger pixelInfo = y * info.bytesPerRow + x * (info.alphaOnly ? 1 : 4);
    
    SYPixel pixel = {0., 0., 0., 0.};
    pixel.a = (CGFloat)data[pixelInfo + ((info.alphaFirst || info.alphaOnly) ? 0 : 3)] / 255.f;
    
    NSUInteger indexDelta = (info.alphaFirst ? 1 : 0);
    
    if(!info.alphaOnly && !onlyAlpha)
    {
        if(info.bigEndian)
        {
            pixel.r = (CGFloat)data[pixelInfo + indexDelta + 0] / 255.f;
            pixel.g = (CGFloat)data[pixelInfo + indexDelta + 1] / 255.f;
            pixel.b = (CGFloat)data[pixelInfo + indexDelta + 2] / 255.f;
        }
        else
        {
            pixel.r = (CGFloat)data[pixelInfo + indexDelta + 2] / 255.f;
            pixel.g = (CGFloat)data[pixelInfo + indexDelta + 1] / 255.f;
            pixel.b = (CGFloat)data[pixelInfo + indexDelta + 0] / 255.f;
        }
        
        if(info.alphaPremultiplied)
        {
            pixel.r = (pixel.a == 0 ? 0 : pixel.r / pixel.a);
            pixel.g = (pixel.a == 0 ? 0 : pixel.g / pixel.a);
            pixel.g = (pixel.a == 0 ? 0 : pixel.b / pixel.a);
        }
    }
    
    return pixel;
}

UIEdgeInsets SYImageDetermineEdgeInsetsToTrimTransparentPixels(const uint8_t *data, SYImageInfo info, CGFloat maxAlpha)
{
    UIEdgeInsets crop = UIEdgeInsetsZero;
    
    BOOL stopTop = NO;
    BOOL stopBottom = NO;
    for(NSUInteger yTop = 0; yTop < info.height; ++yTop)
    {
        for(NSUInteger x = 0; x < info.width; ++x)
        {
            if(!stopTop)
                if(SYImageGetPixelValue(data, info, x, yTop,                     YES).a > maxAlpha)
                    stopTop = YES;
            
            if(!stopBottom)
                if(SYImageGetPixelValue(data, info, x, (info.height - 1 - yTop), YES).a > maxAlpha)
                    stopBottom = YES;
            
            if(stopTop && stopBottom)
                break;
        }
        
        if(!stopTop)    crop.top    += 1;
        if(!stopBottom) crop.bottom += 1;
        
        if(stopTop && stopBottom)
            break;
    }
    
    BOOL stopLeft = NO;
    BOOL stopRight = NO;
    for(NSUInteger xLeft = 0; xLeft < info.width; ++xLeft)
    {
        for(NSUInteger y = (NSUInteger)crop.top; y < info.height - (NSUInteger)crop.bottom; ++y)
        {
            if(!stopLeft)
                if(SYImageGetPixelValue(data, info, xLeft,                    y, YES).a > maxAlpha)
                    stopLeft = YES;
            
            if(!stopRight)
                if(SYImageGetPixelValue(data, info, (info.width - 1 - xLeft), y, YES).a > maxAlpha)
                    stopRight = YES;
            
            if(stopLeft && stopRight)
                break;
        }
        
        if(!stopLeft)  crop.left  += 1;
        if(!stopRight) crop.right += 1;
        
        if(stopLeft && stopRight)
            break;
    }
    
    return crop;
}


// The commented approach is easier to understand (projects on a line and a column, determine start and end on X and Y)
// but is slower as it goes through all pixels.
// Method above will read at most 100% of pixels (for images of size > 2x2) but may read way less

/*
UIEdgeInsets determineEdgeInsetsToTrimTransparentPixels(uint8_t *data, SYImageInfo info, CGFloat maxAlpha)
{
    //summ all non-transparent pixels in every row and every column
    uint16_t *rowSum = calloc(info.height, sizeof(uint16_t));
    uint16_t *colSum = calloc(info.width, sizeof(uint16_t));
    
    //enumerate through all pixels
    for (NSUInteger row = 0; row < info.height; row++) {
        for (NSUInteger col = 0; col < info.width; col++)
        {
            if (getPixelValue(data, info, col, row, YES).a > maxAlpha ) {
                rowSum[row]++;
                colSum[col]++;
            }
        }
    }
    
    //initialize crop insets and enumerate cols/rows arrays until we find non-empty columns or row
    UIEdgeInsets crop = UIEdgeInsetsMake(0, 0, 0, 0);
    
    // top
    for (int i = 0; i < (int)info.height; i++) {
        if ( rowSum[i] > 0 ) {
            crop.top = i; break;
        }
    }
    
    // bottom
    for (int i = (int)info.height; i >= 0; i--) {
        if ( rowSum[i] > 0 ) {
            crop.bottom = MAX(0, (CGFloat)((int)info.height-i-1));
            break;
        }
    }
    
    // left
    for (int i = 0; i < (int)info.width; i++) {
        if ( colSum[i] > 0 ) {
            crop.left = i; break;
        }
    }
    
    // right
    for (int i = (int)info.width; i >= 0; i--) {
        if ( colSum[i] > 0 ) {
            crop.right = MAX(0, (CGFloat)((int)info.width-i-1));
            break;
        }
    }
    
    free(colSum);
    free(rowSum);
    
    return crop;
}
*/