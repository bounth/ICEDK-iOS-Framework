//
//  ICEView+Utilities.m
//  ICEDK
//
//  Created by Icepat on 19/04/12.
//  Copyright (c) 2012 Icepat. All rights reserved.
//

#import "ICEView+Utilities.h"

@implementation UIView (Utilities)

// Get the size.
- (CGSize)size{
	CGRect frame = [self frame];
	return frame.size;
}

// Set the size.
- (void)setSize:(CGSize)size{
	CGRect frame = [self frame];
	frame.size.width = round(size.width);
	frame.size.height = round(size.height);
	[self setFrame:frame];
}

// Set the position on X and Y.
- (void)positionAtX:(double)positionX andY:(double)positionY{
	CGRect frame = [self frame];
	frame.origin.x = round(positionX);
	frame.origin.y = round(positionY);
	[self setFrame:frame];
}

// Remove all the subviews.
- (void)removeSubviews{
	for(UIView *view in self.subviews) {
		[view removeFromSuperview];
	}
}

// Render an UIImage from UIView.
- (UIImage *)renderImageFromView{
	return [self renderImageFromViewWithRect:self.bounds];
}

// Render an UIImage from UIView with a rect.
- (UIImage *)renderImageFromViewWithRect:(CGRect)frame{
    // Create a new context of the desired size to render the image
	UIGraphicsBeginImageContextWithOptions(frame.size, YES, 0);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// Translate it, to the desired position
	CGContextTranslateCTM(context, -frame.origin.x, -frame.origin.y);
    
    // Render the view as image
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // Fetch the image   
    UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Cleanup
    UIGraphicsEndImageContext();
    
    return renderedImage;
}

@end
