import 'dart:convert';
import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cjadsdk_plugin/testAdvertModel.dart';



typedef Callback = void Function(double height);

final valueNotifier = ValueNotifier<double>(100.0);
class FlutterCjadsdkPlugin {
  /// 通道名，需和iOS、android端保持一致
  static const MethodChannel _channel = MethodChannel('flutter_cjadsdk_plugin');
  static BuildContext? context1 = null;
  static void init(context) {
    /// 设置原生调用Flutter时的回调

    
    context1 = context;
    _channel.setMethodCallHandler((call) async {
    
      print("flutter收到新事件" + call.method + "参数为------" + call.arguments.toString());

      switch (call.method) {
        case "setupSuccess":
          break;
        case "nativeAdLoadSuccess":
          {
            double realHeght = call.arguments["height"];
            convertDPToPixels(realHeght);
            // 高度转换
            // convertAndroidDpToFlutterDp(realHeght);
            // 同步高度给flutter内容Container,并且刷新页面

          }
          
          break;
        default:
          break;
      }
    });
  }

  static double convertDPToPixels(double dp) {
    final double screenDensity = MediaQuery.of(context1!).devicePixelRatio;
    print("高度为：");
    return dp * screenDensity;
  }



  /// sdk初始化方法
  static Future<String?> adSdkSetup() async {
    final String? version =
        await _channel.invokeMethod('cjSdkSetup', {"configId": testAdvertModel.getConfigId()});
    return version;
  }

  /// 开屏
  static Future<String> getSplashAdMethod() async {
    // ignore: avoid_print
    final String state = await _channel
        .invokeMethod('cjLoadAndShowSplashMethod', {"advertId": testAdvertModel.getSplashId()});

    return state;
  }

  /// 激励视频
  static Future<Map> getRewardVideoMethod() async {
    // ignore: avoid_print
    final Map result = await _channel.invokeMethod('cjLoadAndShowRewardVideoMethod',
        {"advertId": testAdvertModel.getRewardVideoId(), "userId": "用户userId，必传"});
    // ignore: avoid_print

    return result;
  }

    static Future<Map> preLoadReward() async {
    // ignore: avoid_print
    final Map result = await _channel.invokeMethod('preReward', {"advertId": testAdvertModel.getRewardVideoId()});
    // ignore: avoid_print
    return result;
  }

  /// 全屏视频
  static Future<int> getFullscreenVideoMethod() async {
    final int result = await _channel.invokeMethod(
        'cjLoadAndShowFullscreenVideoAdMethod', {"advertId": testAdvertModel.getFullscreenVideoId()});
    return result;
  }

  /// 插屏
  static Future<int> getInterstitialAdMethod() async {
    final int result = await _channel
        .invokeMethod('cjLoadAndShowInterstitialAdMethod', {"advertId": testAdvertModel.getInterstitialId()});
    /// 接收一个数组或者字典作为参数传递给原生端
    return result;
  }

    /// 信息流
  static Future<int> getNativeAdMethod() async {        
    final int result = await _channel
        .invokeMethod('cjLoadAndShowNativeAdMethod', {"advertId": testAdvertModel.getNativeId()});
    /// 接收一个数组或者字典作为参数传递给原生端
    return result;
  }

  static Future<int> getBannerMethod() async {        
    final int result = await _channel
        .invokeMethod('cjLoadAndShowBannerAdMethod', {"advertId": testAdvertModel.getBannerId()});
    /// 接收一个数组或者字典作为参数传递给原生端
    return result;
  }
  

  /// 短视频
  static Future<int> getShortVideoAdMethod() async {
    final int result = await _channel
        .invokeMethod('getShortVideoAdMethod', {"advertId": testAdvertModel.getShortVideoId()});
    /// 接收一个数组或者字典作为参数传递给原生端
    return result;
  }



}
  