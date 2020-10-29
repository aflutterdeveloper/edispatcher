# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile

-optimizationpasses 5
-dontusemixedcaseclassnames
-dontskipnonpubliclibraryclasses
-dontskipnonpubliclibraryclassmembers
-verbose
-optimizations !code/simplification/arithmetic,!field/*,!class/merging/*
-dontwarn All
-dontwarn android.support.v4.**
-dontwarn javax.microedition.khronos.**
#-keepattributes InnerClasses
-keepattributes JavascriptInterface
-keepattributes Signature
-keepattributes *Annotation*
-ignorewarnings

#-dontpreverify
-dontoptimize

-keep @android.support.annotation.Keep class **
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Application
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider
-keep public class * extends android.preference.Preference
-keep class android.support.v4.** { *; }
-keep class * extends android.support.v4.**
-keep class android.support.v7.**{
    public *;
}

-keepclasseswithmembers class * {
    native <methods>;
}

-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet);
}

-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet, int);
}

-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
    public static ** valueOf(int);
}

-keepclassmembers class * implements android.os.Parcelable {
    static ** CREATOR;
    <fields>;
    <methods>;
}

-keep class * implements java.io.Serializable {
    *;
}

-keepattributes SourceFile,LineNumberTable

-keep class * extends android.view.View

##----- push -----
-keep class com.huawei.android.pushagent.**{*;}
-keep class com.huawei.android.pushselfshow.**{*;}
-keep class com.huawei.android.microkernel.**{*;}

-dontwarn com.taobao.**
-dontwarn anet.channel.**
-dontwarn anetwork.channel.**
-dontwarn org.android.**
-dontwarn org.apache.thrift.**
-dontwarn com.xiaomi.**
-dontwarn com.huawei.**

-dontwarn okio.**
-dontwarn org.apache.commons.codec.binary.**

-keepattributes *Annotation*

-keep class com.taobao.**{*;}
-keep class org.android.**{*;}
-keep class anet.channel.**{*;}
-keep class com.umeng.**{*;}
-keep class com.xiaomi.**{*;}
-keep class com.huawei.**{*;}
-keep class org.apache.thrift.**{*;}

-keep class com.alibaba.sdk.android.**{*;}
-keep class com.ut.**{*;}
-keep class com.ta.**{*;}

-keep class com.alibaba.sdk.android.oss.** { *; }
-keep class org.apache.commons.codec.binary.** { *; }

##------end push -----

##----- yypushsvc begin -----
-keep class com.yy.pushsvc.** { *; }
-keep public class com.yy.sdk.crashreport.CrashHandler{<methods>;}
-keep class com.yy.sdk.crashreport.**{*;}

##--arouter begin--
-keep class com.alibaba.android.arouter.**{*;}
-keep class * implements com.alibaba.android.arouter.facade.template.ISyringe{*;}

# 如果使用了 byType 的方式获取 Service，需添加下面规则，保护接口
-keep interface * implements com.alibaba.android.arouter.facade.template.IProvider
# 如果使用了 单类注入，即不定义接口实现 IProvider，需添加下面规则，保护实现
-keep class * implements com.alibaba.android.arouter.facade.template.IProvider

##--arouter end--

-keepclassmembers class * extends android.webkit.WebChromeClient{
    public void openFileChooser(...);
}

-keepattributes Exceptions,InnerClasses,Signature,Deprecated,SourceFile,LineNumberTable,*Annotation*,EnclosingMethod

-keepclasseswithmembers class com.yy.platform.baseservice.Channel{ *; }

#--------------------------------architecture start----------------------------------------
-keep class * implements tv.athena.core.sly.SlyBridge.IMessageHandler{*;}
-keep class * implements tv.athena.core.axis.AxisProvider{*;}

-keepclasseswithmembers class * {
    @tv.athena.annotation.MessageBinding public <methods>;
}

#貌似kotlin中定义的内部类接口keep不住，只能先用类名通配符来keep
-keep public class **.*$$SlyBinder{*;}

-keep public @interface tv.athena.annotation.ProguardKeepClass
-keep @tv.athena.annotation.ProguardKeepClass class * { *; }
-keepclassmembers class * {
    @tv.athena.annotation.ProguardKeepMethod <methods>;
}
-keep interface tv.athena.**.api.**{*;}
-keep interface tv.niubility.**.api.**{*;}
#--------------------------------architecture end------------------------------------------

#------------------------------ServiceRegister api start--------------------------------------
-keep interface tv.niubility.teacher.ITeacherService
-keep interface com.yy.pay.IPayService
-keep interface tv.niubility.bs2.IBs2Service
#------------------------------ServiceRegister api end--------------------------------------

#Glide
-keep public class com.bumptech.glide.integration.webp.WebpImage { *; }
-keep public class com.bumptech.glide.integration.webp.WebpFrame { *; }
-keep public class com.bumptech.glide.integration.webp.WebpBitmapFactory { *; }
-keep public class * implements com.bumptech.glide.module.GlideModule
-keep public class * extends com.bumptech.glide.module.AppGlideModule
-keep public enum com.bumptech.glide.load.ImageHeaderParser$** {
  **[] $VALUES;
  public *;
}

#Init
-keep public @interface tv.athena.init.annotation.AppInit
-keepnames @tv.athena.init.annotation.AppInit class *{*;}

#BaseQuickAdapter
-keep class com.chad.library.adapter.** {
*;
}
-keep public class * extends com.chad.library.adapter.base.BaseQuickAdapter
-keep public class * extends com.chad.library.adapter.base.BaseViewHolder
-keepclassmembers  class **$** extends com.chad.library.adapter.base.BaseViewHolder {
     <init>(...);
}

-keep class org.xmlpull.v1.** { *;}
-dontwarn org.xmlpull.v1.**


#-keep class com.duowan.mobile.main.**
#-keep class com.duowan.mobile.setting.**
-keep class com.duowan.mobile.main.**{*;}
-keep class com.duowan.mobile.setting.**{*;}
#-keep class com.duowan.mobile.main.feature.**{*;}
#-keep class com.duowan.mobile.main.annotation.**{*;}
#-keep class com.duowan.mobile.main.feature.wrapper.**{*;}
#-keep class * implements com.duowan.mobile.main.feature.FeatureMapSyringe{*;}
#-keep class com.duowan.mobile.main.feature.FeatureMapSyringe{*;}

#http
-keep, allowobfuscation, includedescriptorclasses class * {
	@com.yy.mobile.framework.httpapi.annotations.Get <methods>;
}
-keep, allowobfuscation, includedescriptorclasses class * {
	@com.yy.mobile.framework.httpapi.annotations.Post <methods>;
}

-keep public interface tv.athena.thirdparty.http.api.**
#push
-dontwarn com.taobao.**
-dontwarn anet.channel.**
-dontwarn anetwork.channel.**
-dontwarn org.android.**
-dontwarn org.apache.thrift.**
-dontwarn com.xiaomi.**
-dontwarn com.huawei.**
-keepattributes *Annotation*
-keep class com.taobao.** {*;}
-keep class org.android.** {*;}
-keep class anet.channel.** {*;}
-keep class com.umeng.** {*;}
-keep class com.xiaomi.** {*;}
-keep class com.huawei.** {*;}

-keepattributes *Annotation*
-keepattributes Exceptions
-keepattributes InnerClasses
-keepattributes Signature
-keepattributes SourceFile,LineNumberTable
-keep class com.hianalytics.android.**{*;}
-keep class com.huawei.updatesdk.**{*;}
-keep class com.huawei.hms.**{*;}
-keep class com.huawei.gamebox.plugin.gameservice.**{*;}
-keep public class com.huawei.android.hms.agent.** extends android.app.Activity { public *; protected *; }
-keep interface com.huawei.android.hms.agent.common.INoProguard {*;}
-keep class * extends com.huawei.android.hms.agent.common.INoProguard {*;}
-keep class com.google.firebase.**{*;}

-keep class org.apache.thrift.** {*;}
-keep class com.alibaba.sdk.android.**{*;}
-keep class com.ut.**{*;}
-keep class com.ta.**{*;}
-keep public class **.R$*{
   public static final int *;
}
-assumenosideeffects class android.util.Log {
   public static *** v(...);
   public static *** d(...);
   public static *** i(...);
   public static *** w(...);
 }

 -dontwarn com.igexin.**
 -keep class com.igexin.** { *; }
 -keep class org.json.** { *; }

 -keep public class * extends android.app.Service
 -keep class com.coloros.mcssdk.** {*;}

 -keep class com.meizu.cloud.pushsdk.**{*;}

 -dontwarn com.vivo.push.**
 -keep class com.vivo.push.**{*; }
 -keep class com.vivo.vms.**{*; }

#--所有加上这个注解的类或者接口，都不混淆
-keep public @interface com.wairead.book.utils.DontProguardClass
-keep @com.wairead.book.utils.DontProguardClass class * { *; }


 -keep class * extends android.app.Dialog

 #--leakcanary 不混淆
-dontwarn com.squareup.haha.guava.**
-dontwarn com.squareup.haha.perflib.**
-dontwarn com.squareup.haha.trove.**
-dontwarn com.squareup.leakcanary.**
-keep class com.squareup.haha.** { *; }
-keep class com.squareup.leakcanary.** { *; }

#---微信和QQ 第三方登录----
-keep class com.tencent.mm.opensdk.** {*;}
-keep class com.tencent.wxop.** {*;}
-keep class com.tencent.mm.sdk.** {*;}

#Kinds ---start-----
# 使用Kinds必须添加的混淆
-keep class * implements com.duowan.mobile.main.kinds.KindMapSyringe
-keep class * extends com.duowan.mobile.main.kinds.wrapper.AbstractKindWrapper
-keepclassmembers class * extends com.duowan.mobile.main.kinds.wrapper.AbstractKindWrapper {
    public <init>(...);
}
# 使用kinds-activity需要添加的混淆
-dontwarn com.yy.abtest.**
-keep class com.yy.abtest.** { *; }
-keep class com.duowan.kindsActivity.SettingFeatureActivity
-keep class com.duowan.kindsActivity.SettingActivityStorage
-keepclassmembers class com.duowan.kindsActivity.SettingActivityStorage {
    public <init>(...);
}
-keep class com.duowan.kindsActivity.NewSettingFeatureActivity
-keep class com.duowan.kindsActivity.SearchResultActivity
-keep class com.duowan.kindsActivity.proxy.*{*;}

# 使用参数注入功能@KindsInject需要添加的混淆
-keep class * implements com.duowan.mobile.main.kinds.IKindInject
-keep class com.duowan.mobile.main.annotation.*
-keep @com.duowan.mobile.main.annotation.* class **
#Kinds ---end-----

#---- SVGA ----
-keep class com.squareup.wire.** { *; }
-keep class com.opensource.svgaplayer.proto.** { *; }

#thunder sdk防止混淆 start
-keep class com.yy.mediaframework.** { *; }
-keep class com.sensetime.stmobileapi.** { *; }
-keep class com.sensetime.stmobile.** { *; }
-keep class com.sensetime.stmobilejni.** { *; }

-keep interface * {
  <methods>;
}
-keep class com.yy.platform.baseservice.Channel
-keepclassmembers class com.yy.platform.baseservice.Channel {
   *;
}
-keep class com.yy.platform.baseservice.YYServiceCore
-keepclassmembers class com.yy.platform.baseservice.YYServiceCore {
   public *;
}

#--- 百度广告SDK ---
-keepclassmembers class * extends android.app.Activity {
    public void *(android.view.View);
}

-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# android.support.v4
-dontwarn android.support.v4.**
-keep class android.support.v4.** { *; }
-keep interface android.support.v4.** { *; }
-keep public class * extends android.support.v4.**


-keep class com.yy.platform.baseservice.YYServiceCore.BroadcastReceiverImpl
-keepclassmembers class com.yy.platform.baseservice.YYServiceCore.BroadcastReceiverImpl {
   public *;
}

-keep class com.yy.platform.baseservice.task.*
-keepclassmembers class com.yy.platform.baseservice.task.* {
   public *;
}
-keep class com.yy.platform.baseservice.ConstCode$*
-keepclassmembers class com.yy.platform.baseservice.ConstCode$* {
   public *;
}
-keep class com.yy.platform.baseservice.utils.*
# keep 内部类
-keepclassmembers class com.yy.platform.baseservice.utils.* {
   public *;
}
-keepclassmembers enum * { # 保持枚举 enum 类不被混淆
    public static **[] values();
    public static ** valueOf(java.lang.String);
}
-keep class * implements com.yy.mobile.framework.revenuesdk.apppay.IPayMethod { # 保持 IPayMethod 类不被混淆
    *;
}
-keep class com.yy.mobile.framework.revenue.wxpay.*
-keep class com.yy.mobile.framework.revenue.alipay.*

#-keep class !org.apache.http.conn.params.ConnManagerParams
-keep class org.apache.http.** { *; }


# ===================== ADMobGenSdk =====================
-ignorewarnings
# v4、v7
-keep class android.support.v4.**{public *;}
-keep class android.support.v7.**{public *;}

## 资源文件混淆配置
-keep class **.R$* { *; }
-keep public class **.R$*{
   public static final int *;
}
-keepclassmembers class **.R$* {
    public static <fields>;
}

##Flutter 混淆---start
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
##Flutter 混淆---end

##Lua混淆---start------
-keep class org.chromium.** {*; }
-keep class com.common.luakit.** {*; }
##Lua混淆----end-------

##udb混淆---start------
-keep interface tv.athena.**.api.**{*;}
-keep public interface tv.athena.thirdparty.http.api.**
##udb混淆---end------

##营收混淆---start------
-keep class * implements com.yy.mobile.framework.revenuesdk.payapi.payservice.IPayMethod { # 保持 IPayMethod 类不被混淆
    *;
}
-keep class * extends com.yy.mobile.framework.revenuesdk.payapi.payservice.IPayMethod {
    *;
}

-keep class * implements  com.yy.mobile.framework.revenuesdk.payapi.IAppPayService { # 保持 IPayMethod 类不被混淆
    *;
}
-keep class * extends  com.yy.mobile.framework.revenuesdk.payapi.IAppPayService {
    *;
}
-keep class * implements com.yy.mobile.framework.revenuesdk.gift.IGiftService  { # 保持 IPayMethod 类不被混淆
    *;
}
-keep class * extends com.yy.mobile.framework.revenuesdk.gift.IGiftService  {
    *;
}

-keep class com.yy.mobile.framework.revenue.gppay.*
-keep class com.yy.mobile.framework.revenuesdk.payapi.** { *; }
-keep class com.yy.mobile.framework.revenuesdk.gift.** { *; }

##appsflyer
-keep class com.appsflyer.** { *; }
-dontwarn com.android.installreferrer
-keep class com.bun.miitmdid.core.** {*;}

##营收混淆---end------
