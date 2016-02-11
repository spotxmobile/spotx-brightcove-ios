//
//  Copyright (c) 2016 spotxchange. All rights reserved.
//

#import "BCOVSpotXComponent.h"
#import "BCOVSpotXPlaybackSessionConsumer.h"

@implementation BCOVPlayerSDKManager  (BCOVSpotXAdditions)

- (id<BCOVPlaybackController>)createSpotXPlaybackControllerForChannel:(NSString *)channelID activeController:(UIViewController *)viewController {

  BCOVBasicSessionProviderOptions * options = [[BCOVBasicSessionProviderOptions alloc] init];
  id<BCOVPlaybackSessionProvider> provider = [[BCOVBasicSessionProvider alloc] initWithOptions: options];

  id<BCOVPlaybackController> controller = [self createPlaybackControllerWithSessionProvider:provider viewStrategy:[self defaultControlsViewStrategy]];

  BCOVSpotXPlaybackSessionConsumer * consumer = [[BCOVSpotXPlaybackSessionConsumer alloc] initWithChannelID:channelID activeController:viewController];
  [controller addSessionConsumer: consumer];

  return controller;
}

@end

/**
 * SpotX specific methods for the plugin context.
 */
@implementation BCOVSessionProviderExtension (BCOVSpotXAdditions)

-(void) spotx_play {

}

-(void) spotx_pause {

}

@end
