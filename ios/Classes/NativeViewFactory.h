//
//  NativeViewFactory.h
//  flutter_cjadsdk_plugin
//
//  Created by 熊俊 on 2024/4/12.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface NativeViewFactory : NSObject<FlutterPlatformViewFactory>

-(instancetype)initWithMessage:(id <FlutterBinaryMessenger> _Nonnull)messenger;


@end

NS_ASSUME_NONNULL_END
