import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_cjadsdk_plugin/flutter_cjadsdk_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
    FlutterCjadsdkPlugin.init(context);

  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (!mounted) return;
  }

  // android dp高度单位转换成flutter高度
  double convertAndroidDpToFlutterDp(double androidDp) {
    //MediaQueryData包含有关当前环境的屏幕大小和方向的信息
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    // 将Android的dp转换为逻辑像素(dp)
    double flutterDp = androidDp * mediaQueryData.devicePixelRatio;
    return flutterDp;
}

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('P1lugin xxxexample appxxxxxx'),
        ),
        body: const MyStatelessWidget(),
      ),
    );
  }
}

class MyStatelessWidget extends StatelessWidget {
  const MyStatelessWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void setupSDK() {
      print("初始化");
      FlutterCjadsdkPlugin.adSdkSetup();
    }

    void loadSplashAd() {
      print("加载开屏");
      FlutterCjadsdkPlugin.getSplashAdMethod();
    }

    void loadRewardVideoAd() {
      FlutterCjadsdkPlugin.getRewardVideoMethod();
      // ignore: avoid_print
    }

    void preLoadRewardVideoAd() {
      print("激励视频预加载");
      FlutterCjadsdkPlugin.preLoadReward();
    }

    void loadFullscreenVideoAd() {
      print("全屏视频");
      FlutterCjadsdkPlugin.getFullscreenVideoMethod();
    }

    void loadInterstitialAd() {
      FlutterCjadsdkPlugin.getInterstitialAdMethod();
    }

    void loadNativeAd() {
      FlutterCjadsdkPlugin.getNativeAdMethod();
    }

    void loadBannerAd() {
      FlutterCjadsdkPlugin.getBannerMethod();
    }

    void loadShortVideoAd() {
      FlutterCjadsdkPlugin.getShortVideoAdMethod();
    }

    Widget getBannerView(){
        var view = Container(
        height: 240,
        child: Platform.isIOS ? UiKitView(viewType: 'flutter_cjadsdk_plugin/native_contentView') : AndroidView(viewType: 'flutter_cjadsdk_plugin/native_contentView')
      );   
      return view;
    }

    Widget getNativeView(){
      var view = Container(
        height: 297,
        color: Color.fromRGBO(222, 111, 0, 1),
        child: Platform.isIOS ? UiKitView(viewType: 'flutter_cjadsdk_plugin/native_contentView') : AndroidView(viewType: 'flutter_cjadsdk_plugin/native_contentView')
      );   
      return view;
    }

    return Center(
      child: ListView(
       
        children: [
          TextButton(
            onPressed: () {
              setupSDK();
            },
            child: const Text('初始化SDK'),
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
          TextButton(
            onPressed: () {
              loadSplashAd();
            },
            child: const Text('开屏'),
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
          TextButton(
            onPressed: () {
              preLoadRewardVideoAd();
            },
            child: const Text('预加载激励视频'),
            style: TextButton.styleFrom(
            textStyle: const TextStyle(fontSize: 16),
            ),
          ),
          TextButton(
            onPressed: () {
              loadRewardVideoAd();
            },
            child: const Text('激励视频'),
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
          TextButton(
            onPressed: () {
              loadFullscreenVideoAd();
            },
            child: const Text('全屏视频'),
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
          TextButton(
            onPressed: () {
              loadInterstitialAd();
            },
            child: const Text('插屏'),
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
             TextButton(
            onPressed: () {
              loadNativeAd();
            },
            child: const Text('信息流'),
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
          TextButton(
            onPressed: () {
              loadBannerAd();
            },
            child: const Text('Banner'),
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
          Expanded(child: getNativeView()),
          // Expanded(child: getBannerView())
          // Container(child: getNativeView())
          // getNativeView()
        ],
      ),
    );
  }
}
