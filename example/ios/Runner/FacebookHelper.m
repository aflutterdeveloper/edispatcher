//
//  FacebookHelper.m
//  Runner
//
//  Created by Kin Wong on 2020/8/6.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FacebookHelper.h"
#import <ATHContext/ATHContext.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <StonerLocalPlugin.h>

static NSString* const LogTag = @"FacebookHelper";

@implementation FacebookHelper

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static FacebookHelper* instance;
    dispatch_once(&onceToken, ^() {
        instance = [[FacebookHelper alloc] init];
    });
    return instance;
}

- (void)initFacebookDeepLinks
{
    MFLogInfo(LogTag, @"Init facebook deeplinks start");
    [FBSDKSettings setAutoInitEnabled:YES];
    [FBSDKApplicationDelegate initializeSDK:nil];
    [FBSDKAppLinkUtility fetchDeferredAppLink:^(NSURL* url, NSError* error) {
        if (error != nil) {
            MFLogWarn(LogTag, @"Fetch deferred applink error: %@", error);
        }
        if (url != nil) {
            MFLogInfo(LogTag, @"Received Facebook AppLink: %@", url.absoluteString);
            // 保证在主线程调用
            dispatch_async(dispatch_get_main_queue(), ^() {
               [[StonerLocalPlugin sharedInstance] handleAppsflyerWithUrl:url];
            });
        }
    }];
}

@end
