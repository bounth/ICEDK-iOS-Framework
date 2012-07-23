//
//  ICEMutableSliderEvent.h
//  ICEDK
//
//  Created by Icepat on 09/05/12.
//  Copyright (c) 2012 Icepat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICEMutableSliderEvent : NSObject {
    
}

// Send a custom notification to the Mutable Slider Engine to change the main view.
+ (void)postEventCustom:(NSUInteger)eventID;
// You can do the same with a pre-defined event.
// Here the call to show the WelcomeController.
+ (void)postEventWelcome;
// You can do the same with a pre-defined event.
// Here the call to show the RichLabelController.
+ (void)postEventRichLabel;

@end
