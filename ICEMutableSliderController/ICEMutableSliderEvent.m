//
//  ICEMutableSliderEvent.m
//  ICEDK
//
//  Created by Icepat on 09/05/12.
//  Copyright (c) 2012 Icepat. All rights reserved.
//

#import "ICEMutableSliderEvent.h"
#import "ICEMutableSliderEngine.h"

@implementation ICEMutableSliderEvent

// Send a custom notification to the Mutable Slider Engine to change the main view.
+ (void)postEventCustom:(NSUInteger)eventID{
    [[NSNotificationCenter defaultCenter] postNotificationName:MS_ENGINE_EVENT object:[NSString stringWithFormat:@"%i",eventID]];
}

// You can do the same with a pre-defined event.
// Here the call to show the WelcomeController.
+ (void)postEventWelcome{
    [[NSNotificationCenter defaultCenter] postNotificationName:MS_ENGINE_EVENT object:[NSString stringWithFormat:@"%i",MSEngineRemoteEventWelcomeController]];
}

// You can do the same with a pre-defined event.
// Here the call to show the RichLabelController.
+ (void)postEventRichLabel{
    [[NSNotificationCenter defaultCenter] postNotificationName:MS_ENGINE_EVENT object:[NSString stringWithFormat:@"%i",MSEngineRemoteEventRichLabelController]];
}

@end
