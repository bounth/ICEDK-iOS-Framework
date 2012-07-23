//
//  ICERichTextStyle.m
//  ICEDK
//
//  Created by Icepat on 27/04/12.
//  Copyright (c) 2012 Icepat. All rights reserved.
//

#import "ICERichTextStyle.h"

@implementation ICERichTextStyle
@synthesize font = font_;
@synthesize color = color_;
@synthesize backgroundColor = backgroundColor_;
@synthesize prefix = prefix_;
@synthesize prefixIsHidden = prefixIsHidden_;
@synthesize target = target_;
@synthesize action = action_;

// Define the style.
+ (ICERichTextStyle*)styleWithFont:(UIFont*)font
                             color:(UIColor*)color
                         backColor:(UIColor*)backgroundColor
                            prefix:(NSString*)prefix
                        hidePrefix:(BOOL)enabled{
	ICERichTextStyle *style = [[ICERichTextStyle alloc] init];
	[style setFont:font];
	[style setColor:color];
    [style setBackgroundColor:backgroundColor];
    [style setPrefix:prefix];
    [style setPrefixIsHidden:enabled];
	return [style autorelease];
}

// Define the style with the target and action.
+ (ICERichTextStyle*)styleWithFont:(UIFont*)font
                             color:(UIColor*)color
                         backColor:(UIColor*)backgroundColor
                            prefix:(NSString*)prefix
                        hidePrefix:(BOOL)enabled
                            target:(id)target
                         andAction:(SEL)action{
    ICERichTextStyle *style = [self styleWithFont:font
                                            color:color
                                        backColor:backgroundColor
                                           prefix:prefix
                                       hidePrefix:enabled];
    [style addTarget:target action:action];
	return style;
}

// Set or change the target and action.
- (void)addTarget:(id)target action:(SEL)action {
	target_ = target;
	action_ = action;
}

- (void)dealloc {
	[font_ release];
	[color_ release];
    [backgroundColor_ release];
    [prefix_ release];
	[super dealloc];
}

@end
