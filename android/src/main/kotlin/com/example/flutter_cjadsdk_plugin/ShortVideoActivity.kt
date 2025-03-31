package com.example.flutter_cjadsdk_plugin

import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import cj.mobile.CJVideoContent
import cj.mobile.listener.CJVideoContentListener


class ShortVideoActivity: AppCompatActivity() {

    private var activity: AppCompatActivity? = null
    private var fragmentContent: Fragment? = null
    private val videoContent = CJVideoContent()
    public var advertId: String = ""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_video_content)
        advertId= intent.getStringExtra("advertId").toString()
        activity = this
        loadVideoContent()
    }

    public fun closeEvent(btn: View) {
        this.finish()
    }

    private fun loadVideoContent() {
//        videoContent.loadVideoContent(
//            activity,
//            advertId,
//            object : CJVideoContentListener {
//                override fun onLoad(fragment: Fragment) {
//                    Toast.makeText(activity, "加载成功", Toast.LENGTH_SHORT).show()
//                    fragmentContent = fragment
//                    supportFragmentManager.beginTransaction()
//                        .replace(R.id.fl_content, fragmentContent!!)
//                        .commitAllowingStateLoss()
//                }
//
//                override fun onError(code: String, e: String) {
//                    Log.e("1111", "加载失败"+e)
//                }
//                override fun startVideo(item: ContentItem) {}
//                override fun pauseVideo(item: ContentItem) {}
//                override fun resumeVideo(item: ContentItem) {}
//                override fun endVideo(item: ContentItem) {}
//            })
    }


}