//
//  ICEView+Utilities.h
//  ICEDK
//
//  Created by Icepat on 19/04/12.
//  Copyright (c) 2012 Icepat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface UIView (Utilities)

// Get the size.
- (CGSize)size;
// Set the size.
- (void)setSize:(CGSize)size;
// Set the position on X and Y.
- (void)positionAtX:(double)positionX andY:(double)positionY;
// Remove all the subviews.
- (void)removeSubviews;
// Render an UIImage from UIView.
- (UIImage *)renderImageFromView;
// Render an UIImage from UIView with a rect.
- (UIImage *)renderImageFromViewWithRect:(CGRect)frame;

@end
