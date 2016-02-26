//
//  SYGPUImageFilterWhiteSpaceTrimmer.h
//  SYImageColorTools
//
//  Created by Stanislas Chevallier on 30/12/14.
//  Copyright (c) 2014 Syan. All rights reserved.
//

#import "GPUImageCropFilter.h"

@interface SYGPUImageFilterWhiteSpaceTrimmer : GPUImageFilter

@property (nonatomic, assign) CGFloat maxAlpha;
@property (nonatomic, assign) CGRect lastComputedCropRegion;
@property (nonatomic, assign) CGRect lastComputedCropRegionNormalized;
@property (nonatomic, assign) BOOL cropRegionDefined;

@end
