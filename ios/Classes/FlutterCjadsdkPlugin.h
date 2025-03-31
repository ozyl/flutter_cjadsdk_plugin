#import <Flutter/Flutter.h>
#import <CJMobileAd/CJMobileAd.h>
#import "ShortViewController.h"

@interface FlutterCjadsdkPlugin : NSObject<FlutterPlugin, CJSplashAdDelegate, CJRewardVideoAdDelegate, CJFullscreenVideoAdDelegate, CJInterstitialAdDelegate, CJNativeAdDelegate, CJBannerAdDelegate>

@property (nonatomic, strong) FlutterMethodChannel *methodChannel;

/// 原生view
@property (nonatomic, strong) UIView *nativeView;

+ (instancetype)shareInstance;

@end
