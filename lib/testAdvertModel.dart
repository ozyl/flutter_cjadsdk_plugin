import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';

///____________________iOS测试广告位ID____________________
/// 媒体测试ID
const String ios_configId = "2192b5b29d24b12b";

/// 开屏测试广告位ID
const String ios_splashId = "8a4965ae2b5f4ce6";

/// 激励视频测试广告位ID
const String ios_rewardVideoId = "dee3663658a69082";

/// 全屏视频测试广告位ID
const String ios_fullscreenVideoId = "cd2aa9c2dd467fe0";

/// 插屏测试广告位ID
const String ios_interstitialId = "13793fe3aaa5a632";

const String ios_nativeId = "25b03bd651edf47b";

const String ios_bannerId = "017fad6fe3160b9f";

const String ios_shortVideoId = "be537b85a50e9954";

///____________________安卓测试广告位ID____________________
/// 媒体测试ID
const String android_configId = "345a20d3863f8911";

/// 开屏测试广告位ID
const String android_splashId = "f531cf0880e84a92";

/// 激励视频测试广告位ID
const String android_rewardVideoId = "61bf850b1c1463a8";

/// 全屏视频测试广告位ID
const String android_fullscreenVideoId = "d1e828bceca7f32a";

/// 插屏测试广告位ID
const String android_interstitialId = "fd666428f0326ff4";

const String android_nativeId = "f0cfee409b1e1e3a";

const String android_bannerId = "a495d657f01c41bd";

const String android_shortVideoId = "738ceaa888e5cf9c";

class testAdvertModel {

  static init() {

  }

  // 获取媒体ID
  static String getConfigId(){
    return Platform.isIOS ? ios_configId : android_configId;
  }

  // 获取开屏ID
  static String getSplashId(){
    return Platform.isIOS ? ios_splashId : android_splashId;
  }

  // 获取激励视频ID
  static String getRewardVideoId(){
    return Platform.isIOS ? ios_rewardVideoId : android_rewardVideoId;
  }
  
  // 获取插屏ID
  static String getInterstitialId(){
    return Platform.isIOS ? ios_interstitialId : android_interstitialId;
  }

  // 获取信息流ID
  static String getNativeId(){
    return Platform.isIOS ? ios_nativeId : android_nativeId;
  }
  // 获取bannerID
  static String getBannerId(){
    return Platform.isIOS ? ios_bannerId : android_bannerId;
  }

  // 获取短视频ID
  static String getShortVideoId(){
    return Platform.isIOS ? ios_shortVideoId : android_shortVideoId;
  }

  // 获取全屏视频ID
  static String getFullscreenVideoId(){
    return Platform.isIOS ? ios_fullscreenVideoId : android_fullscreenVideoId;
  }
}