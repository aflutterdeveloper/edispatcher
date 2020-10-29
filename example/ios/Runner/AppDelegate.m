#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "StonerLocalPlugin.h"
#import <ATHContext/ATHContext.h>
#import "FacebookHelper.h"

@interface AppDelegate()

@end

static NSString * const LogTag = @"AppDelegate";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [GeneratedPluginRegistrant registerWithRegistry:self];
    // Override point for customization after application launch.
    MFLogInfo(LogTag, @"App launch");
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsURLKey] != nil) {
        MFLogInfo(LogTag, @"Launch options found UIApplicationLaunchOptionsURLKey");
    }
    [[FacebookHelper sharedInstance] initFacebookDeepLinks];
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    MFLogInfo(LogTag, @"openURL: %@", url);
    if ([url.scheme isEqualToString:@"waireadstoner"]) {
        MFLogInfo(LogTag, @"URI scheme is waireadstoner, matched");
        [[StonerLocalPlugin sharedInstance] handleAppsflyerWithUrl:url];
        return YES;
    } else {
        MFLogInfo(LogTag, @"URI scheme is other, handled by super");
        return [super application:app openURL:url options:options];
    }
}

@end
