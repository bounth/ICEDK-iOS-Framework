//
//  ICEAnimation.m
//  ICEDK
//
//  Created by Icepat on 21/05/12.
//  Copyright (c) 2012 Icepat. All rights reserved.
//

#import "ICEAnimation.h"

@implementation ICEAnimation
    
#pragma mark - Transparency Animation
// Transparency automatic.
+ (CABasicAnimation*)transparencyAnimation{
    return [self transparencyAnimationFromValue:1.0f toValue:0.2f];
}

// Transparency manual.
+ (CABasicAnimation*)transparencyAnimationFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	[animation setFillMode:kCAFillModeForwards];
	[animation setRemovedOnCompletion:NO];    
    [animation setFromValue:[NSNumber numberWithFloat:fromValue]];
    [animation setToValue:[NSNumber numberWithFloat:toValue]];
    return animation;
}

#pragma mark - Translate Animation
// Translate manual.
+ (CABasicAnimation*)translateAnimationFrom:(CGPoint)fromValue to:(CGPoint)toValue{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
	[animation setFillMode:kCAFillModeForwards];
	[animation setRemovedOnCompletion:NO];
    [animation setFromValue:[NSValue valueWithCGPoint:fromValue]];
    [animation setToValue:[NSValue valueWithCGPoint:toValue]];
    return animation;
}

#pragma mark - Rotation Animation
// Rotation on X from 0 to ANGLE.
+ (CABasicAnimation*)rotateAnimationOnXToAngle:(double)angle{
    return [self rotateAnimationOnXFromAngle:0 toAngle:angle];
}

// Rotation on X from ANGLE to ANGLE.
+ (CABasicAnimation*)rotateAnimationOnXFromAngle:(double)fromAngle toAngle:(double)toAngle{
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
	[animation setFillMode:kCAFillModeForwards];
	[animation setRemovedOnCompletion:NO];    
    [animation setFromValue:[NSNumber numberWithDouble:fromAngle*M_PI/180]];
    [animation setToValue:[NSNumber numberWithDouble:toAngle*M_PI/180]];
    return animation;
}

// Rotation on Y from 0 to ANGLE.
+ (CABasicAnimation*)rotateAnimationOnYToAngle:(double)angle{
    return [self rotateAnimationOnYFromAngle:0 toAngle:angle];
}

// Rotation on Y from ANGLE to ANGLE.
+ (CABasicAnimation*)rotateAnimationOnYFromAngle:(double)fromAngle toAngle:(double)toAngle{
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
	[animation setFillMode:kCAFillModeForwards];
	[animation setRemovedOnCompletion:NO];    
    [animation setFromValue:[NSNumber numberWithDouble:fromAngle*M_PI/180]];
    [animation setToValue:[NSNumber numberWithDouble:toAngle*M_PI/180]];
    return animation;
}

// Rotation on Z from 0 to ANGLE.
+ (CABasicAnimation*)rotateAnimationOnZToAngle:(double)angle{
    return [self rotateAnimationOnZFromAngle:0 toAngle:angle];
}

// Rotation on Z from ANGLE to ANGLE.
+ (CABasicAnimation*)rotateAnimationOnZFromAngle:(double)fromAngle toAngle:(double)toAngle{
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	[animation setFillMode:kCAFillModeForwards];
	[animation setRemovedOnCompletion:NO];    
    [animation setFromValue:[NSNumber numberWithDouble:fromAngle*M_PI/180]];
    [animation setToValue:[NSNumber numberWithDouble:toAngle*M_PI/180]];
    return animation;
}
    
@end
