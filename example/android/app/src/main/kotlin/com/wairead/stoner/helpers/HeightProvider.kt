package com.wairead.stoner.helpers

import android.app.Activity
import android.graphics.Rect
import android.graphics.drawable.ColorDrawable
import android.view.*
import android.widget.PopupWindow

class HeightProvider(private val mActivity: Activity) : PopupWindow(mActivity), ViewTreeObserver.OnGlobalLayoutListener {
    private val rootView: View = View(mActivity)
    private var listener: ((height: Int) -> Unit)? = null
    private var heightMax // 记录popup内容区的最大高度
            = 0

    fun init(): HeightProvider {
        if (!isShowing) {
            val view = mActivity.window.decorView
            // 延迟加载popupwindow，如果不加延迟就会报错
            view.post { showAtLocation(view, Gravity.NO_GRAVITY, 0, 0) }
        }
        return this
    }

    fun setHeightListener(listener: (height: Int) -> Unit): HeightProvider {
        this.listener = listener
        return this
    }

    override fun onGlobalLayout() {
        val rect = Rect()
        rootView.getWindowVisibleDisplayFrame(rect)
        if (rect.bottom > heightMax) {
            heightMax = rect.bottom
        }

        // 两者的差值就是键盘的高度
        val keyboardHeight = heightMax - rect.bottom
        listener?.invoke(keyboardHeight)
    }

    override fun dismiss() {
        super.dismiss()
        rootView.viewTreeObserver.removeOnGlobalLayoutListener(this)
        listener = null
    }

    init {
        // 基础配置
        contentView = rootView

        // 监听全局Layout变化
        rootView.viewTreeObserver.addOnGlobalLayoutListener(this)
        setBackgroundDrawable(ColorDrawable(0))

        // 设置宽度为0，高度为全屏
        width = 0
        height = ViewGroup.LayoutParams.MATCH_PARENT

        // 设置键盘弹出方式
        softInputMode = WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE
        inputMethodMode = INPUT_METHOD_NEEDED
    }
}