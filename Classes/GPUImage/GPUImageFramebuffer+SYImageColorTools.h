//
//  GPUImageFramebuffer+SYImageColorTools.h
//  SYImageColorTools
//
//  Created by Stanislas Chevallier on 03/02/15.
//  Copyright (c) 2015 Syan. All rights reserved.
//

#import "GPUImageFramebuffer.h"
#import "SYImageColorTools.h"

typedef void(^SYImageBytesBlock)(GLubyte *bytes, SYImageInfo info);

@interface GPUImageFramebuffer (SYImageColorTools)

- (void)sy_getBytes:(SYImageBytesBlock)block;

@end
