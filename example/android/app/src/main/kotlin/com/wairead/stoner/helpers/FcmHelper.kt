package com.wairead.stoner.helpers

import android.content.Context
import android.content.Intent
import android.util.Log
import com.yy.flutter_push.FlutterPush
import com.yy.pushsvc.YYPush
import com.yy.pushsvc.thirdparty.ThirdPartyPushType

object FcmHelper {
    private const val TAG = "FcmHelper"

    fun handleIntent(context: Context, intent: Intent?) {
        parseAndReport(context, intent)
        intent?.extras?.let {
            val payload = it.getString("payload")
            Log.i(TAG, "Handle FCM payload: $payload")
            FlutterPush.getInstace().handleClick(payload)
        }
    }

    private fun parseAndReport(context: Context, intent: Intent?) {
        var msgId = 0L
        var pushId = 0L
        if (intent?.hasExtra("msgid") == true) {
            msgId = intent.getStringExtra("msgid")?.toLong() ?: 0
        }
        if (intent?.hasExtra("pushid") == true) {
            pushId = intent.getStringExtra("pushid")?.toLong() ?: 0
        }
        YYPush.getInstace().uploadNotificationShowEvtToHiido(
                context, 
                ThirdPartyPushType.PUSH_TYPE_FCM,
                msgId,
                pushId,
                true)
        YYPush.getInstace().uploadClickEvtToHiido(context,
                ThirdPartyPushType.PUSH_TYPE_FCM,
                msgId,
                pushId)
    }
}