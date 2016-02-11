//
//  Copyright (c) 2016 spotxchange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BrightcovePlayerSDK/BrightcovePlayerSDK.h>

@interface BCOVPlayerSDKManager (BCOVSpotXAdditions)
/**
 * Creates and returns a new playback controller with the specified IMASettings
 * object, IMAAdsRenderingSettings object, view strategy, and ad container. The
 * returned playback controller will be configured with an IMA session provider.
 *
 * @param settings An IMASettings that will be used to configure any
 * IMAAdsLoader object used by the returned playback controller.
 * @param adsRenderingSettings An IMAAdsRenderingSettings that will be used to
 * configure any IMAAdsManager object used by the returned playback controller.
 * @param adsRequestPolicy BCOVIMAAdsRequestPolicy instance to generate
 * IMAAdsRequests for use by a given input playback session.
 * @param strategy A view strategy that determines the view for the returned
 * playback controller.
 * @param adContainer the view in which the ad will be displayed and the ad
 * information UI will be rendered.
 * @param companionSlots the list of IMACompanionAdSlot instances. Can be nil
 * or empty.
 * @return A new playback controller with the specified parameters.
 */
- (id<BCOVPlaybackController>)createSpotXPlaybackControllerForChannel:(NSString *)channelID activeController:(UIViewController *)viewController;

@end
