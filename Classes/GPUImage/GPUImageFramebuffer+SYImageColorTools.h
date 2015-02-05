//
//  GPUImageFramebuffer+SYImageColorTools.h
//  TicTacDoh
//
//  Created by rominet on 03/02/15.
//  Copyright (c) 2015 Syan. All rights reserved.
//

#import "GPUImageFramebuffer.h"
#import "SYImageColorTools.h"

typedef void(^SYImageBytesBlock)(GLubyte *bytes, SYImageInfo info);

@interface GPUImageFramebuffer (SYImageColorTools)

- (void)getBytes:(SYImageBytesBlock)block;

@end
