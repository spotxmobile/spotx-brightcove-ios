//
//  Copyright (c) 2016 spotxchange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdManager/SpotX.h"
@import BrightcovePlayerSDK;

@interface BCOVSpotXPlaybackSessionConsumer : NSObject <BCOVPlaybackSessionConsumer>

-(id)initWithChannelID:(NSString *)channelID activeController:(UIViewController *)viewController;

@end
