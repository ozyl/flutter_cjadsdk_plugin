#import "FlutterCjadsdkPlugin.h"
#if __has_include(<flutter_cjadsdk_plugin/flutter_cjadsdk_plugin-Swift.h>)
#import <flutter_cjadsdk_plugin/flutter_cjadsdk_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_cjadsdk_plugin-Swift.h"

#endif

#import "NativeViewFactory.h"
#import "NativeFlutterPlatformView.h"

// 提供给flutter的方法
NSString *preReward               = @"preReward";  // 激励视频预加载（android支持）
NSString *setupFuncName           = @"cjSdkSetup"; // 广告sdk初始化
NSString *splashFuncName          = @"cjLoadAndShowSplashMethod"; // 加载并且显示开屏
NSString *rewardVideoFuncName     = @"cjLoadAndShowRewardVideoMethod"; // 加载并显示激励视频
NSString *fullscreenVideoFuncName = @"cjLoadAndShowFullscreenVideoAdMethod"; // 加载并且显示全屏视频
NSString *interstitialFuncName    = @"cjLoadAndShowInterstitialAdMethod"; // 加载并且显示插屏
NSString *shortVideoFuncName      = @"cjShowShortVideoAdMethod"; // 加载并显示短视频（短视频需要特别引入）
NSString *nativeFuncName          = @"cjLoadAndShowNativeAdMethod"; // 加载并展示信息流
NSString *bannerFuncName          = @"cjLoadAndShowBannerAdMethod"; // 加载并展示信息流

// 初始化相关回调
NSString *setupSuccess = @"setupSuccess"; // 初始化成功
NSString *setupFailed  = @"setupFailed";   // 初始化失败

// 开屏广告位回调
NSString *splashAdLoadSuccess = @"splashAdLoadSuccess"; // 加载成功
NSString *splashAdLoadFailed  = @"splashAdLoadFailed";   // 加载失败
NSString *splashAdOnShow      = @"splashAdOnShow";       // 已经显示
NSString *splashAdOnClick     = @"splashAdOnClick";      // 点击事件
NSString *splashAdOnClose     = @"splashAdOnClose";     // 关闭事件

// 激励视频相关回调
NSString *rewardVideoAdBeRewarded  = @"rewardVideoAdBeRewarded";   // 达成奖励
NSString *rewardVideoAdLoadSuccess = @"rewardVideoAdLoadSuccess";  // 加载成功
NSString *rewardVideoAdLoadFailed  = @"rewardVideoAdLoadFailed";   // 加载失败
NSString *rewardVideoAdOnShow      = @"rewardVideoAdOnShow";       // 已经显示
NSString *rewardVideoAdOnClick     = @"rewardVideoAdOnClick";      // 点击事件
NSString *rewardVideoAdOnClose     = @"rewardVideoAdOnClose";      // 关闭事件

// 插屏视频相关回调
NSString *interstitialAdLoadSuccess = @"interstitialAdLoadSuccess";   // 加载成功
NSString *interstitialAdLoadFailed  = @"interstitialAdLoadFailed";    // 加载失败
NSString *interstitialAdOnShow      = @"interstitialAdOnShow";        // 已经显示
NSString *interstitialAdOnClick     = @"interstitialAdOnClick";       // 点击事件
NSString *interstitialAdOnClose     = @"interstitialAdOnClose";       // 关闭事件

// 全屏视频相关回调
NSString *fullscreenVideoAdLoadSuccess = @"fullscreenVideoAdLoadSuccess";   // 加载成功
NSString *fullscreenVideoAdLoadFailed  = @"fullscreenVideoAdLoadFailed";    // 加载失败
NSString *fullscreenVideoAdOnShow      = @"fullscreenVideoAdOnShow";        // 已经显示
NSString *fullscreenVideoAdOnClick     = @"fullscreenVideoAdOnClick";       // 点击事件
NSString *fullscreenVideoAdOnClose     = @"fullscreenVideoAdOnClose";       // 关闭事件

// 信息流相关回调
NSString *nativeAdLoadSuccess = @"nativeAdLoadSuccess";   // 加载成功
NSString *nativeAdLoadFailed  = @"nativeAdLoadFailed";    // 加载失败
NSString *nativeAdOnShow      = @"nativeAdOnShow";        // 已经显示
NSString *nativeAdOnClick     = @"nativeAdOnClick";       // 点击事件
NSString *nativeAdOnClose     = @"nativeAdOnClose";       // 关闭事件

NSString *bannerAdLoadSuccess = @"bannerAdLoadSuccess";   // 加载成功
NSString *bannerAdLoadFailed  = @"bannerAdLoadFailed";    // 加载失败
NSString *bannerAdOnShow      = @"bannerAdOnShow";        // 已经显示
NSString *bannerAdOnClick     = @"bannerAdOnClick";       // 点击事件
NSString *bannerAdOnClose     = @"bannerAdOnClose";       // 关闭事件

@interface FlutterCjadsdkPlugin()

@property (nonatomic, strong) CJSplashAd *splashAd;
@property (nonatomic, strong) CJRewardVideoAd *rewardVideoAd;
@property (nonatomic, strong) CJFullscreenVideoAd *fullscreenVideoAd;
@property (nonatomic, strong) CJInterstitialAd *interstitialAd;
@property (nonatomic, strong) CJNativeAd *nativeAd;
@property (nonatomic, strong) CJBannerAd *bannerAd;

@end

static FlutterCjadsdkPlugin *plugin = nil;

@implementation FlutterCjadsdkPlugin

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        plugin = [[self alloc] init];
    });
    return plugin;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    NativeViewFactory *factory = [[NativeViewFactory alloc] initWithMessage:registrar.messenger];
    [registrar registerViewFactory:factory withId:@"flutter_cjadsdk_plugin/native_contentView"];
    [FlutterCjadsdkPlugin shareInstance].methodChannel = [FlutterMethodChannel methodChannelWithName:@"flutter_cjadsdk_plugin" binaryMessenger:[registrar messenger]];
     [registrar addMethodCallDelegate:[FlutterCjadsdkPlugin shareInstance] channel:[FlutterCjadsdkPlugin shareInstance].methodChannel];
}
     
- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *advertId = call.arguments[@"advertId"];
    NSString *configId = call.arguments[@"configId"];
    NSString *userId = call.arguments[@"userId"];
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    if (!window) {
        window = UIApplication.sharedApplication.windows.firstObject;
    }
    if ([call.method isEqualToString:setupFuncName]) {
        if (configId.length > 0) {
            // 开始初始化
            [CJADManager openDebugLog];
            [CJADManager configure:configId completeHandle:^(BOOL success, NSError * _Nullable error) {
                if (success) {
                    [self.methodChannel invokeMethod:setupSuccess arguments:@"初始化成功"];
                } else {
                    [self.methodChannel invokeMethod:setupFailed arguments:@"初始化失败"];
                }
            }];
            return;
        } else {
            [self.methodChannel invokeMethod:setupFailed arguments:@"初始化失败"];
        }
    }
    if ([call.method isEqualToString:splashFuncName]) {
        CJSplashAd *splashAd = [[CJSplashAd alloc] initWithResourceId:advertId rootViewController:window.rootViewController customLogoView: [UIView new]];
        splashAd.delegate = self;
        [splashAd loadAdData];
        self.splashAd = splashAd;
    } else if ([call.method isEqualToString:rewardVideoFuncName]) {
        CJRewardVideoAd *rewardVideoAd = [[CJRewardVideoAd alloc] initWithResourceId:advertId userId:userId extend:@"" verificationMode:0];
        rewardVideoAd.delegate = self;
        [rewardVideoAd loadAdData];
        self.rewardVideoAd = rewardVideoAd;
    } else if ([call.method isEqualToString:fullscreenVideoFuncName]) {
        CJFullscreenVideoAd *fullscreen = [[CJFullscreenVideoAd alloc] initWithResourceId:advertId];
        fullscreen.delegate = self;
        [fullscreen loadAdData];
        self.fullscreenVideoAd = fullscreen;
    } else if ([call.method isEqualToString:nativeFuncName]) {
        CJNativeAd *nativeAd = [[CJNativeAd alloc] initWithSlotId:advertId size:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width*9/16) rootViewController:[self getCurrentVC]];
        nativeAd.delegate = self;
        [nativeAd loadAdData:1];
        self.nativeAd = nativeAd;
    } else if ([call.method isEqualToString:bannerFuncName]) {
        CJBannerAd *bannerAd = [[CJBannerAd alloc] initWithResourceId:advertId rootViewController:[self getCurrentVC] rect:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width*50/320)];
        bannerAd.delegate = self;
        [bannerAd loadAdData];
        self.bannerAd = bannerAd;
    } else if ([call.method isEqualToString:interstitialFuncName]) {
        CJInterstitialAd *interstitialAd = [[CJInterstitialAd alloc] initWithResourceId:advertId];
        interstitialAd.delegate = self;
        [interstitialAd loadAdData];
        self.interstitialAd = interstitialAd;
    } else if ([call.method isEqualToString:shortVideoFuncName]) {
        UIViewController *videoVC = [ShortViewController new];
        UIViewController *currentVC = [self getCurrentVC];
        videoVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [currentVC presentViewController:videoVC animated:true completion:nil];
    } else {
        // 未知
        [self.methodChannel invokeMethod:@"unkonw" arguments:@{@"message": @"未知事件"}];
    }
}

+ (UIWindow *)getCurrentWindow {
    UIWindow *window = UIApplication.sharedApplication.delegate.window;
    if (!window) {
        window = UIApplication.sharedApplication.windows.firstObject;
    }
    return window;
}

- (UIViewController *)getCurrentVC
{
    UIViewController*result =nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray*windows = [[UIApplication sharedApplication] windows];
        for(UIWindow* tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    //从根控制器开始查找
    UIViewController*rootVC = window.rootViewController;
    id nextResponder = [rootVC.view nextResponder];
    if([nextResponder isKindOfClass:[UINavigationController class]]) {
        result = ((UINavigationController*)nextResponder).topViewController;
        if([result isKindOfClass:[UITabBarController class]]) {
            result = ((UITabBarController*)result).selectedViewController;
        }
        
    } else if([nextResponder isKindOfClass:[UITabBarController class]]) {
        result = ((UITabBarController*)nextResponder).selectedViewController;
            if([result isKindOfClass:[UINavigationController class]]) {
                result = ((UINavigationController*)result).topViewController;
            }
        
    } else if([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    } else {
        result = window.rootViewController;
                    if([result isKindOfClass:[UINavigationController class]]) {
                        result = ((UINavigationController*)result).topViewController;
                        if([result isKindOfClass:[UITabBarController class]]) {
                            result = ((UITabBarController*)result).selectedViewController;
                        }
                    }
        else if([result isKindOfClass:[UIViewController class]]) {
            result = nextResponder;
        }
    }
    return result;
}
 
#pragma mark CJSplashAdDelegate
- (void)splashAdDidLoad:(CJSplashAd *)splashAd resourceId:(NSString *)resourceId {
    [splashAd showSplashAdToWindow:[FlutterCjadsdkPlugin getCurrentWindow]];
    [[FlutterCjadsdkPlugin shareInstance].methodChannel invokeMethod:splashAdLoadSuccess arguments:@"开屏加载成功"];
}

- (void)splashAdOnShow:(CJSplashAd *)splashAd {
    [[FlutterCjadsdkPlugin shareInstance].methodChannel invokeMethod:splashAdOnShow arguments:@"开屏已经显示"];
}

- (void)splashAdLoadFailed:(CJSplashAd *)splashAd error:(NSError *)error {
    [[FlutterCjadsdkPlugin shareInstance].methodChannel invokeMethod:splashAdLoadFailed arguments:@{@"message": error.description}];
}

- (void)splashAdOnClicked:(CJSplashAd *)splashAd {
    [[FlutterCjadsdkPlugin shareInstance].methodChannel invokeMethod:splashAdOnClick arguments:@"点击开屏"];
}

- (void)splashAdOnClosed:(CJSplashAd *)splashAd {
    [[FlutterCjadsdkPlugin shareInstance].methodChannel invokeMethod:splashAdOnClose arguments:@"关闭开屏"];
}

#pragma mark CJRewardVideoAdDelegate
// 达到奖励条件

- (void)rewardVideoOnRewarded:(CJRewardVideoAd *)rewardAd requestId:(NSString *)requestId {
    // 获得奖励
    [[FlutterCjadsdkPlugin shareInstance].methodChannel invokeMethod:rewardVideoAdBeRewarded arguments:@{@"requestId": requestId, @"message": @"达成奖励"}];
}

- (void)rewardVideoAdOnShow:(CJRewardVideoAd *)rewardAd {
    [[FlutterCjadsdkPlugin shareInstance].methodChannel invokeMethod:rewardVideoAdOnShow arguments:@"激励视频已经显示"];
}

// 加载成功
- (void)rewardVideoAdDidLoad:(CJRewardVideoAd *)rewardAd resourceId:(NSString *)resourceId {
    [rewardAd showFromRootViewController:[self getCurrentVC]];
    [[FlutterCjadsdkPlugin shareInstance].methodChannel invokeMethod:rewardVideoAdLoadSuccess arguments:@"激励视频加载成功"];
}

// 加载失败
- (void)rewardVideoAdLoadFailed:(CJRewardVideoAd *)rewardAd error:(NSError *)error {
    [[FlutterCjadsdkPlugin shareInstance].methodChannel invokeMethod:rewardVideoAdLoadFailed arguments:@{@"message": error.description}];
}

// 点击
- (void)rewardVideoAdOnClicked:(CJRewardVideoAd *)rewardAd {
    [[FlutterCjadsdkPlugin shareInstance].methodChannel invokeMethod:rewardVideoAdOnClick arguments:@"点击激励视频"];
}

// 关闭
- (void)rewardVideoAdOnClosed:(CJRewardVideoAd *)rewardAd {
    [[FlutterCjadsdkPlugin shareInstance].methodChannel invokeMethod:rewardVideoAdOnClose arguments:@"关闭激励视频"];
}

#pragma mark CJFullscreenVideoAdDelegate
- (void)fullscreenVideoAdDidLoad:(CJFullscreenVideoAd *)fullscreenAd resourceId:(NSString *)resourceId {
    [fullscreenAd showFromRootViewController: [self getCurrentVC]];
    [[FlutterCjadsdkPlugin shareInstance].methodChannel invokeMethod:fullscreenVideoAdLoadSuccess arguments:@"全屏视频加载成功"];
}

- (void)fullscreenVideoAdOnShow:(CJFullscreenVideoAd *)fullscreenAd {
    [[FlutterCjadsdkPlugin shareInstance].methodChannel invokeMethod:fullscreenVideoAdOnShow arguments:@"全屏视频已经展示"];
}

- (void)fullscreenVideoAdLoadFailed:(CJFullscreenVideoAd *)fullscreenAd error:(NSError *)error {
    [[FlutterCjadsdkPlugin shareInstance].methodChannel invokeMethod:fullscreenVideoAdLoadFailed arguments:@{@"message": error.description}];
}

- (void)fullscreenVideoAdOnClicked:(CJFullscreenVideoAd *)fullscreenAd {
    [[FlutterCjadsdkPlugin shareInstance].methodChannel invokeMethod:fullscreenVideoAdOnClick arguments:@"点击全屏视频"];
}

- (void)fullscreenVideoAdOnClosed:(CJFullscreenVideoAd *)fullscreenAd {
    [[FlutterCjadsdkPlugin shareInstance].methodChannel invokeMethod:fullscreenVideoAdOnClose arguments:@"关闭全屏视频"];
}

#pragma mark CJInterstitialAdDelegate
- (void)interstitialAdDidLoad:(CJInterstitialAd *)interstitialAd resourceId:(NSString *)resourceId {
    [interstitialAd showFromRootViewController:[self getCurrentVC]];
    [[FlutterCjadsdkPlugin shareInstance].methodChannel invokeMethod:interstitialAdLoadSuccess arguments:@"插屏加载成功"];
}

- (void)interstitialAdOnShow:(CJInterstitialAd *)interstitialAd {
    [[FlutterCjadsdkPlugin shareInstance].methodChannel invokeMethod:interstitialAdOnShow arguments:@"插屏已经展示"];
}

- (void)interstitialAdLoadFailed:(CJInterstitialAd *)interstitialAd error:(NSError *)error {
    [[FlutterCjadsdkPlugin shareInstance].methodChannel invokeMethod:interstitialAdLoadFailed arguments:@{@"message": error.description}];
}

- (void)interstitialAdOnClicked:(CJInterstitialAd *)interstitialAd {
    [[FlutterCjadsdkPlugin shareInstance].methodChannel invokeMethod:interstitialAdOnClick arguments:@"点击插屏"];
}

- (void)interstitialAdOnClosed:(CJInterstitialAd *)interstitialAd {
    [[FlutterCjadsdkPlugin shareInstance].methodChannel invokeMethod:interstitialAdOnClose arguments:@"关闭插屏"];
}

#pragma mark CJNativeAdDelegate
- (void)nativeExpressAdOnShow:(id)nativeExpressView {
    [[FlutterCjadsdkPlugin shareInstance].methodChannel invokeMethod:nativeAdOnShow arguments:@"信息流已经展示"];
}

- (void)nativeExpressAdDidLoad:(NSArray *)nativeExpressViews {
    if (nativeExpressViews.count > 0) {
        if ([nativeExpressViews.firstObject isKindOfClass:[UIView class]]) {
            UIView *expressView = (UIView *)nativeExpressViews.firstObject;
            CGFloat height = expressView.frame.size.height;
            [self.nativeView addSubview:expressView];
            [[FlutterCjadsdkPlugin shareInstance].methodChannel invokeMethod:nativeAdLoadSuccess arguments:@{@"message": @"信息流加载成功", @"height": @(height)}];
        }
    }
}

- (void)nativeExpressAdLoadFailed:(id)nativeExpressAd error:(NSError *)error {
    [[FlutterCjadsdkPlugin shareInstance].methodChannel invokeMethod:nativeAdLoadFailed arguments:@{@"message": error.description}];
}

- (void)nativeExpressAdOnClicked:(id)nativeExpressView {
    [[FlutterCjadsdkPlugin shareInstance].methodChannel invokeMethod:nativeAdOnClick arguments:@"信息流触发点击"];
}

- (void)nativeExpressAdOnClosed:(id)nativeExpressView {
    [[FlutterCjadsdkPlugin shareInstance].methodChannel invokeMethod:nativeAdOnClose arguments:@"信息流已经关闭"];
}

#pragma mark CJBannerAdDelegate
- (void)bannerAdDidLoad:(UIView *)bannerView resourceId:(NSString *)resourceId {
    if ([bannerView isKindOfClass:[UIView class]]) {
        CGFloat height = bannerView.frame.size.height;
        [self.nativeView addSubview:bannerView];
        [[FlutterCjadsdkPlugin shareInstance].methodChannel invokeMethod:bannerAdLoadSuccess arguments:@{@"message": @"banner加载成功", @"height": @(height)}];
    }
}

- (void)bannerAdOnShow:(id)bannerAd {
    [[FlutterCjadsdkPlugin shareInstance].methodChannel invokeMethod:bannerAdOnShow arguments:@"banner已经展示"];
}

- (void)bannerAdLoadFailed:(id)bannerAd error:(NSError *)error{
    [[FlutterCjadsdkPlugin shareInstance].methodChannel invokeMethod:bannerAdLoadFailed arguments:@{@"message": error.description}];
}

- (void)bannerAdOnClicked:(id)bannerAd {
    [[FlutterCjadsdkPlugin shareInstance].methodChannel invokeMethod:bannerAdOnClick arguments:@"banner触发点击"];
}

- (void)bannerAdOnClosed:(id)bannerAd {
    [[FlutterCjadsdkPlugin shareInstance].methodChannel invokeMethod:bannerAdOnClose arguments:@"banner已经关闭"];
}

@end

