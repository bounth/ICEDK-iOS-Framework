//
//  ICERichTextLabel.h
//  ICEDK
//
//  Created by Icepat on 27/04/12.
//  Copyright (c) 2012 Icepat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICERichTextStyle.h"
#import "ICETapLabel.h"

@class ICERichTextStyle;
@interface ICERichTextLabel : UIView {
    @private
    // Prefix for the custom formated texts.
	NSMutableDictionary *prefixTextStyles_;
    
    // Text sliced in parts.
	NSMutableArray *textParts_;
    
    // Main style for the normal text.
    ICERichTextStyle *textStyle_;
    
    // Objects linked to the custom texts.
    NSDictionary *linkedObjects_;
    
    // Positions & sizes used for drawing.
    CGPoint currentPosition_;
    NSUInteger maxHeight_;
  	CGSize measureSize_;
    CGSize returnSize_;
}

@property (nonatomic, retain) NSDictionary *linkedObjects;

// Init.
- (id)initWithWidth:(CGFloat)width;
- (id)initWithFrame:(CGRect)frame;
- (id)initWithCoder:(NSCoder*)coder;

// Set the text.
- (void)setText:(NSString*)text;
// Set the main style.
- (void)setStyle:(ICERichTextStyle*)style;
// Add a rich style.
- (void)addRichStyle:(ICERichTextStyle*)style;

@end
