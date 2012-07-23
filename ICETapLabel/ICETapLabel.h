//
//  ICETapLabel.h
//  ICEDK
//
//  Created by Icepat on 19/04/12.
//  Copyright (c) 2012 Icepat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICETapLabel : UIView {
    // UIlabel.
    UILabel *label_;
    
    // Linked hidden object, returned when you Tap the UILabel.
    id linkedObject_;
    
    // Target and action for Tap event.
    id target_;
    SEL action_;
}

@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) id linkedObject;

// Init.
- (id)init;
// Init with rect.
- (id)initWithRect:(CGRect)rect;
// Init with coder.
- (id)initWithCoder:(NSCoder*)coder;
// Set the self and UILabel frame.
- (void)setTheFrame:(CGRect)frame;
// Set target and action.
- (void)addTarget:(id)target action:(SEL)action;
// Get the text.
- (NSString*)text;
// Set the text.
- (void)setText:(NSString*)text;
// Set the text color.
- (void)setTextColor:(UIColor*)textColor;
// Set the background color.
- (void)setBackgroundColor:(UIColor*)backgroundColor;
// Set the label font.
- (void)setFont:(UIFont*)font;
@end
