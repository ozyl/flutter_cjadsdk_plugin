package com.example.flutter_cjadsdk_plugin

import android.app.ActionBar.LayoutParams
import android.app.Activity
import android.app.Application
import android.content.Context
import android.content.Context.WINDOW_SERVICE
import android.content.Intent
import android.graphics.Color
import android.graphics.Point
import android.os.Build
import android.util.DisplayMetrics
import android.util.Log
import android.view.Gravity
import android.view.View
import android.view.ViewGroup
import android.view.WindowManager
import android.widget.FrameLayout
import android.widget.ImageView
import android.widget.RelativeLayout
import androidx.annotation.NonNull
import androidx.core.content.ContextCompat.getSystemService
import cj.mobile.CJBanner
import cj.mobile.CJFullScreenVideo
import cj.mobile.CJInterstitial
import cj.mobile.CJMobileAd
import cj.mobile.CJNativeExpress
import cj.mobile.CJRewardVideo
import cj.mobile.CJSplash
import cj.mobile.listener.CJBannerListener
import cj.mobile.listener.CJFullListener
import cj.mobile.listener.CJInitListener
import cj.mobile.listener.CJInterstitialListener
import cj.mobile.listener.CJNativeExpressListener
import cj.mobile.listener.CJRewardListener
import cj.mobile.listener.CJSplashListener
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.lang.reflect.InvocationTargetException


// 提供给flutter的方法
const val preReward = "preReward"  // 激励视频预加载（android支持）
const val setupFuncName           = "cjSdkSetup" // 广告sdk初始化
const val splashFuncName          = "cjLoadAndShowSplashMethod" // 加载并且显示开屏
const val rewardVideoFuncName     = "cjLoadAndShowRewardVideoMethod" // 加载并显示激励视频
const val fullscreenVideoFuncName = "cjLoadAndShowFullscreenVideoAdMethod" // 加载并且显示全屏视频
const val interstitialFuncName    = "cjLoadAndShowInterstitialAdMethod" // 加载并且显示插屏
const val nativeFuncName          = "cjLoadAndShowNativeAdMethod" // 加载信息流
const val bannerFuncName          = "cjLoadAndShowBannerAdMethod" // 加载Banner
const val shortVideoFuncName      = "cjShowShortVideoAdMethod" // 加载并显示短视频（短视频需要特别引入arr）

// 初始化相关回调
const val setupSuccess = "setupSuccess" // 初始化成功
const val setupFailed  = "setupFailed"   // 初始化失败

// 开屏广告位回调
const val splashAdLoadSuccess = "splashAdLoadSuccess"  // 加载成功
const val splashAdLoadFailed  = "splashAdLoadFailed"   // 加载失败
const val splashAdOnShow      = "splashAdOnShow"       // 已经显示
const val splashAdOnClick     = "splashAdOnClick"      // 点击事件
const val splashAdOnClose     = "splashAdOnClose"      // 关闭事件

// 激励视频相关回调
const val rewardVideoAdBeRewarded  = "rewardVideoAdBeRewarded"   // 达成奖励
const val rewardVideoAdLoadSuccess = "rewardVideoAdLoadSuccess"  // 加载成功
const val rewardVideoAdLoadFailed  = "rewardVideoAdLoadFailed"   // 加载失败
const val rewardVideoAdOnShow      = "rewardVideoAdOnShow"       // 已经显示
const val rewardVideoAdOnClick     = "rewardVideoAdOnClick"      // 点击事件
const val rewardVideoAdOnClose     = "rewardVideoAdOnClose"      // 关闭事件

// 插屏视频相关回调
const val interstitialAdLoadSuccess = "interstitialAdLoadSuccess"   // 加载成功
const val interstitialAdLoadFailed  = "interstitialAdLoadFailed"    // 加载失败
const val interstitialAdOnShow      = "interstitialAdOnShow"        // 已经显示
const val interstitialAdOnClick     = "interstitialAdOnClick"       // 点击事件
const val interstitialAdOnClose     = "interstitialAdOnClose"       // 关闭事件

// 全屏视频相关回调
const val fullscreenVideoAdLoadSuccess = "fullscreenVideoAdLoadSuccess"   // 加载成功
const val fullscreenVideoAdLoadFailed  = "fullscreenVideoAdLoadFailed"    // 加载失败
const val fullscreenVideoAdOnShow      = "fullscreenVideoAdOnShow"        // 已经显示
const val fullscreenVideoAdOnClick     = "fullscreenVideoAdOnClick"       // 点击事件
const val fullscreenVideoAdOnClose     = "fullscreenVideoAdOnClose"       // 关闭事件

// 信息流相关回调
const val nativeAdLoadSuccess = "nativeAdLoadSuccess"   // 加载成功
const val nativeAdLoadFailed  = "nativeAdLoadFailed"    // 加载失败
const val nativeAdOnShow      = "nativeAdOnShow"        // 已经显示
const val nativeAdOnClick     = "nativeAdOnClick"       // 点击事件
const val nativeAdOnClose     = "nativeAdOnClose"       // 关闭事件

// banner相关回调
const val bannerAdLoadSuccess = "bannerAdLoadSuccess"   // 加载成功
const val bannerAdLoadFailed  = "bannerAdLoadFailed"    // 加载失败
const val bannerAdOnShow      = "bannerAdOnShow"        // 已经显示
const val bannerAdOnClick     = "bannerAdOnClick"       // 点击事件
const val bannerAdOnClose     = "bannerAdOnClose"       // 关闭事件

/** FlutterCjadsdkPlugin */
class FlutterCjadsdkPlugin: FlutterPlugin, MethodCallHandler {

  private lateinit var splashContentView: FrameLayout
  private lateinit var contentView: FrameLayout
  private lateinit var logoView: ImageView
  private lateinit var containerView: RelativeLayout
  private lateinit var channel : MethodChannel
  private lateinit var splashAd: CJSplash
  private lateinit var fullscreenVideoAd: CJFullScreenVideo
  private lateinit var interstitial: CJInterstitial
  private lateinit var nativeAd: CJNativeExpress
  private lateinit var bannerAd: CJBanner

  private var width: Int = 0
  private var height: Int = 0
  private var isPro: Boolean = false


  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {

    val messenger: BinaryMessenger = flutterPluginBinding.binaryMessenger
    channel = MethodChannel(messenger, "flutter_cjadsdk_plugin")
    channel.setMethodCallHandler(this)
    flutterPluginBinding.platformViewRegistry.registerViewFactory("flutter_cjadsdk_plugin/native_contentView", NativeViewFactory(messenger))
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    MainScope().launch {
      withContext(Dispatchers.Main) {
        var advertId = call.argument<String>("advertId")
        var configId = call.argument<String>("configId")
        var userId = call.argument<String>("userId")
        when(call.method) {
          in preReward -> {
            var activity = getCurrentActivity()
            //预加载激励视频
            CJRewardVideo.getInstance()
              .setMainActivity(activity)
              .loadAd(advertId)
          }
          in setupFuncName -> {
            CJMobileAd.emulatorShowAd(false)
            val application: Application? = AppGlobalUtils().application;
            CJMobileAd.privacyCompliance(application,true)
            //防止上架后台读取应用后台（vivo）
            CJMobileAd.isCanUseAppList(false)
            CJMobileAd.init(application, configId, object : CJInitListener {
              override fun initFailed(errorMsg: String) {
                channel.invokeMethod(setupFailed, errorMsg)
              }
              override fun initSuccess() {
                channel.invokeMethod(setupSuccess, "初始化成功")
              }
            })
          }
          in splashFuncName -> {
            splashAd = CJSplash()
            var activity = getCurrentActivity()
            if (activity != null) {
              var windowManager = activity.getSystemService(Context.WINDOW_SERVICE) as? WindowManager
              val displayMetrics = DisplayMetrics()
              if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
                windowManager!!.defaultDisplay.getRealMetrics(displayMetrics)
              } else {
                windowManager!!.defaultDisplay.getMetrics(displayMetrics) // 对于低于 API 21 的版本，使用 getMetrics()
              }
              width = displayMetrics.widthPixels
              height = displayMetrics.heightPixels
              val density = displayMetrics.density
//              Log.e("ly_ad_h", height.toString())
//              Log.e("ly_ad_w", width.toString())

              contentView = FrameLayout(activity)
              contentView.setBackgroundColor(Color.WHITE)
              splashContentView = FrameLayout(activity)
              logoView = ImageView(activity)
              containerView = RelativeLayout(activity)
              contentView.addView(splashContentView)
              contentView.addView(containerView)

              // 进行布局
              var containerHeight = (height * 0.175).toInt();
              var splashHeight = height - containerHeight
              val contentParams = FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                FrameLayout.LayoutParams.MATCH_PARENT,
              )
              val imageLayoutParams = RelativeLayout.LayoutParams( RelativeLayout.LayoutParams.WRAP_CONTENT, RelativeLayout.LayoutParams.WRAP_CONTENT )
              val containerLayoutParams = FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                containerHeight
              )
              val splashContentParams = FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                splashHeight
              )
              imageLayoutParams.addRule(RelativeLayout.CENTER_IN_PARENT, RelativeLayout.TRUE)
              containerLayoutParams.gravity = Gravity.BOTTOM
              contentView.layoutParams = contentParams
              containerView.layoutParams = containerLayoutParams
              splashContentView.layoutParams = splashContentParams
              logoView.layoutParams = imageLayoutParams
              containerView.setBackgroundColor(Color.WHITE)
              // 这里设置logo图片
//              logoView.setImageResource(R.mipmap.logo)
              containerView.addView(logoView)
              splashAd.loadAd(activity, advertId, width, splashHeight, object : CJSplashListener {
                override fun onShow() {
                  channel.invokeMethod(splashAdOnShow, "开屏已经显示")
                }

                override fun onError(s: String, s1: String) {
                  val map: MutableMap<String, Any> = HashMap()
                  map["code"] = s
                  map["message"] = s1
                  channel.invokeMethod(splashAdLoadFailed, map)
                }

                override fun onLoad() {
                  channel.invokeMethod(splashAdLoadSuccess, "开屏加载成功")
                  (activity?.window?.decorView as ViewGroup?)!!.removeView(contentView)
                  (activity?.window?.decorView as? ViewGroup)!!.addView(contentView)
                  splashAd.showAd(activity ,splashContentView)
                }

                override fun onClick() {
                  channel.invokeMethod(splashAdOnClick, "点击开屏")
                }

                override fun onClose() {
                  (activity?.window?.decorView as ViewGroup?)!!.removeView(contentView)
                  channel.invokeMethod(splashAdOnClose, "关闭开屏")
                }
              })
            } else {
              val map: MutableMap<String, Any> = HashMap()
              map["code"] = "-1001"
              map["message"] = "activitu意外为nil"
              channel.invokeMethod(splashAdLoadFailed, map)
            }
          }

          in rewardVideoFuncName -> {
            var activity = getCurrentActivity()
            //预加载激励视频
            CJRewardVideo.getInstance()
              .setMainActivity(activity)//传入上下文activity（需要activity是长期存活的，所以最好传入主页面的activity
            CJRewardVideo.getInstance().setUserId(userId)
            CJRewardVideo.getInstance().setListener(object : CJRewardListener {
              override fun onShow() {
                channel.invokeMethod(rewardVideoAdOnShow, "激励视频已经显示")
              }

              override fun onError(s: String, s1: String) {
                val map: MutableMap<String, Any> = HashMap()
                map["code"] = s
                map["message"] = s1
                channel.invokeMethod(rewardVideoAdLoadFailed, map)
              }

              override fun onClick() {
                channel.invokeMethod(rewardVideoAdOnClick, "点击激励视频")
              }

              override fun onClose() {
                channel.invokeMethod(rewardVideoAdOnClose, "关闭激励视频")
              }

              override fun onVideoEnd() {
              }

              override fun onLoad() {
                if (!isPro){
                  isPro=true
                  channel.invokeMethod(rewardVideoAdLoadSuccess, "激励视频加载成功")
                  CJRewardVideo.getInstance().showAd(activity)
                }
              }

              override fun onVideoStart() {

              }
              override fun onReward(s: String) {
                val map: MutableMap<String, Any> = java.util.HashMap()
                map["requestId"] = s
                map["message"] = "激励视频达成奖励"
                channel.invokeMethod(rewardVideoAdBeRewarded, map)
              }
            })
            if (CJRewardVideo.getInstance().isValid()) {
              isPro=true;
              CJRewardVideo.getInstance().showAd(activity)
            } else if (CJRewardVideo.getInstance().isLoading()) {
              isPro=false;
            } else {
              isPro=false;
              CJRewardVideo.getInstance().loadAd(advertId);
            }
          }
          in fullscreenVideoFuncName -> {
            var activity = getCurrentActivity()
            fullscreenVideoAd = CJFullScreenVideo()
            fullscreenVideoAd.loadAd(activity, advertId, object : CJFullListener {
              override fun onShow() {
                channel.invokeMethod(fullscreenVideoAdOnShow, "全屏视频已经显示")
              }

              override fun onError(p0: String?, p1: String?) {
                val map: MutableMap<String, Any> = HashMap()
                map["code"] = p0 as String
                map["message"] = p1 as String
                channel.invokeMethod(fullscreenVideoAdLoadFailed, map)
              }

              override fun onClick() {
                channel.invokeMethod(fullscreenVideoAdOnClick, "点击全屏视频")
              }

              override fun onClose() {
                channel.invokeMethod(fullscreenVideoAdOnClose, "关闭全屏视频")
              }

              override fun onVideoEnd() {
              }

              override fun onLoad() {
                channel.invokeMethod(fullscreenVideoAdLoadSuccess, "全屏视频加载成功")
                fullscreenVideoAd.showAd(activity)
              }

              override fun onVideoStart() {
              }
            })
          }
          in interstitialFuncName -> {
            // 加载插屏
            interstitial = CJInterstitial()
            var activity = getCurrentActivity()
            interstitial.loadAd(activity, advertId, object : CJInterstitialListener {
              override fun onShow() {
                channel.invokeMethod(interstitialAdOnShow, "插屏已经显示")
              }

              override fun onError(s: String, s1: String) {
                val map: MutableMap<String, Any> = java.util.HashMap()
                map["code"] = s
                map["message"] = s1
                channel.invokeMethod(interstitialAdLoadFailed, map)
              }

              override fun onLoad() {
                channel.invokeMethod(interstitialAdLoadSuccess, "插屏加载成功")
                interstitial.showAd(activity)
              }

              override fun onClick() {
                channel.invokeMethod(interstitialAdOnClick, "点击插屏")
              }

              override fun onClose() {
                channel.invokeMethod(interstitialAdOnClose, "关闭插屏")
              }
            })
          }
          in nativeFuncName-> {
            var activity = getCurrentActivity()
            nativeAd = CJNativeExpress()
            nativeAd.loadAd(activity, activity!!.window.decorView.width, 0, advertId, object : CJNativeExpressListener {
              override fun onShow(p0: View?) {
                val map: MutableMap<String, Any> = HashMap()
                map["height"] = (p0 as View).height
                Log.e("ly_ad", (p0 as View).height.toString());
                channel.invokeMethod(nativeAdLoadSuccess, map)
                channel.invokeMethod(nativeAdOnShow, "信息流已经显示")
              }

              override fun onError(p0: String?, p1: String?) {
                val map: MutableMap<String, Any> = java.util.HashMap()
                map["code"] = p0 as String
                map["message"] = p1 as String
                channel.invokeMethod(nativeAdLoadFailed, map)
              }

              override fun onClick(p0: View?) {
                channel.invokeMethod(nativeAdOnClick, "点击信息流")
              }

              override fun onClose(p0: View?) {
                channel.invokeMethod(nativeAdOnClose, "关闭信息流")
              }

              override fun loadSuccess(p0: View?) {
                var nativeTempView = p0 as View
                if (componentNativeContent != null) {
                  componentNativeContent?.layoutParams?.height = LayoutParams.WRAP_CONTENT
                  (componentNativeContent?.parent as? ViewGroup)?.layoutParams?.height = LayoutParams.WRAP_CONTENT
                  componentNativeContent?.addView(nativeTempView)
                }
              }
            })
          }
          in bannerFuncName-> {
            var activity = getCurrentActivity()
            bannerAd = CJBanner()
            bannerAd.loadAd(activity, advertId, activity!!.window.decorView.width, (activity!!.window.decorView.width/2).toInt(), object: CJBannerListener{
              override fun onShow() {
                channel.invokeMethod(bannerAdOnShow, "banner已经显示")
              }

              override fun onError(p0: String?, p1: String?) {
                val map: MutableMap<String, Any> = java.util.HashMap()
                map["code"] = p0 as String
                map["message"] = p1 as String
                channel.invokeMethod(bannerAdLoadFailed, map)
              }

              override fun onLoad() {
                if (componentBanner != null) {
                  bannerAd.showAd(componentBanner)
                  channel.invokeMethod(bannerAdLoadSuccess, "加载成功")
                }
              }

              override fun onClick() {
                channel.invokeMethod(bannerAdOnClick, "点击banner")
              }

              override fun onClose() {
                channel.invokeMethod(bannerAdOnClose, "关闭banner")
              }

            })
          }

          in shortVideoFuncName-> {
            var context = AppGlobalUtils().application?.applicationContext
            var intent = Intent(context, ShortVideoActivity::class.java)
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            intent.putExtra("advertId", advertId)
            context?.startActivity(intent)
          }
          else -> {
            Log.e("100000","暂不支持")
            channel.invokeMethod("unkonw-support", "暂不支持")
//        result.notImplemented()
          }
        }
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  fun dip2px(context: Context, dpValue: Float): Int {
    val scale = context.resources.displayMetrics.density
    return (dpValue * scale + 0.5f).toInt()
  }

  fun getCurrentActivity(): Activity? {
    try {
      val activityThreadClass = Class.forName("android.app.ActivityThread")
      val activityThread = activityThreadClass.getMethod("currentActivityThread").invoke(
        null
      )
      val activitiesField = activityThreadClass.getDeclaredField("mActivities")
      activitiesField.isAccessible = true
      val activities = activitiesField[activityThread] as Map<*, *>
      for (activityRecord in activities.values) {
        val activityRecordClass: Class<*> = activityRecord?.javaClass!!
        val pausedField = activityRecordClass.getDeclaredField("paused")
        pausedField.isAccessible = true
        if (!pausedField.getBoolean(activityRecord)) {
          val activityField =
            activityRecordClass.getDeclaredField("activity")
          activityField.isAccessible = true
          return activityField[activityRecord] as Activity
        }
      }
    } catch (e: ClassNotFoundException) {
      e.printStackTrace()
    } catch (e: InvocationTargetException) {
      e.printStackTrace()
    } catch (e: NoSuchMethodException) {
      e.printStackTrace()
    } catch (e: NoSuchFieldException) {
      e.printStackTrace()
    } catch (e: IllegalAccessException) {
      e.printStackTrace()
    }
    return null
  }



  class AppGlobalUtils {
    private var myApp: Application? = null
    val application: Application?
    get() {
      if (myApp == null) {
        try {
          val currentApplication =
            Class.forName("android.app.ActivityThread").getDeclaredMethod("currentApplication")
            myApp = currentApplication.invoke(null) as Application
        } catch (e: Exception) {
          e.printStackTrace()
        }
      }
      return myApp
    }
  }
}
