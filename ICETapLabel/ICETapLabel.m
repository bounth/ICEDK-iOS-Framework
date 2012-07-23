//
//  ICETapLabel.m
//  ICEDK
//
//  Created by Icepat on 19/04/12.
//  Copyright (c) 2012 Icepat. All rights reserved.
//

#import "ICETapLabel.h"
#import "ICEView+Utilities.h"

@interface ICETapLabel()
// Handle the Tap events.
- (void)handleTouch;
@end

@implementation ICETapLabel
@synthesize label = label_;
@synthesize linkedObject = linkedObject_;

#pragma mark - Init.
// Init.
- (id)init{
    self = [super init];
    if (self){
        label_ = [[UILabel alloc] init];
        [label_ setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

// Init with rect.
- (id)initWithRect:(CGRect)rect{
    self = [self init];
    if (self){
        [self setTheFrame:rect];
    }
    return self;
}

// Init with coder.
- (id)initWithCoder:(NSCoder*)coder{
    if ((self = [super initWithCoder:coder])) {
        label_ = [[UILabel alloc] init];
        [label_ setBackgroundColor:[UIColor clearColor]];
        [self setTheFrame:self.frame];        
	}
	return self;
}

- (void)dealloc{
    [label_ release];
    [linkedObject_ release];
    [target_ release];
    [super dealloc];
}

#pragma mark - Tap on label handler.
// Set the self and UILabel frame.
- (void)setTheFrame:(CGRect)frame{
    [self removeSubviews];
    
    // UILabel is on the entire view.
    [label_ setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    
    self.frame = frame;
    [self addSubview:label_];
}

#pragma mark - Target/action/touch management.
// Set target and action.
- (void)addTarget:(id)target action:(SEL)action{
    target_ = [target retain];
    action_ = action;
    
    // Init tap gesture recognizer.
    UITapGestureRecognizer *touchGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTouch)];
    [self addGestureRecognizer:touchGesture];

    // Clean.
    [touchGesture release];
}

// Handle the Tap events.
- (void)handleTouch{
    [target_ performSelector:action_ withObject:self];
}

#pragma mark - UILabel compatibility.
// Get the text.
- (NSString*)text{
    return [label_ text];
}

// Set the text.
- (void)setText:(NSString*)text{
    [label_ setText:text];
    
    // UILabel is on the entire view.
    [label_ setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];    
}

// Set the text color.
- (void)setTextColor:(UIColor*)textColor{
    [label_ setTextColor:textColor];
}

// Set the background color.
- (void)setBackgroundColor:(UIColor*)backgroundColor{
    [super setBackgroundColor:backgroundColor];
    [label_ setBackgroundColor:backgroundColor];
}

// Set the label font.
- (void)setFont:(UIFont*)font{
    [label_ setFont:font];
}

@end
