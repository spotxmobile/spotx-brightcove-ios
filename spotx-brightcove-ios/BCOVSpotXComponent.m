//
//  Copyright (c) 2016 spotxchange. All rights reserved.
//

#import "BCOVSpotXComponent.h"
#import "BCOVSpotXPlaybackSessionConsumer.h"

NSString * const kBCOVSpotXLifecycleEventAdPresenting = @"kBCOVSpotXLifecycleEventAdPresenting";
NSString * const kBCOVSpotXLifecycleEventAdLoaded = @"kBCOVSpotXLifecycleEventAdLoaded";
NSString * const kBCOVSpotXLifecycleEventAdError = @"kBCOVSpotXLifecycleEventAdError";
NSString * const kBCOVSpotXLifecycleEventAdCompleted = @"kBCOVSpotXLifecycleEventAdCompleted";

@implementation BCOVPlayerSDKManager  (BCOVSpotXAdditions)

- (id<BCOVPlaybackController>)createSpotXPlaybackControllerForChannel:(NSString *)channelID activeController:(UIViewController *)viewController {

  BCOVBasicSessionProviderOptions * options = [[BCOVBasicSessionProviderOptions alloc] init];
  id<BCOVPlaybackSessionProvider> provider = [[BCOVBasicSessionProvider alloc] initWithOptions: options];

  id<BCOVPlaybackController> controller = [self createPlaybackControllerWithSessionProvider:provider viewStrategy:[self defaultControlsViewStrategy]];

  BCOVSpotXPlaybackSessionConsumer * consumer = [[BCOVSpotXPlaybackSessionConsumer alloc] initWithChannelID:channelID forPlaybackController:controller activeController:viewController];
  [controller addSessionConsumer: consumer];

  return controller;
}

@end

