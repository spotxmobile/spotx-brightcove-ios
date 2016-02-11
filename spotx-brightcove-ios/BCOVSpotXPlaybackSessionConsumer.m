//
//  Copyright (c) 2016 spotxchange. All rights reserved.
//

#import "BCOVSpotXPlaybackSessionConsumer.h"
#import "BCOVSpotXComponent.h"
#import "AdManager/SpotX.h"

@interface BCOVSpotXPlaybackSessionConsumer() <SpotXAdDelegate>
@end

@implementation BCOVSpotXPlaybackSessionConsumer {
  SpotXView *_adView;
  NSString * _channelID;
  UIViewController * _viewController;
  UIViewController * _adController;
  id<BCOVPlaybackSession> _suspendedSession;
  id<BCOVPlaybackController> _playbackController;
}

-(id)initWithChannelID:(NSString *)channelID forPlaybackController:(id<BCOVPlaybackController>)playbackController activeController:(UIViewController *)viewController {
  self = [super init];
  if (self) {
    _viewController = viewController;
    _playbackController = playbackController;
    _channelID = channelID;
  }

  return self;
}

#pragma mark - BCOVPlaybackSessionBasicConsumer

- (void)didAdvanceToPlaybackSession:(id<BCOVPlaybackSession>)session {
}

- (void)playbackSession:(id<BCOVPlaybackSession>)session didProgressTo:(NSTimeInterval)progress {
  // if the playback session is currently suspened, make sure that the video is always paused
  if ((nil != _suspendedSession) && (_suspendedSession.player.rate > 0.0)) {
    [_suspendedSession.player pause];
  }
}

/**
 * Called when a session's playhead passes cue points registered with its video.
 * This will occur regardless of whether the playhead passes the cue point time
 * for standard progress (playback), or seeking (forward or backward) through
 * the media. When a delegate is set on a playback controller, this method will
 * only be called for future cue point events (any events that have already
 * occurred will not be reported).
 *
 * If multiple cue points are registered to a time or times that fall between
 * the "previous time" and "current time" for a cue point event, all cue points
 * after the "previous time" and before or on "current time" will be included
 * in the cue point collection. Put differently, multiple cue points at the
 * same time are aggregated into a single cue point event whose collection will
 * contain all of those cue points. The most likely scenario in which this
 * would happen is when seeking across a time range that includes multiple cue
 * points (potentially at different times) -- this will result in a single cue
 * point event whose previous time is the point at which seek began, whose
 * current time is the destination of the seek, and whose cue points are all of
 * the cue points whose time fell within that range.
 *
 * The cuePointInfo dictionary will contain the following keys and values for
 * each cue point event:
 *
 *   kBCOVPlaybackSessionEventKeyPreviousTime: the progress interval immediately
 *     preceding the cue points for which this event was received.
 *   kBCOVPlaybackSessionEventKeyCurrentTime: the progress interval on or
 *     immediately after the cue points for which this event was received.
 *   kBCOVPlaybackSessionEventKeyCuePoints: the BCOVCuePointCollection of cue
 *     points for which this event was received.
 *
 * @param session The playback session whose cue points were passed.
 * @param cuePointInfo A dictionary of information about the cue point event.
 */
- (void)playbackSession:(id<BCOVPlaybackSession>)session didPassCuePoints:(NSDictionary *)cuePointInfo {
  BCOVCuePointCollection * cuePoints = cuePointInfo[kBCOVPlaybackSessionEventKeyCuePoints];
  for (BCOVCuePoint * cuePoint in cuePoints) {
    if ([cuePoint.type isEqualToString:@"AD"]) {

      dispatch_async(dispatch_get_main_queue(), ^(void){
        if (nil == _adView) {
          // stop playback
          _suspendedSession = session;
          [_suspendedSession.player pause];

          // load the ad
          _adView = [[SpotXView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
          _adView.delegate = self;
          _adView.channelID = _channelID;

          [_adView startLoading];
          [_adView show];
        }

      });

      break;
    }
  }
}

-(void)hideAdResumeVideo {
  if (_adController) {
    _adView = nil;
    [_adController dismissViewControllerAnimated:true completion:^{
      _adController = nil;

      [self resumeVideo];
    }];
  }
  else {
    [self resumeVideo];
  }
}

-(void)resumeVideo {
  NSLog(@"Resume Video");
  dispatch_async(dispatch_get_main_queue(), ^(void){
    if (nil != _suspendedSession) {
      [_suspendedSession.player play];
      _suspendedSession = nil;
    }
  });

}

-(void)fireLifecycleEvent:(NSString *)eventName {
  if ([_playbackController.delegate respondsToSelector:@selector(playbackController:playbackSession:didReceiveLifecycleEvent:)]) {
    BCOVPlaybackSessionLifecycleEvent * event = [[BCOVPlaybackSessionLifecycleEvent alloc] initWithEventType:eventName properties:nil];

    [_playbackController.delegate playbackController:_playbackController playbackSession:_suspendedSession didReceiveLifecycleEvent:event
     ];
  }
}

#pragma mark - SpotXAdDelegate

- (void)presentViewController:(UIViewController *)viewControllerToPresent
{
  _adController = viewControllerToPresent;
  [_viewController presentViewController:viewControllerToPresent animated:YES completion:nil];
  [self fireLifecycleEvent: kBCOVSpotXLifecycleEventAdPresenting];
}

- (void)adFailedWithError:(NSError *)error
{
  [self fireLifecycleEvent: kBCOVSpotXLifecycleEventAdError];
  [self hideAdResumeVideo];
}

- (void)adError
{
  [self fireLifecycleEvent: kBCOVSpotXLifecycleEventAdError];
  [self hideAdResumeVideo];
}

- (void)adLoaded
{
  [self fireLifecycleEvent: kBCOVSpotXLifecycleEventAdLoaded];
}

- (void)adCompleted
{
  [self fireLifecycleEvent: kBCOVSpotXLifecycleEventAdCompleted];
  [self hideAdResumeVideo];
}

- (void)adClosed
{
  [self fireLifecycleEvent: kBCOVSpotXLifecycleEventAdCompleted];
  [self hideAdResumeVideo];
}

- (void)adClicked
{
}

@end
