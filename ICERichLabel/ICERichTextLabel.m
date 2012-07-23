//
//  ICERichTextLabel.m
//  ICEDK
//
//  Created by Icepat on 27/04/12.
//  Copyright (c) 2012 Icepat. All rights reserved.
//

#import "ICERichTextLabel.h"
#import "ICEView+Utilities.h"
#import "ICEConstants.h"

@interface ICERichTextLabel()
// Configure the basic datas.
- (void)preConfiguration;
// Draw the rich label.
- (void)draw;
// Add a default label.
- (void)addDefaultLabelWith:(NSString*)screenText
                      style:(ICERichTextStyle*)style
                   andFrame:(CGRect)frame;
// Add a rich label.
- (void)addClickableLabelWith:(NSString*)screenText
                     hashText:(NSString*)hashText
                        style:(ICERichTextStyle*)style
                     andFrame:(CGRect)frame;
// Get the current label frame.
- (CGRect)getRectForLabelWithText:(NSString*)text
                            style:(ICERichTextStyle*)textStyle;
// Get the string in hash.
- (NSString*)getValueInHashString:(NSString*)string withPrefix:(NSString*)prefix;
// Get the text without the key.
- (NSString*)getTextCleaned:(NSString*)string;
// Get the key in hash.
- (NSString*)getKeyInHashString:(NSString*)string;
// Slice text in parts based on separator and prefixed strings.
- (void)sliceTextInParts:(NSString*)text;
// Get the next separator/prefix position.
- (NSRange)rangeOfNextSeparatorInText:(NSString*)text;
@end

@implementation ICERichTextLabel
@synthesize linkedObjects = linkedObjects_;

// Init.
- (id)initWithWidth:(CGFloat)width {
	self = [super initWithFrame:CGRectMake(0.0, 0.0, width, 0.0)];
	if(self != nil) {
        [self preConfiguration];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame{
    if ((self = [super initWithFrame:frame])) {
        [self preConfiguration];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)coder{
    if ((self = [super initWithCoder:coder])) {
        [self preConfiguration];
	}
	return self;
}

// Configure the basic datas.
- (void)preConfiguration{
    prefixTextStyles_ = [[NSMutableDictionary alloc] init];
    textParts_ = [[NSMutableArray alloc] init];		
    
    textStyle_ = [[ICERichTextStyle styleWithFont:[UIFont fontWithName:@"Helvetica" size:14]
                                            color:[UIColor blackColor]
                                        backColor:[UIColor clearColor]
                                           prefix:nil
                                       hidePrefix:NO] retain];        
}

- (void)dealloc {
	[prefixTextStyles_ release];
	[textParts_ release];
	[textStyle_ release];
    [linkedObjects_ release];
	[super dealloc];
}

// Set the text.
- (void)setText:(NSString*)text{
    [textParts_ release];
    textParts_ = nil;
    
    textParts_ = [[NSMutableArray alloc] init];	
    
    // Slice the text in parts.
    [self sliceTextInParts:text];
    
    // Draw the rich label.
    [self draw];
}

// Set the main style.
- (void)setStyle:(ICERichTextStyle*)style{
    [textStyle_ release];
    textStyle_ = nil;
    
    textStyle_ = [style retain];	
    
    // Draw the rich label.
    [self draw];
}

// Add a rich style.
- (void)addRichStyle:(ICERichTextStyle*)style{	
    // If the style have no prefix.
	if((style.prefix == nil) || (style.prefix == 0)) {
		[NSException raise:NSInternalInconsistencyException 
                    format:@"Prefix must be specified in %@", NSStringFromSelector(_cmd)];
	}
	
	[prefixTextStyles_ setObject:style forKey:style.prefix];
}

#pragma mark - Drawing management
// Draw the rich label.
- (void)draw{
    // No text.
    if (![textParts_ count])
        return;
    
    // Clean.
    [self removeSubviews];
    
    // Datas.
    maxHeight_ = 999999;
    currentPosition_ = CGPointZero;
	measureSize_ = CGSizeMake(self.size.width, maxHeight_);
    
    for (NSString *text in textParts_){
        // Set the current text style.
        ICERichTextStyle *textStyle = [self getTextStyle:text];

        // Get the "space" size of the style.
        returnSize_ = [@" " sizeWithFont:textStyle.font];

        // If there is text.
        if (![text isEqualToString:@"\n"]){
            
            NSString *textOnLabel = @"";
            
            // Real string with escaped HASH.
            if ([textStyle prefixIsHidden]){
                textOnLabel = [self getValueInHashString:text withPrefix:textStyle.prefix];    
            } else {
                textOnLabel = [self getTextCleaned:text];    
            }
     
            // Get the label frame & size.
            CGRect labelFrame = [self getRectForLabelWithText:textOnLabel style:textStyle];
            
            // Add label on screen with style.
            if (textStyle.target)
                [self addClickableLabelWith:textOnLabel
                                   hashText:text
                                      style:textStyle
                                   andFrame:labelFrame];
            else
                [self addDefaultLabelWith:textOnLabel
                                    style:textStyle
                                 andFrame:labelFrame];
        
            // Add a space after the text.
            currentPosition_.x += labelFrame.size.width + returnSize_.width;
            
            // Last object.
            if([text isEqual:[textParts_ lastObject]]) {
                currentPosition_.y += returnSize_.height;	
            }
        } else {
            // \n make a line break.
            currentPosition_.y += returnSize_.height;
            currentPosition_.x = 0.0;
        }
	}
    
    // Update the view's size.
  	[self setSize:CGSizeMake(self.size.width, currentPosition_.y)];
}

#pragma mark - Label management
// Add a default label.
- (void)addDefaultLabelWith:(NSString*)screenText
                      style:(ICERichTextStyle*)style
                   andFrame:(CGRect)frame{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    [label setBackgroundColor:style.backgroundColor];
    [label setNumberOfLines:maxHeight_];
    [label setFont:style.font];
    [label setTextColor:style.color];
    [label setText:screenText];
    [self addSubview:label];
    [label release];
}

// Add a rich label.
- (void)addClickableLabelWith:(NSString*)screenText
                     hashText:(NSString*)hashText
                        style:(ICERichTextStyle*)style
                     andFrame:(CGRect)frame{
    ICETapLabel *labelClick = [[ICETapLabel alloc] initWithRect:frame];
    [labelClick addTarget:style.target action:style.action];
    [labelClick setBackgroundColor:style.backgroundColor];
    [labelClick setFont:style.font];
    [labelClick setTextColor:style.color];   
    [labelClick setLinkedObject:[linkedObjects_ objectForKey:[self getKeyInHashString:hashText]]];
    [labelClick setText:screenText];
    [self addSubview:labelClick];	
    [labelClick release];
}

// Get the current label frame.
- (CGRect)getRectForLabelWithText:(NSString*)text style:(ICERichTextStyle*)textStyle{   
    // Get size of content (check current line before starting new one)    
    CGSize globalSize = CGSizeMake(measureSize_.width - currentPosition_.x, maxHeight_);
    CGSize lineSize = CGSizeMake(globalSize.width, returnSize_.height);
    
    CGSize textSize = [text sizeWithFont:textStyle.font constrainedToSize:lineSize];
    CGSize controlSize = [text sizeWithFont:textStyle.font constrainedToSize:globalSize];    
    
    // Add a line break if needed.
    if((textSize.width != controlSize.width) || (!textSize.width && !controlSize.width)){
        // Line breaks.
        currentPosition_.y += returnSize_.height;
        currentPosition_.x = 0.0;
        
        // Update the content size with new positions.
        globalSize = CGSizeMake(measureSize_.width - currentPosition_.x, maxHeight_);
        lineSize = CGSizeMake(globalSize.width, 0.0);
        
        textSize = [text sizeWithFont:textStyle.font constrainedToSize:lineSize lineBreakMode:UILineBreakModeTailTruncation];
        controlSize = [text sizeWithFont:textStyle.font constrainedToSize:globalSize];
    }   
    
    // Return the Label frame.
    return CGRectMake(currentPosition_.x, currentPosition_.y, controlSize.width, textSize.height);
}

#pragma mark - String management
// Get the string in hash.
- (NSString*)getValueInHashString:(NSString*)string withPrefix:(NSString*)prefix{
    if (!prefix)
        return string;
    
    // Get range position of the hash string.
    NSRange rangeHash = [string rangeOfString:prefix];
    
    // Existing.
    if (rangeHash.length){
        // Get range position of the EOF string.
        NSRange rangeEOF = [string rangeOfString:hashKey];
        
        NSString *stringValue;
        // Crop to the ending hash.
        if (rangeEOF.length)
            stringValue = [string substringWithRange:NSMakeRange((rangeHash.location + rangeHash.length),
                                                                 (rangeEOF.location - (rangeHash.location + rangeHash.length)))];
        else
            stringValue = [string substringWithRange:NSMakeRange((rangeHash.location + rangeHash.length),
                                                                 (string.length - (rangeHash.location + rangeHash.length)))];
        return stringValue;
    }
    
    return string;
}

// Get the text without the key.
- (NSString*)getTextCleaned:(NSString*)string{
    // Get range position of the hash string.
    NSRange rangeKey = [string rangeOfString:hashKey];
    
    // Existing.
    if (rangeKey.length){
        // Get the string.
        NSString *keyValue = [string substringToIndex:rangeKey.location];
        
        return keyValue;
    }
    
    return string;
}

// Get the key in hash.
- (NSString*)getKeyInHashString:(NSString*)string{
    // Get range position of the hash string.
    NSRange rangeKey = [string rangeOfString:hashKey];
    
    // Existing.
    if (rangeKey.length){
        // Get the string.
        NSString *keyValue = [string substringFromIndex:rangeKey.location + rangeKey.length];
        
        return keyValue;
    }
    
    return string;
}

#pragma mark - Text management
// Get the text style.
- (ICERichTextStyle*)getTextStyle:(NSString*)text{
    for(NSString *prefix in [prefixTextStyles_ allKeys]) {
        if([text hasPrefix:prefix])
            return [prefixTextStyles_ objectForKey:prefix];
    }
    
    return textStyle_;
}

// Slice text in parts based on separator and prefixed strings.
- (void)sliceTextInParts:(NSString*)text{  
    NSString *workingString = text;
    
    NSRange currentPositionInText = NSMakeRange(0, 0);
    NSRange nextSeparatorPosition = [self rangeOfNextSeparatorInText:workingString];
    
    // Slice all the text based on separator.
    while (nextSeparatorPosition.length) {
        NSString *currentParsingValue = [workingString substringWithRange:NSMakeRange(currentPositionInText.location, nextSeparatorPosition.location)];
        
        [textParts_ addObject:currentParsingValue];
        
        workingString = [workingString substringWithRange:NSMakeRange((nextSeparatorPosition.location + nextSeparatorPosition.length),
                                                                      (workingString.length - (nextSeparatorPosition.location + nextSeparatorPosition.length)))];
        
        nextSeparatorPosition = [self rangeOfNextSeparatorInText:workingString];
    }
    
    // Add the last part.
    [textParts_ addObject:workingString];
}

// Get the next separator/prefix position.
- (NSRange)rangeOfNextSeparatorInText:(NSString*)text{
    NSRange nextSeparatorPosition = [text rangeOfString:kTextSlicedSeparator];
    NSRange nextHashPosition = [text rangeOfString:hash];    
    
    if (!nextSeparatorPosition.length && !nextHashPosition.length)
        return NSMakeRange(0, 0);
    
    // Next slice is based on a separator.
    if (nextHashPosition.location > nextSeparatorPosition.location)
        return nextSeparatorPosition;

    // Next slice is based on a hash.
    NSRange endingHashPostion = [text rangeOfString:hashKey];
    NSString *endingString = [text substringWithRange:NSMakeRange(endingHashPostion.location, text.length - endingHashPostion.location)];
    NSRange endingSeparatorPosition = [endingString rangeOfString:kTextSlicedSeparator];
    
    NSRange finalRange = NSMakeRange(endingSeparatorPosition.location + endingHashPostion.location, 1);
    
    return finalRange;     
}

@end
