//
//  ICEMutableSliderEngine.h
//  ICEDK
//
//  Created by Icepat on 26/03/12.
//  Copyright (c) 2012 Icepat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICEMutableSliderEvent.h"
#import "ICEConstants.h"

// Define the type of the used SLIDER engine.
typedef enum {
    // Work in progress for automatic scroll based on type.
    MSEngineTypeLeft,                              // Add a slider on left.
    MSEngineTypeRight,                             // Add a slider on right.
    MSEngineTypeLeftAndRight,                      // Add a slider on left and right.
} MSEngineType;
// Define the status of the current SLIDER engine state machine.
typedef enum {
    MSEngineStateSlideNone,                        // State engine : NONE, used after init, or after an animation.
    MSEngineStateSlideLeft,                        // State engine : LEFT, sliding up.  
    MSEngineStateSlideRight,                       // State engine : RIGHT, sliding up.    
    MSEngineStateSlideEnded,                       // State engine : ENDED, sliding ended.   
} MSEngineState;
// Define the current position of the root controller.
typedef enum {
    MSEngineCurrentPositionOrigin,
    MSEngineCurrentPositionLeft,
    MSEngineCurrentPositionRight,
    MSEngineCurrentPositionUndefined,  
} MSEngineCurrentPosition;
// Define the available events.
// Add new events here !!
typedef enum {
    MSEngineRemoteEventWelcomeController,
    MSEngineRemoteEventRichLabelController,         
} MSEngineRemoteEvent;

@protocol ICEMutableSliderEngineDelegate;

@interface ICEMutableSliderEngine : UIViewController {
    // View controllers.
    UIViewController *leftController_;
    UIViewController *rightController_;
    
    // Master navigation controller.
    NSArray *rootControllers_;
    UINavigationController *masterControllerNav_;
    
    // Hidden view.
    UIView *backgroundView_;
    UIView *frontView_;    
    
    // Positions.
    CGPoint firstPanPosition_;
    CGPoint rootOriginPosition_;    
    CGPoint rootOriginPanPosition_;
    
    // Point position.
    CGFloat slidePositionLeft_;
    CGFloat slidePositionRight_;  
    
    // Buttons.
    BOOL enableLeftButton_;
    BOOL enableRightButton_;    
    
    // Touch recognizer.
    UIPanGestureRecognizer *panGesture_;
    
    // Slide engine datas, states and events.
    MSEngineType currentMSEngineType_;
    MSEngineState currentMSEngineState_;
    MSEngineCurrentPosition currentMSEnginePosition_;
    MSEngineRemoteEvent lastReceivedEvents_;
    
    // Delegate.
    id<ICEMutableSliderEngineDelegate> delegate_;   
}

@property (nonatomic, assign) id<ICEMutableSliderEngineDelegate> delegate_;

// Init with controllers.
- (id)initWithRootControllers:(NSArray*)rootControllers
               leftController:(UIViewController*)leftController
              rightController:(UIViewController*)rightController
                  andDelegate:(id<ICEMutableSliderEngineDelegate>)delegate;

// Init the MS Engine with all the settings.
- (void)initMSEngineWithType:(MSEngineType)engineType
        slideMaxPositionLeft:(CGFloat)positionLeft
       slideMaxPositionRight:(CGFloat)positionRight
         enablePanRecognizer:(bool)enablePanRecognizer
                  leftButton:(bool)enableLeftButton
                 rightButton:(bool)enableRightButton;

@end

// Delegate methodes.
@protocol ICEMutableSliderEngineDelegate

@optional
// Called when the MS engine recognize the first PAN event.
- (void)MSEngineWillBegin:(ICEMutableSliderEngine*)engine;
// Called when the MS engine recognize the PAN event.
- (void)MSEngineDidBegin:(ICEMutableSliderEngine*)engine;
// Called when the MS engine recognize the first moving event.
- (void)MSEngineWillMove:(ICEMutableSliderEngine*)engine andState:(MSEngineState)state;
// Called when the MS engine recognize the moving event.
- (void)MSEngineDidMove:(ICEMutableSliderEngine*)engine andState:(MSEngineState)state;
// Called when the MS engine recognize the first ending event.
- (void)MSEngineWillEnd:(ICEMutableSliderEngine*)engine;
// Called when the MS engine recognize the ending event.
- (void)MSEngineDidEnd:(ICEMutableSliderEngine*)engine;
@end


