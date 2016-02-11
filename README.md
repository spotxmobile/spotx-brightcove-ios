# Who Can Use the Plugin

To use the plugin, you need to be a SpotX publisher and have an active account with [Brightcove](http://www.brightcove.com).

## Becoming a SpotX Publisher

If you are not already a SpotX Publisher, click [here](https://www.spotxchange.com/publishers/apply-to-become-a-spotx-publisher/) to apply.

## About this Plugin

The SpotX-Brightcove plugin allows the [Brightcove Player SDK for iOS](https://docs.brightcove.com/en/video-cloud/mobile-sdks/brightcove-player-sdk-for-ios/index.html)
to seamlessly play SpotX Ad content during Brightcove video playback.

## How to Install the Plugin

There are two ways to install this plugin:

### CocoaPods (preferred)

Simply add the following to your Podfile.

```ruby
pod 'SpotX-Brightcove-Plugin'
```
Using our cocoapod will automatically include the required Pods for the SpotX SDK
and Brightcove Player SDK.  

### Source Code

Download the source code and import it in your Xcode project. The project is available from our [Github repository](https://github.com/spotxmobile/spotx-brightcove-ios).

You will be required to manually include the [SpotX SDK](https://github.com/spotxmobile/spotx-sdk-ios) and Brightcove Player SDK. 

### Integration

After completing your integration using the [Brightcove Player SDK for iOS](https://docs.brightcove.com/en/video-cloud/mobile-sdks/brightcove-player-sdk-for-ios/index.html),
you will need to add some extra code to configure and initialize the interface to SpotX.

#### Initializing the SpotX SDK

Typically, you would initialize the SpotX SDK in the AppDelegate of your app.
``` objective-c
// File: AppDelegate.m

#import <UIKit/UIKit.h>
#import <AdManager/SpotX.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
  // We need the below code in order to ensure that audio plays back when we
  // expect it to. For example, without setting this code, we won't hear the video
  // when the mute switch is on. For simplicity in the sample, we are going to
  // put this in the app delegate.  Check out https://developer.apple.com/Library/ios/documentation/Audio/Conceptual/AudioSessionProgrammingGuide/Introduction/Introduction.html
  // for more information on how to use this in your own app.

  NSError *categoryError = nil;
  BOOL success = [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&categoryError];

  if (!success)
  {
    NSLog(@"AppDelegate Debug - Error setting AVAudioSession category.  Because of this, there may be no sound. `%@`", categoryError);
  }

  [SpotX initializeWithApiKey:nil category:@"IAB1" section:@"Fiction" domain:@"com.spotxchange.demo" url:@"https://itunes.apple.com/us/app/spotxchange_advertisments/id123456789"];
  [SpotX setDefaultChannelID:@"85394"];

  // Optional: Configure default settings
  id<SpotXAdSettings> settings = [SpotX defaultSettings];
  settings.useHTTPS = @YES;
  settings.useNativeBrowser = @YES;
  settings.allowCalendar = @NO;

  return YES;
}

@end
```

Next, change the call to create the Brightcove playback controller to create the SpotX Plugin version
of the playback controller.
In the following example, you should replace **[SpotX Channel ID]** with the SpotX Channel ID
you wish to use.

If you want to receive ad events (AdLoaded, AdCompleted, etc), you should implement the delegate method
*didReceiveLifecycleEvent:* on the *BCOVPlaybackControllerDelegate* delegate. 

``` objective-
#import "BCOVSpotXComponent.h"

static NSString * const kViewControllerCatalogToken = @"ZUPNyrUqRdcAtjytsjcJplyUc9ed8b0cD_eWIe36jXqNWKzIcE6i8A..";
static NSString * const kViewControllerPlaylistID = @"3637400917001";

@interface ViewController () <BCOVPlaybackControllerDelegate>

@property (nonatomic, strong) BCOVCatalogService *catalogService;
@property (nonatomic, strong) id<BCOVPlaybackController> playbackController;
@property (nonatomic, weak) IBOutlet UIView *videoContainer;a

@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
  self = [super initWithCoder:coder];
  if (self)
  {
    [self setup];
  }
  return self;
}

- (void)setup
{
  BCOVPlayerSDKManager *manager = [BCOVPlayerSDKManager sharedManager];

  _playbackController = [manager createSpotXPlaybackControllerForChannel:@"[SpotX Channel ID]" activeController:self];
  _playbackController.delegate = self;
  _playbackController.autoAdvance = YES;
  _playbackController.autoPlay = YES;

  _catalogService = [[BCOVCatalogService alloc] initWithToken:kViewControllerCatalogToken];
}

...

-(void)playbackController:(id<BCOVPlaybackController>)controller playbackSession:(id<BCOVPlaybackSession>)session didReceiveLifecycleEvent:(BCOVPlaybackSessionLifecycleEvent *)lifecycleEvent
{
  // Ad events are emitted by the BCOVSpotX plugin through lifecycle events.
  // The events are defined BCOVSpotXComponent.h.

  NSString *type = lifecycleEvent.eventType;

  if ([type isEqualToString:kBCOVSpotXLifecycleEventAdLoaded])
  {
    NSLog(@"ViewController Debug - Ad loaded.");
  }
  else if ([type isEqualToString:kBCOVSpotXLifecycleEventAdError])
  {
    NSLog(@"ViewController Debug - Ad ERROR!");
  }
  else if ([type isEqualToString:kBCOVSpotXLifecycleEventAdPresenting])
  {
    NSLog(@"ViewController Debug - Ad presenting.");
  }
  else if ([type isEqualToString:kBCOVSpotXLifecycleEventAdCompleted])
  {
    NSLog(@"ViewController Debug - Ad completed.");
  }
}

```




