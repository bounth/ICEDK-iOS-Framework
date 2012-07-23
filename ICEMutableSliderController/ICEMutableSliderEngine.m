//
//  ICEMutableSliderEngine.m
//  ICEDK
//
//  Created by Icepat on 26/03/12.
//  Copyright (c) 2012 Icepat. All rights reserved.
//

#import "ICEMutableSliderEngine.h"
#import "ICEView+Utilities.h"

@interface ICEMutableSliderEngine()
// **************************************
// **          MS ENGINE INIT          **
// **************************************
// Init the MS Engine with type
- (void)initMSEngineWithType:(MSEngineType)engineType;
// Load the MS max positions for the slider.
- (void)loadMSEngineMaxPositions;
// **************************************
// **       ADD BUTTON MANAGEMENT      **
// **************************************
// Add a left button for the slider.
- (void)addLeftButton;
// Add a right button for the slider.
- (void)addRightButton;
// Did click on the left navigationbar's button.
- (void)didClickOnLeftButton;
// Did click on the right navigationbar's button.
- (void)didClickOnRightButton;
// **************************************
// **         EVENTS MANAGEMENT        **
// **************************************
// Handle the received events.
- (void)handleReceivedEvents:(NSNotification*)notification;
// **************************************
// **  PAN GESTURES HANDLING METHODES  **
// **************************************
// Add the PAN gesture recognizer.
- (void)addPanGestureRecognizer;
// Handle the PAN gestures events.
- (void)handlePanGesture:(UIPanGestureRecognizer*)sender;
// Handle PAN gesture BEGAN STATE.
- (void)panGestureBegan:(UIPanGestureRecognizer*)sender;
// Handle PAN gesture CHANGED STATE.
- (void)panGestureChanged:(UIPanGestureRecognizer*)sender;
// Handle PAN gesture ENDED STATE.
- (void)panGestureEnded:(UIPanGestureRecognizer*)sender;
// **************************************
// **   MS ENGINE SCROLLING MANAGER   **
// **************************************
// Scrolling manager.
- (void)MSEngineScrollingManager:(MSEngineState)state;
// Smooth scrolling manager.
- (void)MSEngineScrollingSmoothManager:(MSEngineState)state;
// Authorize or not the move.
- (BOOL)MSEngineAutorizeMoving:(MSEngineState)state;
// Authorize or not the move if the engine is correctly set up.
- (BOOL)MSEngineAutorizeMovingByType:(MSEngineState)state;
// Authorize or not the move if the position is corresponding.
- (BOOL)MSEngineAutorizeMovingByPosition:(MSEngineState)state;
// Manage the manual move of the view.
- (void)MSEngineManualMove:(CGPoint)currentTouchPosition withEngineState:(MSEngineState)engineState;
// Manage the automatic move of the view.
- (void)MSEngineAutomaticMove:(CGPoint)position withAlpha:(CGFloat)alpha andState:(MSEngineState)state;
// Manage the automatic smooth move of the view.
- (void)MSEngineAutomaticSmoothMove:(CGPoint)midlePosition final:(CGPoint)finalPosition withAlpha:(CGFloat)alpha andState:(MSEngineState)state;
// **************************************
// **  MS ENGINE FRONT VIEWS MANAGER  **
// **************************************
// Change the master navigation controller to an other controller by event.
- (void)switchFrontControllerWithEvent:(MSEngineRemoteEvent)event;
// Change the master navigation controller to an other controller by index.
- (void)switchFrontControllerWithIndex:(NSUInteger)index;
// **************************************
// **  MS ENGINE BACK VIEWS MANAGER   **
// **************************************
// Set the desired view as background, on engine states.
- (void)setSelectedViewWithState:(MSEngineState)state;
// Set the view position in background.
- (void)setPositionOfBackgroundView:(UIViewController*)controller andState:(MSEngineState)state;
// Apply effects on controllers when moving.
- (void)MSEngineApplyEffectOnViewWithState:(MSEngineState)state;
// Apply alpha on controllers when moving.
- (void)MSEngineApplyAlphaOnViewWithState:(MSEngineState)state;
// **************************************
// **    MS ENGINE DELEGATE MANAGER   **
// **************************************
// MS Engine status will BEGIN.
- (void)MSEngineWillBegin;
// MS Engine status did BEGIN.
- (void)MSEngineDidBegin;
// MS Engine status will MOVE.
- (void)MSEngineWillMove;
// MS Engine status did MOVE.
- (void)MSEngineDidMove;
// MS Engine status will END.
- (void)MSEngineWillEnd;
// MS Engine status did END.
- (void)MSEngineDidEnd;
@end

@implementation ICEMutableSliderEngine
@synthesize delegate_;

// Init with controllers.
- (id)initWithRootControllers:(NSArray*)rootControllers
               leftController:(UIViewController*)leftController
              rightController:(UIViewController*)rightController
                  andDelegate:(id<ICEMutableSliderEngineDelegate>)delegate{
    self = [super init];
    if (self) {
        // Init with controllers.
        rootControllers_ = [rootControllers retain]; 
        masterControllerNav_ = [[[UINavigationController alloc] initWithRootViewController:[rootControllers objectAtIndex:0]] retain];
        [[masterControllerNav_ navigationBar] setTintColor:kMSEngineNavigationBarTintColor];
        leftController_ = [leftController retain];
        rightController_ = [rightController retain]; 
        delegate_ = delegate;
        
        // Add notifications handler.
        [[NSNotificationCenter defaultCenter] addObserver:self  
                                                 selector:@selector(handleReceivedEvents:) 
                                                     name:MS_ENGINE_EVENT 
                                                   object:nil];
    }
    return self;
}

- (void)dealloc{
    // Remove notifications.
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:MS_ENGINE_EVENT
                                                  object:nil];
    [panGesture_ release];
    [leftController_ release];
    [rightController_ release];
    [rootControllers_ release];
    [masterControllerNav_ release];
    [backgroundView_ release];
    [frontView_ release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Call the delegate.
    [self MSEngineWillBegin];
    
    // Init the engine.
    [self initMSEngineWithType:MSEngineTypeLeftAndRight];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - MS Engine init & load
// Init the MS Engine with type and load the defined settings in header.
- (void)initMSEngineWithType:(MSEngineType)engineType{
    // Configure with default.
    [self initMSEngineWithType:engineType
          slideMaxPositionLeft:kMSEngineMaxSlidePositionEndLeft
         slideMaxPositionRight:kMSEngineMaxSlidePositionEndRight
           enablePanRecognizer:kMSEngineFingerStartTheSlider
                    leftButton:kMSEngineAddLeftButton
                   rightButton:kMSEngineAddRightButton];
   
    // Load positions.
    [self loadMSEngineMaxPositions];
}

// Init the MS Engine with all the settings.
- (void)initMSEngineWithType:(MSEngineType)engineType
        slideMaxPositionLeft:(CGFloat)positionLeft
       slideMaxPositionRight:(CGFloat)positionRight
         enablePanRecognizer:(bool)enablePanRecognizer
                  leftButton:(bool)enableLeftButton
                 rightButton:(bool)enableRightButton{
    // Set the view frame.
    [[self view] setFrame:[self.view bounds]];
    
    // Init the views.
    backgroundView_ = [[UIView alloc] init];
    [backgroundView_ setFrame:[self.view bounds]];  
    
    frontView_ = [[UIView alloc] init];
    [frontView_ setFrame:[self.view bounds]];  
    
    // Add the background view.
    [self.view addSubview:backgroundView_];
    [self.view addSubview:frontView_];
    
    // Master view with navigation controller.
    [masterControllerNav_.view setFrame:[self.view bounds]];  
    [frontView_ addSubview:masterControllerNav_.view];
    
    // Init the engine.
    // Set the starting status.
    currentMSEngineState_ = MSEngineStateSlideNone;
    currentMSEngineType_ = engineType;
    currentMSEnginePosition_ = MSEngineCurrentPositionOrigin;
    
    // Load positions.
    slidePositionLeft_ = positionLeft;
    slidePositionRight_ = positionRight;
    rootOriginPosition_ = frontView_.frame.origin; 
    
    // Add the PAN gesture recognizer.
    if (enablePanRecognizer)
        [self addPanGestureRecognizer];   
    
    // Add buttons.
    enableLeftButton_ = enableLeftButton;
    enableRightButton_ = enableRightButton;    
    [self addLeftButton];
    [self addRightButton];
    
    // Call the delegate.
    [self MSEngineDidBegin];
}

// Load the MS max positions for the slider.
- (void)loadMSEngineMaxPositions{
    // Set the min & max position for dragging.
    if (kMSEngineMaxSlidePositionEndLeft != kMSEngineMaxSlidePositionBackgroundController)
        slidePositionLeft_ = kMSEngineMaxSlidePositionEndLeft;
    else 
        slidePositionLeft_ = leftController_.view.frame.size.width;
    
    if (kMSEngineMaxSlidePositionEndRight != kMSEngineMaxSlidePositionBackgroundController)
        slidePositionRight_ = kMSEngineMaxSlidePositionEndRight;
    else 
        slidePositionRight_ = rightController_.view.frame.size.width;    
}

#pragma mark - MS Engine Left & Right buttons
// Add a left button for the slider.
- (void)addLeftButton{
    if(!enableLeftButton_)
        return;
    
    // Add buttons if needed.
    UIBarButtonItem *leftButton = [[[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(didClickOnLeftButton)] autorelease];
    [[[masterControllerNav_.viewControllers  objectAtIndex:0] navigationItem] setLeftBarButtonItem:leftButton];
}

// Add a right button for the slider.
- (void)addRightButton{
    if(!enableRightButton_)
        return;
    
    // Add buttons if needed.
    UIBarButtonItem *rightButton = [[[UIBarButtonItem alloc] initWithTitle:@"About"
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(didClickOnRightButton)] autorelease];
    [[[masterControllerNav_.viewControllers  objectAtIndex:0] navigationItem] setRightBarButtonItem:rightButton];
}

#pragma mark - MS Engine buttons actions
// Did click on the left navigationbar's button.
- (void)didClickOnLeftButton{  
    [self MSEngineScrollingManager:MSEngineStateSlideRight];
}

// Did click on the right navigationbar's button.
- (void)didClickOnRightButton{
    [self MSEngineScrollingManager:MSEngineStateSlideLeft];
}

#pragma mark - MS Engine events handler
// Handle the received events.
- (void)handleReceivedEvents:(NSNotification*)notification{  
    // Get the event.
    lastReceivedEvents_ = [[notification object] intValue];
    
    switch (lastReceivedEvents_) {
        // Events sent by the right panel (calling a left scrolling.
        //case MSEngineRemoteEvent_YOUR_EVENT_NAME:            
        //    [self MSEngineScrollingSmoothManager:MSEngineStateSlideRight];
        //    break;            
            
        // Events sent by the left panel (calling a right scrolling.
        case MSEngineRemoteEventWelcomeController:     
        case MSEngineRemoteEventRichLabelController:            
            [self MSEngineScrollingSmoothManager:MSEngineStateSlideRight];
            break;
    }
}

#pragma mark - MS Engine Gestures recognizer & management
// Add the PAN gesture recognizer.
- (void)addPanGestureRecognizer{
    // Cleanup.
    if (panGesture_){
        [panGesture_ release];
        panGesture_ = nil;
    }
    
    // Init dragging gesture.
    panGesture_ = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)] retain];
    
    // On the master navigation controller's navigation bar.
    [masterControllerNav_.navigationBar addGestureRecognizer:panGesture_];
}

// Handle the PAN gestures events.
- (void)handlePanGesture:(UIPanGestureRecognizer*)sender{ 
    // Pan Gesture state machine.
    if([sender state] == UIGestureRecognizerStateBegan){
        // Pan BEGAN.
        [self panGestureBegan:sender];
    } else if ([sender state] == UIGestureRecognizerStateChanged){
        // Pan MOVED.
        [self panGestureChanged:sender];
    } else if ([sender state] == UIGestureRecognizerStateEnded){
        // Pan ENDED.
        [self panGestureEnded:sender];
    }
}

// Handle PAN gesture BEGAN STATE.
- (void)panGestureBegan:(UIPanGestureRecognizer*)sender{   
    // Save the master controller current position.
    rootOriginPanPosition_ = frontView_.frame.origin; 
}

// Handle PAN gesture CHANGED STATE.
- (void)panGestureChanged:(UIPanGestureRecognizer*)sender{
    // Get the translation position.
    CGPoint translatedPoint = [sender translationInView:self.view];
    
    // When we come from init status, or ended status.
    if (currentMSEngineState_ == MSEngineStateSlideNone ||
        currentMSEngineState_ == MSEngineStateSlideEnded){
        if ((translatedPoint.x > kMSEngineFingerMinimumMoveBeforeSliding)){
            currentMSEngineState_ = MSEngineStateSlideRight;
        } else if ((translatedPoint.x < -kMSEngineFingerMinimumMoveBeforeSliding)){
            currentMSEngineState_ = MSEngineStateSlideLeft;      
        }
        
        // Set the desired background controller.
        [self setSelectedViewWithState:currentMSEngineState_];
    } else if (currentMSEngineState_ == MSEngineStateSlideLeft &&
               currentMSEngineState_ == MSEngineStateSlideRight){
        // When we are in the moving status.
        if ((firstPanPosition_.x - translatedPoint.x) > 0){
            currentMSEngineState_ = MSEngineStateSlideLeft;  
        } else {
            currentMSEngineState_ = MSEngineStateSlideRight; 
        }
    }
    
    // Save the first PAN position.
    firstPanPosition_ = translatedPoint;  
    
    // Move the navigation controller.
    if (kMSEngineFingerIsAnchorWhenMoving){
        
        // Get positions.
        translatedPoint = CGPointMake(translatedPoint.x, translatedPoint.y);

        // Manual move !
        [self MSEngineManualMove:translatedPoint
                 withEngineState:currentMSEngineState_];  
    }
}

// Handle PAN gesture ENDED STATE.
- (void)panGestureEnded:(UIPanGestureRecognizer*)sender{ 
    // Automatic move.
    [self MSEngineScrollingManager:currentMSEngineState_];
}

#pragma mark - MS Engine Scrolling & animations managements
// Scrolling manager.
- (void)MSEngineScrollingManager:(MSEngineState)state{  
    if (![self MSEngineAutorizeMoving:state])
        return;
    
    // Call the delegate.
    [self MSEngineWillBegin];
    
    // Call the delegate.
    [self MSEngineDidBegin];  
    
    // State machine.  
    switch (state) {
        case MSEngineStateSlideNone:
            break;
 
        // Sliding to the left event (right button touched).
        case MSEngineStateSlideLeft:
            // Slide to the Left, or to the Origin position.            
            if (currentMSEnginePosition_ == MSEngineCurrentPositionOrigin)
                [self MSEngineAutomaticMove:CGPointMake(-slidePositionLeft_, frontView_.frame.origin.y)
                                  withAlpha:0
                                   andState:state];
            else
                [self MSEngineAutomaticMove:rootOriginPosition_ 
                                  withAlpha:0
                                   andState:state];
            break;

        // Sliding to the right event (left button touched).            
        case MSEngineStateSlideRight:
            // Slide to the Right, or to the Origin position.
            if (currentMSEnginePosition_ == MSEngineCurrentPositionOrigin)
                [self MSEngineAutomaticMove:CGPointMake(slidePositionRight_, frontView_.frame.origin.y)
                                  withAlpha:0 
                                   andState:state];
            else
                [self MSEngineAutomaticMove:rootOriginPosition_
                                  withAlpha:0
                                   andState:state];
            break;
            
        // Sliding to the Origin position.            
        case MSEngineStateSlideEnded:
            [self MSEngineAutomaticMove:rootOriginPosition_
                              withAlpha:0
                               andState:state];      
            break;
    }
}

// Smooth scrolling manager.
- (void)MSEngineScrollingSmoothManager:(MSEngineState)state{  
    if (![self MSEngineAutorizeMoving:state])
        return;
    
    // Call the delegate.
    [self MSEngineWillBegin];
    
    // Call the delegate.
    [self MSEngineDidBegin];  
    
    // State machine.  
    switch (state) {
        case MSEngineStateSlideNone:
            break;
           
        case MSEngineStateSlideLeft:
            if (currentMSEnginePosition_ == MSEngineCurrentPositionOrigin)
                [self MSEngineAutomaticMove:CGPointMake(-slidePositionLeft_, 0) withAlpha:0 andState:state];
            else
                [self MSEngineAutomaticSmoothMove:CGPointMake(-350, 0) final:CGPointMake(0, 0) withAlpha:0 andState:state];
            break;
           
        case MSEngineStateSlideRight:
            if (currentMSEnginePosition_ == MSEngineCurrentPositionOrigin)
                [self MSEngineAutomaticMove:CGPointMake(slidePositionRight_, 0) withAlpha:0 andState:state];
            else
                [self MSEngineAutomaticSmoothMove:CGPointMake(350, 0) final:CGPointMake(0, 0) withAlpha:0 andState:state];
            break;
            
        case MSEngineStateSlideEnded:
            [self MSEngineAutomaticMove:CGPointMake(0, 0) withAlpha:0 andState:state];      
            break;
    }
}

// Authorize or not the move.
// Return always YES.
// WORK IN PROGRESS
// Will be improved with automatic engine type detection.
- (BOOL)MSEngineAutorizeMoving:(MSEngineState)state{
    return YES;
    
    if ([self MSEngineAutorizeMovingByType:state] && [self MSEngineAutorizeMovingByPosition:state])
        return YES;
    
    return NO;
}

// Authorize or not the move if the engine is correctly set up.
// Return always YES.
// WORK IN PROGRESS
// Will be improved with automatic engine type detection.
- (BOOL)MSEngineAutorizeMovingByType:(MSEngineState)state{
    // State machine.  
    switch (state) {
        case MSEngineStateSlideNone:
        case MSEngineStateSlideEnded:            
            return YES;
            break;
                       
        case MSEngineStateSlideLeft:
        case MSEngineStateSlideRight:            
            return YES;
            break;
    }

    return NO;
}

// Authorize or not the move if the position is corresponding.
// Return always YES.
// WORK IN PROGRESS
// Will be improved with automatic engine type detection.
- (BOOL)MSEngineAutorizeMovingByPosition:(MSEngineState)state{
    // State machine.  
    switch (state) {
        case MSEngineStateSlideNone:
        case MSEngineStateSlideEnded:            
            return YES;
            break;
            
        case MSEngineStateSlideLeft:
            if (currentMSEnginePosition_ == MSEngineCurrentPositionOrigin ||
                currentMSEnginePosition_ == MSEngineCurrentPositionRight)
                return YES;
            break;
            
        case MSEngineStateSlideRight:            
            if (currentMSEnginePosition_ == MSEngineCurrentPositionOrigin ||
                currentMSEnginePosition_ == MSEngineCurrentPositionLeft)
                return YES;
            break;
    }

    return YES;
}

// Manage the manual move of the view.
- (void)MSEngineManualMove:(CGPoint)currentTouchPosition withEngineState:(MSEngineState)engineState{
    if (currentMSEngineState_ == MSEngineStateSlideLeft ||
        currentMSEngineState_ == MSEngineStateSlideRight){
        // Moving the view with the finger position for anchor point.
        if ((currentTouchPosition.x > kMSEngineFingerMinimumMoveBeforeSliding &&
             ((currentTouchPosition.x + rootOriginPanPosition_.x) <= slidePositionRight_)) ||
            ((currentTouchPosition.x < -kMSEngineFingerMinimumMoveBeforeSliding) &&
             ((currentTouchPosition.x + rootOriginPanPosition_.x) >= (0 - slidePositionLeft_)))){
            // Move the navigation controller.
            [frontView_ setFrame:CGRectMake(rootOriginPanPosition_.x + currentTouchPosition.x,
                                            0,
                                            frontView_.frame.size.width,
                                            frontView_.frame.size.height)];             
        }
    }  
}

// Manage the automatic move of the view.
- (void)MSEngineAutomaticMove:(CGPoint)position withAlpha:(CGFloat)alpha andState:(MSEngineState)state{ 
    // Call the delegate.
    [self MSEngineWillMove];   
    
    // Save the state.
    currentMSEngineState_ = state;

    // Set the desired background controller.
    [self setSelectedViewWithState:currentMSEngineState_];
    
    // Apply effects on controllers when moving.    
    [self MSEngineApplyEffectOnViewWithState:currentMSEngineState_];
    
    // Animating the translation.
    [UIView animateWithDuration:kMSEngineAnimationDuration 
                          delay:kMSEngineAnimationDelay 
                        options:kMSEngineAnimationType 
                     animations:^{
                         // Move the view to the correct position.
                         [frontView_ setFrame:CGRectMake(position.x,
                                                                        position.y,
                                                                        frontView_.frame.size.width,
                                                                        frontView_.frame.size.height)];
                         // Call the delegate.
                         [self MSEngineDidMove]; 
                     }
                     completion:^(BOOL completed){
                         // Animation is now finished.
                         if (completed){
                             // Call the delegate.
                             [self MSEngineWillEnd]; 
                             
                             // Save the position after done animation.
                             if (currentMSEngineState_ == MSEngineStateSlideRight){
                                 if (currentMSEnginePosition_ == MSEngineCurrentPositionOrigin)
                                     currentMSEnginePosition_ = MSEngineCurrentPositionRight;
                                 else if (currentMSEnginePosition_ == MSEngineCurrentPositionLeft)
                                     currentMSEnginePosition_ = MSEngineCurrentPositionOrigin;
                             } else if (currentMSEngineState_ == MSEngineStateSlideLeft){
                                 if (currentMSEnginePosition_ == MSEngineCurrentPositionOrigin)
                                     currentMSEnginePosition_ = MSEngineCurrentPositionLeft;
                                 else if (currentMSEnginePosition_ == MSEngineCurrentPositionRight)
                                     currentMSEnginePosition_ = MSEngineCurrentPositionOrigin; 
                             }
                             
                             // Changing the state to the ended one.
                             currentMSEngineState_ = MSEngineStateSlideEnded; 
                             
                             if (position.x == 0 && position.y == 0)
                                 currentMSEnginePosition_ = MSEngineCurrentPositionOrigin;
                             
                             [self addPanGestureRecognizer];
                             
                             // Call the delegate.
                             [self MSEngineDidEnd]; 
                         }
                     }];
}

// Manage the automatic smooth move of the view.
- (void)MSEngineAutomaticSmoothMove:(CGPoint)midlePosition final:(CGPoint)finalPosition withAlpha:(CGFloat)alpha andState:(MSEngineState)state{ 
    // Call the delegate.
    [self MSEngineWillMove];   
    
    // Fetch the desired state.
    currentMSEngineState_ = state;
    
    // Set the desired controller in background.
    [self setSelectedViewWithState:currentMSEngineState_];
    
    // Animating the translation.
    [UIView animateWithDuration:kMSEngineAnimationDuration 
                          delay:kMSEngineAnimationDelay 
                        options:kMSEngineAnimationType 
                     animations:^{
                         // Move the view to the correct position.
                         [frontView_ setFrame:CGRectMake(midlePosition.x,
                                                         midlePosition.y,
                                                         frontView_.frame.size.width,
                                                         frontView_.frame.size.height)];
                         // Call the delegate.
                         [self MSEngineDidMove]; 
                     }
                     completion:^(BOOL completed){
                         // Animation is now finished.
                         if (completed){
                             [self switchFrontControllerWithEvent:lastReceivedEvents_];

                             // Finish the move.
                             [self MSEngineAutomaticMove:finalPosition withAlpha:alpha andState:state];
                         }
                     }];
}

#pragma mark - MS Engine Front view management
// Change the master navigation controller to an other controller by event.
- (void)switchFrontControllerWithEvent:(MSEngineRemoteEvent)event{
    // Add new events here.
    switch (event) {
        case MSEngineRemoteEventWelcomeController:
            [self switchFrontControllerWithIndex:0];
            break;
            break;
            
        case MSEngineRemoteEventRichLabelController:
            [self switchFrontControllerWithIndex:1];
            break;
    }
}

// Change the master navigation controller to an other controller.
- (void)switchFrontControllerWithIndex:(NSUInteger)index{
    // Handle error.
    if (index > [rootControllers_ count] - 1)
        return;
    
    // Remove the navigation controller and release it.
    [masterControllerNav_.view removeFromSuperview];
    [masterControllerNav_ release];
    masterControllerNav_ = nil;
    
    // Init & load the new one.
    masterControllerNav_ = [[[UINavigationController alloc] initWithRootViewController:[rootControllers_ objectAtIndex:index]] retain];
    [masterControllerNav_.view setFrame:[self.view bounds]];  
    [[masterControllerNav_ navigationBar] setTintColor:kMSEngineNavigationBarTintColor];
    
    // Add buttons.
    [self addLeftButton];
    [self addRightButton];
    
    // Push it on view.
    [frontView_ addSubview:masterControllerNav_.view];
}

#pragma mark - MS Engine Background view management
// Set the desired view as background, on engine states.
- (void)setSelectedViewWithState:(MSEngineState)state{
    // Select the correct with in background of the front sliding view.
    switch (state) {
        case MSEngineStateSlideNone:
        case MSEngineStateSlideEnded:               
            break;
            
        case MSEngineStateSlideLeft:
            if (currentMSEnginePosition_ == MSEngineCurrentPositionOrigin)
                [self setPositionOfBackgroundView:rightController_ andState:MSEngineStateSlideLeft];
            break;
            
        case MSEngineStateSlideRight:
            if (currentMSEnginePosition_ == MSEngineCurrentPositionOrigin)
                [self setPositionOfBackgroundView:leftController_ andState:MSEngineStateSlideRight];
            break;
    }     
}

// Set the view position in background.
- (void)setPositionOfBackgroundView:(UIViewController*)controller andState:(MSEngineState)state{
    // Remove the old one.
    [backgroundView_ removeSubviews];
    
    // Positionning.
    switch (state) {
        case MSEngineStateSlideNone:
        case MSEngineStateSlideEnded:      
        case MSEngineStateSlideRight:    
        case MSEngineStateSlideLeft:
            break;
            
//        case MSEngineStateSlideLeft:
//            [[controller view] setFrame:CGRectMake(controller.view.frame.size.width - slidePositionLeft_,
//                                                   0,
//                                                   controller.view.frame.size.width,
//                                                   controller.view.frame.size.height)];
//            break;
    }     
    
    // On screen.
    [backgroundView_ addSubview:controller.view];
}

// Apply effects on controllers when moving.
- (void)MSEngineApplyEffectOnViewWithState:(MSEngineState)state{
    // Apply alpha.
    [self MSEngineApplyAlphaOnViewWithState:state];
}

// Apply alpha on controllers when moving.
- (void)MSEngineApplyAlphaOnViewWithState:(MSEngineState)state{
    // Init datas.
    UIView *viewToFade = nil;
    CGFloat alphaBack = kMSEngineFadeValueMin;
    CGFloat alphaMaster = kMSEngineFadeValueMin;
    
    // Load settings for the state.
    switch (state) {
        case MSEngineStateSlideNone:
        case MSEngineStateSlideEnded:               
            break;
            
        case MSEngineStateSlideLeft:
            viewToFade = rightController_.view;
            if (kMSEngineFadeRightEnabled)
                if (currentMSEnginePosition_ == MSEngineCurrentPositionOrigin)
                    alphaBack = kMSEngineFadeValueMin;
                else
                    alphaBack = kMSEngineFadeValueMax;
            break;
            
        case MSEngineStateSlideRight:
            viewToFade = leftController_.view;
            if (kMSEngineFadeLeftEnabled)
                if (currentMSEnginePosition_ == MSEngineCurrentPositionOrigin)
                    alphaBack = kMSEngineFadeValueMin;
                else
                    alphaBack = kMSEngineFadeValueMax;
            break;
    }     
    
    // Add fade on master controller.
    if (currentMSEnginePosition_ == MSEngineCurrentPositionOrigin && kMSEngineFadeRootEnabled)
        alphaMaster = kMSEngineFadeValueMax;
    else
        alphaMaster = kMSEngineFadeValueMin;
    
    // Exit if no fade are enabled.
    if (!viewToFade && !kMSEngineFadeRootEnabled)
        return;
    
    // Animating the alpha.
    [UIView animateWithDuration:kMSEngineAnimationDuration 
                          delay:kMSEngineAnimationDelay 
                        options:kMSEngineAnimationType 
                     animations:^{
                         // A fade is selected on a view.
                         if (viewToFade)
                             viewToFade.alpha = alphaBack;
                         
                         // Fade the master controller.
                         if (kMSEngineFadeRootEnabled)
                             masterControllerNav_.view.alpha = alphaMaster;
                     }
                     completion:^(BOOL completed){
                         // Animation is now finished.
                         if (completed){
                         }
                     }];    
}

#pragma mark - Slide Down Engine Delegate
// MS Engine status will BEGIN.
- (void)MSEngineWillBegin{
    // Call the delegate.
    if ([(id) delegate_ respondsToSelector:@selector(MSEngineWillBegin:)])
		[delegate_ MSEngineWillBegin:self];
}

//  MS Engine status did BEGIN.
- (void)MSEngineDidBegin{
    // Call the delegate.
    if ([(id) delegate_ respondsToSelector:@selector(MSEngineDidBegin:)])
		[delegate_ MSEngineDidBegin:self];
}

//  MS Engine status will MOVE.
- (void)MSEngineWillMove{
    // Call the delegate.
    if ([(id) delegate_ respondsToSelector:@selector(MSEngineWillMove:andState:)])
		[delegate_ MSEngineWillMove:self andState:currentMSEngineState_];
}

//  MS Engine status did MOVE.
- (void)MSEngineDidMove{
    // Call the delegate.
    if ([(id) delegate_ respondsToSelector:@selector(MSEngineDidMove:andState:)])
		[delegate_ MSEngineDidMove:self andState:currentMSEngineState_];
}

//  MS Engine status will END.
- (void)MSEngineWillEnd{
    // Call the delegate.
    if ([(id) delegate_ respondsToSelector:@selector(MSEngineWillEnd:)])
		[delegate_ MSEngineWillEnd:self];
}

//  MS Engine status did END.
- (void)MSEngineDidEnd{
    // Call the delegate.
    if ([(id) delegate_ respondsToSelector:@selector(MSEngineDidEnd:)])
		[delegate_ MSEngineDidEnd:self];
}

@end