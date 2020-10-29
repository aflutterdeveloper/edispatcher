package com.wairead.stoner

import android.app.Activity
import android.app.Application
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.WindowManager
import androidx.core.view.OnApplyWindowInsetsListener
import androidx.core.view.ViewCompat
import com.wairead.stoner.stonerlocalplugin.StonerLocalPlugin
import com.appsflyer.AppsFlyerLib
import com.wairead.stoner.helpers.FacebookHelper
import com.wairead.stoner.helpers.FcmHelper
import com.wairead.stoner.helpers.HeightProvider
import com.wairead.stoner.helpers.UriParser
import io.flutter.app.FlutterApplication
import tv.athena.platform.components.AeFragmentActivity

class MainActivity : AeFragmentActivity() {
    private val tag = "MainActivity"
    private var heightProvider: HeightProvider? = null
    private var activityCallback:ActivityCallbackImpl? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        // 让Appsflyer去拿Facebook的AppLink
        AppsFlyerLib.getInstance().enableFacebookDeferredApplinks(true)

        super.onCreate(savedInstanceState)
        activityCallback = ActivityCallbackImpl(this)
        this.application.registerActivityLifecycleCallbacks(activityCallback)

        checkNotch()
        makeViewEnterFullScreen()

        heightProvider = HeightProvider(this).init().setHeightListener { height ->
            (flutterEngine?.plugins?.get(StonerLocalPlugin::class.java) as? StonerLocalPlugin)
                    ?.handleKeyboardShown(height)
        }

        setPlugins()
        FacebookHelper.initAppLinks(applicationContext)
        handleLaunchIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        Log.i(tag, "On new intent = $intent")
        handleLaunchIntent(intent)
    }

    private fun setPlugins() {
        val localPlugin = flutterEngine?.plugins?.get(StonerLocalPlugin::class.java)
        if (localPlugin is StonerLocalPlugin) {
            UriParser.plugin = localPlugin
        }
    }

    private fun checkNotch() {
        ViewCompat.setOnApplyWindowInsetsListener(window.decorView, OnApplyWindowInsetsListener { v, insets ->
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                if (v.rootWindowInsets?.displayCutout?.boundingRects?.isNotEmpty() == true) {
                    window.attributes = window.attributes.apply {
                        layoutInDisplayCutoutMode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R)
                            WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_ALWAYS
                        else
                            WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_SHORT_EDGES
                    }
                    StonerLocalPlugin.hasNotch = true
                }
            }

            if (StonerLocalPlugin.isNavigationBarShown == null && insets != null) {
                val bottom = insets.systemWindowInsetBottom
                StonerLocalPlugin.isNavigationBarShown = bottom > 0
            }

            ViewCompat.setOnApplyWindowInsetsListener(window.decorView, null)
            return@OnApplyWindowInsetsListener ViewCompat.onApplyWindowInsets(v, insets)
        })
    }

    private fun makeViewEnterFullScreen() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            window.setDecorFitsSystemWindows(false)
        } else {
            window.setFlags(WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS,
                    WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS)
        }
    }

    private fun handleLaunchIntent(intent: Intent) {
        Log.i(tag, "start intent = $intent")
        if (!UriParser.handleAppLinkUri(intent.data)) {
            FcmHelper.handleIntent(applicationContext, intent)
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        if (null != activityCallback) {
            this.application.unregisterActivityLifecycleCallbacks(activityCallback)
        }

        heightProvider?.dismiss()
    }
}

class ActivityCallbackImpl(activity: Activity) : Application.ActivityLifecycleCallbacks {
    init {
        (activity.application as? FlutterApplication)?.currentActivity = activity
    }

    override fun onActivityPaused(p0: Activity) {
    }

    override fun onActivityStarted(p0: Activity) {
        (p0.application as? FlutterApplication)?.currentActivity = p0
    }

    override fun onActivityDestroyed(p0: Activity) {
    }

    override fun onActivitySaveInstanceState(p0: Activity, p1: Bundle) {
    }

    override fun onActivityStopped(p0: Activity) {
    }

    override fun onActivityCreated(p0: Activity, p1: Bundle?) {
    }

    override fun onActivityResumed(p0: Activity) {
    }
}
