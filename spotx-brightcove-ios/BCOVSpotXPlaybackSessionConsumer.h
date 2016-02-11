//
//  Copyright (c) 2016 spotxchange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BrightcovePlayerSDK/BrightcovePlayerSDK.h>

@interface BCOVSpotXPlaybackSessionConsumer : NSObject <BCOVPlaybackSessionConsumer>

-(id)initWithChannelID:(NSString *)channelID forPlaybackController:(id<BCOVPlaybackController>)playbackController activeController:(UIViewController *)viewController;

@end
