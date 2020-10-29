package com.wairead.stoner.helpers

import android.content.Context
import android.util.Log
import com.facebook.applinks.AppLinkData

object FacebookHelper {
    fun initAppLinks(context: Context) {
        AppLinkData.fetchDeferredAppLinkData(context) { appLinkData ->
            Log.i("FacebookHelper", "Receive applink: ${appLinkData?.targetUri}")
            if (appLinkData != null) {
                UriParser.handleAppLinkUri(appLinkData.targetUri)
            }
        }
    }
}