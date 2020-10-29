package com.wairead.stoner

import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import androidx.core.app.NotificationManagerCompat
import com.wairead.stoner.stonerlocalplugin.StonerLocalPlugin
import com.wairead.stoner.stonerlocalplugin.getColorCompat
import com.yy.pushsvc.YYPush
import io.flutter.app.FlutterApplication

/**
 * Created by Kin on 2020/5/12
 */
class StonerApplication : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()

        initPushChannel()
        initPush()
    }

    private fun initPush() {
        YYPush.getInstace().apply {
            setLogDir("${cacheDir.path}/push_log")
            setFetchOutlineMsgEnable(true)
            setYunlogOpen(true)
            setAccountSyncPeriod(900)
            initNotificationImg(R.mipmap.ic_launcher, R.mipmap.ic_notification)
            initNotificationColor(getColorCompat(R.color.stoner_notification_color))
        }
//        FlutterPush.getInstace().init(this, null, null, BuildConfig.VERSION_NAME)
    }

    private fun initPushChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(getString(R.string.default_push_channel_id), getString(R.string.default_push_channel_name), NotificationManager.IMPORTANCE_HIGH)
            NotificationManagerCompat.from(this).createNotificationChannel(channel)
        }
    }
}