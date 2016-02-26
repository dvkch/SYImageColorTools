//
//  SYGPUImageFilterWhiteSpaceTrimmer.m
//  SYImageColorTools
//
//  Created by Stanislas Chevallier on 30/12/14.
//  Copyright (c) 2014 Syan. All rights reserved.
//

#import "SYGPUImageFilterWhiteSpaceTrimmer.h"
#import "GPUImageFramebuffer+SYImageColorTools.h"
#import "UIImage+SYImageColorTools.h"
#import "UIColor+SYImageColorTools.h"
#import "SYImageColorTools.h"

@implementation SYGPUImageFilterWhiteSpaceTrimmer

- (id)init
{
    self = [super initWithFragmentShaderFromString:kGPUImagePassthroughFragmentShaderString];
    if (self)
    {
        self.maxAlpha = 0.f;
        self.lastComputedCropRegion = CGRectMake(0, 0, 1, 1);
        
        __weak SYGPUImageFilterWhiteSpaceTrimmer *wSelf = self;
        [self setFrameProcessingCompletionBlock:^(GPUImageOutput *output, CMTime time) {
            [wSelf updateCropRegion];
        }];
    }
    
    return self;
}

- (void)setInputRotation:(GPUImageRotationMode)newInputRotation atIndex:(NSInteger)textureIndex;
{
    inputRotation = kGPUImageNoRotation;
}

- (void)updateCropRegion
{
    [outputFramebuffer getBytes:^(GLubyte *bytes, SYImageInfo imgInfo) {
        NSUInteger width  = (NSUInteger)floor([self outputFrameSize].width);
        NSUInteger height = (NSUInteger)floor([self outputFrameSize].height);
        
        UIEdgeInsets insets = SYImageDetermineEdgeInsetsToTrimTransparentPixels(bytes, imgInfo, self.maxAlpha);
        
        CGRect r = UIEdgeInsetsInsetRect(CGRectMake(0, 0, width, height), insets);
        self.lastComputedCropRegion = r;
        self.lastComputedCropRegionNormalized = CGRectMake(r.origin.x / (CGFloat)width,
                                                           r.origin.y / (CGFloat)height,
                                                           r.size.width  / (CGFloat)width,
                                                           r.size.height / (CGFloat)height);
        self.cropRegionDefined = YES;
    }];
}

@end


