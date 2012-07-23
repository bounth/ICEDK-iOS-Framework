//
//  ICEConstants.h
//  ICEDK
//
//  Created by Icepat on 03/05/12.
//  Copyright (c) 2012 Icepat. All rights reserved.
//

#ifndef ICEDK_Examples_ICEConstants_h
#define ICEDK_Examples_ICEConstants_h

// Define the HASH structure for hidden "tag"
// #HASH is the first part followed by 3 digit (USR / PIC / TXT...)
// Then you put your printable text
// Then add the #HASHKEY
// End finish with your linked object key (object saved in a dictionnary)
#define hash                        @"#HASH"
#define hashUSR                     @""hash"USR"
#define hashGAL                     @""hash"GAL"
#define hashKey                     @""hash"KEY"
#define kTextSlicedSeparator        @" "

// **************************************
// **        SLIDE ENGINE DATAS        **
// **************************************
// Change values for custom design.
#define   kMSEngineNavigationBarTintColor                  nil
// Change values for custom moves.
#define   kMSEngineAnimationDuration                       0.4    // Animation duration in secondes
#define   kMSEngineAnimationDelay                          0.0    // Animation delay in secondes
#define   kMSEngineAnimationType                           UIViewAnimationCurveEaseInOut
// Change values for custom fading.
#define   kMSEngineFadeRootEnabled                         0      // 1 = Enabled, 0 = Disabled
#define   kMSEngineFadeLeftEnabled                         1      // 1 = Enabled, 0 = Disabled
#define   kMSEngineFadeRightEnabled                        1      // 1 = Enabled, 0 = Disabled
#define   kMSEngineFadeValueMin                            1      // Minimum value in %
#define   kMSEngineFadeValueMax                            0.6    // Maximum value in %
// Change values for custom slider management.
#define   kMSEngineFingerStartTheSlider                    1      // 1 = Enabled, 0 = Disabled
#define   kMSEngineFingerIsAnchorWhenMoving                1      // 1 = Enabled, 0 = Disabled
#define   kMSEngineFingerMinimumMoveBeforeSliding          10     // In pixels
#define   kMSEngineAddLeftButton                           1      // 1 = Enabled, 0 = Disabled
#define   kMSEngineAddRightButton                          1      // 1 = Enabled, 0 = Disabled
// Change values for custom sliding management.
// If you set 'kMSEngineMaxSlidePositionBackgroundController', it's the size of the corresponding controller that will be used
#define   kMSEngineMaxSlidePositionEndLeft                 220    // In pixels
#define   kMSEngineMaxSlidePositionEndRight                180    // In pixels
#define   kMSEngineMaxSlidePositionBackgroundController    999    // In pixels
// Engine events RX/TX.
#define   MS_ENGINE_EVENT                                  @"MS_ENGINE_EVENT"

#endif
