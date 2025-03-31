package com.example.flutter_cjadsdk_plugin
import android.content.Context
import android.graphics.Color
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformView


class NativeContentView(context: Context, messenger: BinaryMessenger, viewId: Int, args: Map<String, Any>?) :
    PlatformView {

    private val contentView: FrameLayout = FrameLayout(context)
    init {

    }

    override fun getView(): FrameLayout {
        return contentView
    }
    override fun dispose() {
    }

}


//var params = contentView.layoutParams
//contentView.layoutParams = params
//contentView.setBackgroundColor(Color.RED)