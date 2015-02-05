//
//  GPUImageFramebuffer+SYImageColorTools.m
//  TicTacDoh
//
//  Created by rominet on 03/02/15.
//  Copyright (c) 2015 Syan. All rights reserved.
//

#import "GPUImageFramebuffer+SYImageColorTools.h"
#import "GPUImageOutput.h"

void dataProviderReleaseCallback (void *info, const void *data, size_t size);
void dataProviderUnlockCallback (void *info, const void *data, size_t size);

@interface GPUImageFramebuffer () {
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
    CVPixelBufferRef renderTarget;
    CVOpenGLESTextureRef renderTexture;
    NSUInteger readLockCount;
#else
#endif
}

@end

@implementation GPUImageFramebuffer (SYImageColorTools)

- (void)getBytes:(SYImageBytesBlock)block
{
    runSynchronouslyOnVideoProcessingQueue(^{
        [GPUImageContext useImageProcessingContext];
        
        NSUInteger totalBytesForImage = (NSUInteger)self.size.width * (NSUInteger)self.size.height * 4;
        // It appears that the width of a texture must be padded out to be a multiple of 8 (32 bytes) if reading from it using a texture cache
        
        if ([GPUImageContext supportsFastTextureUpload])
        {
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
            SYImageInfo imgInfo = SYImageInfoCreateForOpenGLTexture((NSUInteger)self.size.width, (NSUInteger)self.size.height);
            imgInfo.bytesPerRow = CVPixelBufferGetBytesPerRow(self->renderTarget);
            imgInfo.bigEndian = NO;
            imgInfo.alphaFirst = NO;
            
            glFinish();
            CFRetain(self->renderTarget); // I need to retain the pixel buffer here and release in the data source callback to prevent its bytes from being prematurely deallocated during a photo write operation
            [self lockForReading];
            GLubyte *rawImagePixels = (GLubyte *)CVPixelBufferGetBaseAddress(self->renderTarget);
            [[GPUImageContext sharedFramebufferCache] addFramebufferToActiveImageCaptureList:self]; // In case the framebuffer is swapped out on the filter, need to have a strong reference to it somewhere for it to hang on while the image is in existence
            
            if(block)
                block(rawImagePixels, imgInfo);
            
            dataProviderUnlockCallback(NULL, (__bridge const void *)(self), 0);
#else
#endif
        }
        else
        {
            [self activateFramebuffer];
            GLubyte *rawImagePixels = (GLubyte *)malloc(totalBytesForImage);
            glReadPixels(0, 0, (int)self.size.width, (int)self.size.height, GL_RGBA, GL_UNSIGNED_BYTE, rawImagePixels);
            [self unlock]; // Don't need to keep this around anymore
            
            SYImageInfo imgInfo = SYImageInfoCreateForOpenGLTexture((NSUInteger)self.size.width, (NSUInteger)self.size.height);
            imgInfo.alphaFirst = NO;
            imgInfo.bigEndian = YES;
            imgInfo.bytesPerRow = 4 * imgInfo.width;
            
            if(block)
                block(rawImagePixels, imgInfo);
            
            dataProviderReleaseCallback(NULL, rawImagePixels, 0);
        }
    });
}

@end
