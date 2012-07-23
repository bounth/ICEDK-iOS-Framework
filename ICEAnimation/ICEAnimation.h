//
//  ICEAnimation.h
//  ICEDK
//
//  Created by Icepat on 21/05/12.
//  Copyright (c) Icepat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface ICEAnimation : NSObject {
    
}

// Transparency automatic.
+ (CABasicAnimation*)transparencyAnimation;
// Transparency manual.
+ (CABasicAnimation*)transparencyAnimationFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue;
// Translate manual.
+ (CABasicAnimation*)translateAnimationFrom:(CGPoint)fromValue to:(CGPoint)toValue;
// Rotation on X from 0 to ANGLE.
+ (CABasicAnimation*)rotateAnimationOnXToAngle:(double)angle;
// Rotation on X from ANGLE to ANGLE.
+ (CABasicAnimation*)rotateAnimationOnXFromAngle:(double)fromAngle toAngle:(double)toAngle;
// Rotation on Y from 0 to ANGLE.
+ (CABasicAnimation*)rotateAnimationOnYToAngle:(double)angle;
// Rotation on T from ANGLE to ANGLE.
+ (CABasicAnimation*)rotateAnimationOnYFromAngle:(double)fromAngle toAngle:(double)toAngle;
// Rotation on Z from 0 to ANGLE.
+ (CABasicAnimation*)rotateAnimationOnZToAngle:(double)angle;
// Rotation on Z from ANGLE to ANGLE.
+ (CABasicAnimation*)rotateAnimationOnZFromAngle:(double)fromAngle toAngle:(double)toAngle;
@end
