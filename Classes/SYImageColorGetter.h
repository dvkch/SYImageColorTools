//
//  SYImageColorGetter.h
//  TicTacDoh
//
//  Created by rominet on 22/12/14.
//  Copyright (c) 2014 Syan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYImageColorGetter : NSObject

- (instancetype)initWithImage:(UIImage *)image;

- (UIColor *)getColorAtPoint:(CGPoint)point;
- (CGFloat)getRedAtPoint:(CGPoint)point;
- (CGFloat)getGreenAtPoint:(CGPoint)point;
- (CGFloat)getBlueAtPoint:(CGPoint)point;
- (CGFloat)getAlphaAtPoint:(CGPoint)point;

@end
