//
//  NativeViewFactory.m
//  flutter_cjadsdk_plugin
//
//  Created by 熊俊 on 2024/4/12.
//

#import "NativeViewFactory.h"
#import "NativeFlutterPlatformView.h"

@interface NativeViewFactory()

@property (nonatomic, strong) id <FlutterBinaryMessenger> messenger;

@end
@implementation NativeViewFactory

- (instancetype)initWithMessage:(id<FlutterBinaryMessenger>)messenger {
    if (self = [super init]) {
        self.messenger = messenger;
    }
    return self;
}

- (NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args {
    NativeFlutterPlatformView *nativeView = [[NativeFlutterPlatformView alloc] init];
    return nativeView;
}

@end
