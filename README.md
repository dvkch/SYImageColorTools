# SYImageColorTools
It's always a hassle to get pixel information of an UIImage. Let's remedy that!


Use pod `SYImageColorTools/GPUImage` to enjoy the same methods with data coming from `GPUImageFramebuffer` objects.


###SYImageColorGetter

Pretty straightforward class, to access pixels of an image. Its only goal is to keep the image data in memory so that if you have multiple pixels to get you reduce the buffer allocation overhead.

	@interface SYImageColorGetter : NSObject

	- (instancetype)initWithImage:(UIImage *)image;

	- (UIColor *)getColorAtPoint:(CGPoint)point;
	- (CGFloat)getRedAtPoint:(CGPoint)point;
	- (CGFloat)getGreenAtPoint:(CGPoint)point;
	- (CGFloat)getBlueAtPoint:(CGPoint)point;
	- (CGFloat)getAlphaAtPoint:(CGPoint)point;
	
	@end


###SYImageColorTools

Allows getting pixels value from a buffer, created from an  OpenGL texture (when using GPUImage for instance) or an `UIImage`

It defines multiple types:

- `SYPixel`: struct containing r, g, b and a data for a pixel
- `SYImageInfo`: struct containing the required information about the buffer to understand it; used by `SYImageGetPixelValue` and `SYImageDetermineEdgeInsetsToTrimTransparentPixels`

Here is the header:

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
	
	// Create a basic SYImageInfo struct for a GPUImage based buffer 
	SYImageInfo SYImageInfoCreateForOpenGLTexture(NSUInteger w, NSUInteger h);
	
	// Get pixel value in a given buffer, understandable with the SYImageInfo parameter
	SYPixel SYImageGetPixelValue(const uint8_t *data, SYImageInfo info, NSUInteger x, NSUInteger y, BOOL onlyAlpha);
	
	// Returns the number of lines and columns to remove from the image on each side to remove all completely transparent lines
	UIEdgeInsets SYImageDetermineEdgeInsetsToTrimTransparentPixels(const uint8_t *data, SYImageInfo imageInfo, CGFloat maxAlpha);

###UIColor+SYImageColorTools

Simple category to create a `UIColor` from a `SYPixel` struct

	@interface UIColor (SYImageColorTools)
	
	+ (UIColor *)colorWithSYPixel:(SYPixel)pixel;
	
	@end

###UIImage+SYImageColorTools

Category bringing higher level methods for `SYImageColorTools` functions  

	@interface UIImage (SYImageColorTools)
	
	- (SYImageInfo)imageInfo;
	- (UIColor *)colorAtPoint:(CGPoint)pixelPoint;
	- (UIImage *)imageByTrimmingTransparentPixels;

	@end

#SYImageColorTools/GPUImage

Additions to `GPUImage` to work with `SYImageColorTools` allowing you to read data from then OpenGL buffer of a filter.

###GPUImageFramebuffer+SYImageColorTools

Helps using `SYImageColorTools` with `GPUImageFramebuffer` by obtaining a buffer and the appriopriate image info.

	typedef void(^SYImageBytesBlock)(GLubyte *bytes, SYImageInfo info);
	
	@interface GPUImageFramebuffer (SYImageColorTools)
	
	- (void)getBytes:(SYImageBytesBlock)block;
	
	@end

###SYGPUImageFilterWhiteSpaceTrimmer

`GPUImage` filter that will compute the crop region each time it has the chance, and give you access to those values. The computation is done on the CPU since I wouldn't know how to it and the crop on the GPU. The crop isn't done at all, you will need to use the `lastComputedCropRegion` property to crop it yourself. Sorry ¯\\_(ツ)_/¯

	@interface SYGPUImageFilterWhiteSpaceTrimmer : GPUImageFilter
	
	@property (nonatomic, assign) CGFloat maxAlpha;
	@property (nonatomic, assign) CGRect lastComputedCropRegion;
	@property (nonatomic, assign) CGRect lastComputedCropRegionNormalized;
	@property (nonatomic, assign) BOOL cropRegionDefined;
	
	@end
