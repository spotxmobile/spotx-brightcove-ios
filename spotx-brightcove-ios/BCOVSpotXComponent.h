//
//  Copyright (c) 2016 spotxchange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BrightcovePlayerSDK/BrightcovePlayerSDK.h>

extern NSString * const kBCOVSpotXLifecycleEventAdPresenting;
extern NSString * const kBCOVSpotXLifecycleEventAdLoaded;
extern NSString * const kBCOVSpotXLifecycleEventAdError;
extern NSString * const kBCOVSpotXLifecycleEventAdCompleted;

@interface BCOVPlayerSDKManager (BCOVSpotXAdditions)
/**
 * Creates and returns a new playback controller with the specified SpotX
 * channel id, and the active view controller.
 *
 * @param SpotX channel id to use for the ad request.
 * @param activeController the view controller upon which the ad view controller will be displayed modally.
 * @return A new playback controller with the specified parameters.
 */
- (id<BCOVPlaybackController>)createSpotXPlaybackControllerForChannel:(NSString *)channelID activeController:(UIViewController *)viewController;

@end
