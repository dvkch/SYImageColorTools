//
//  SYImageColorTools.h
//  TicTacDoh
//
//  Created by rominet on 04/02/15.
//  Copyright (c) 2015 Syan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    CGFloat r;
    CGFloat g;
    CGFloat b;
    CGFloat a;
} SYPixel;

typedef struct {
    NSUInteger width;
    NSUInteger height;
    NSUInteger bytesPerRow;
    BOOL alphaOnly;
    BOOL alphaFirst;
    BOOL alphaPremultiplied;
    BOOL bigEndian;
} SYImageInfo;

SYImageInfo SYImageInfoCreateForOpenGLTexture(NSUInteger w, NSUInteger h);
SYPixel SYImageGetPixelValue(const uint8_t *data, SYImageInfo info, NSUInteger x, NSUInteger y, BOOL onlyAlpha);
UIEdgeInsets SYImageDetermineEdgeInsetsToTrimTransparentPixels(const uint8_t *data, SYImageInfo imageInfo, CGFloat maxAlpha);

