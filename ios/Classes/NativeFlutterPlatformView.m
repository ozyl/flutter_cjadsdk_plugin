//
//  NativeFlutterPlatformView.m
//  flutter_cjadsdk_plugin
//
//  Created by 熊俊 on 2024/4/12.
//

#import "NativeFlutterPlatformView.h"
#import <Flutter/Flutter.h>
#import "FlutterCjadsdkPlugin.h"

@interface NativeFlutterPlatformView()

@end

@implementation NativeFlutterPlatformView


- (nonnull UIView *)view {
    [FlutterCjadsdkPlugin shareInstance].nativeView = [[UIView alloc] init];
    return [FlutterCjadsdkPlugin shareInstance].nativeView;
}

@end
