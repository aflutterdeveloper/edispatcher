package com.wairead.stoner.helpers

import android.net.Uri
import android.os.Handler
import android.os.Looper
import com.wairead.stoner.stonerlocalplugin.StonerLocalPlugin

/**
 * Created by Kin on 2020/8/7
 */

object UriParser {
    var plugin: StonerLocalPlugin? = null
    
    fun handleAppLinkUri(uri: Uri?): Boolean {
        if (uri?.scheme == "waireadstoner") {
            // 保证从UI线程调用Plugin的方法
            Handler(Looper.getMainLooper()).post {
                plugin?.handleAppsflyerIntent(uri)
            }
            return true
        }

        return false
    }
}