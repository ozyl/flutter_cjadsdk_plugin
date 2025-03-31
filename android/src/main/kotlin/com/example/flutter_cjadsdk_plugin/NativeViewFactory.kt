package com.example.flutter_cjadsdk_plugin
import android.content.Context
import android.view.View
import android.widget.FrameLayout.LayoutParams
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory



class NativeViewFactory(private val messenger: BinaryMessenger) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        var nativeView = NativeContentView(context, messenger, viewId, args as Map<String, Any>?)
        componentNativeContent = nativeView.view
        componentBanner = nativeView.view
        return nativeView
    }

}
