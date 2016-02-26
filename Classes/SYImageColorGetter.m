//
//  SYImageColorGetter.m
//  SYImageColorTools
//
//  Created by Stanislas Chevallier on 22/12/14.
//  Copyright (c) 2014 Syan. All rights reserved.
//

#import "SYImageColorGetter.h"
#import "SYImageColorTools.h"
#import "UIImage+SYImageColorTools.h"

@interface SYImageColorGetter () {
@private
    const UInt8 *data;
    CFDataRef pixelData;
    CGDataProviderRef provider;
}
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, assign) SYImageInfo imageInfo;
@end

@implementation SYImageColorGetter

- (instancetype)initWithImage:(UIImage *)image
{
    if(!image)
        return nil;
    
    self = [super init];
    if (self)
    {
        self.imageInfo = image.sy_imageInfo;
        self.imageSize = image.size;
        
        self->provider = CGImageGetDataProvider(image.CGImage);
        self->pixelData = CGDataProviderCopyData(self->provider);
        self->data = CFDataGetBytePtr(self->pixelData);
    }
    return self;
}

- (BOOL)isPointInRange:(CGPoint)point
{
    return (point.x < self.imageSize.width && point.y < self.imageSize.height);
}

- (UIColor *)getColorAtPoint:(CGPoint)point
{
    if(![self isPointInRange:point]) return nil;
    
    return [UIColor colorWithRed:[self getRedAtPoint:point]
                           green:[self getGreenAtPoint:point]
                            blue:[self getBlueAtPoint:point]
                           alpha:[self getAlphaAtPoint:point]];
}

- (CGFloat)getRedAtPoint:(CGPoint)point
{
    return SYImageGetPixelValue(data, self.imageInfo, (NSUInteger)point.x, (NSUInteger)point.y, NO).r;
}

- (CGFloat)getGreenAtPoint:(CGPoint)point
{
    return SYImageGetPixelValue(data, self.imageInfo, (NSUInteger)point.x, (NSUInteger)point.y, NO).g;
}

- (CGFloat)getBlueAtPoint:(CGPoint)point
{
    return SYImageGetPixelValue(data, self.imageInfo, (NSUInteger)point.x, (NSUInteger)point.y, NO).b;
}

- (CGFloat)getAlphaAtPoint:(CGPoint)point
{
    return SYImageGetPixelValue(data, self.imageInfo, (NSUInteger)point.x, (NSUInteger)point.y, YES).a;
}

- (void)dealloc
{
    if(self->pixelData)
        CFRelease(self->pixelData);
    if(self->provider)
        CFRelease(self->provider);
}

@end
