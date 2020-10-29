//
//  NotificationService.m
//  notificationService
//
//  Created by Caotingjun on 2019/8/2.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "NotificationService.h"
#import "YYExtensionLogger.h"
#import "YYExtensionDefine.h"


@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler
{
//    [self _log:[NSString stringWithFormat:@"收到带有mutable-content字段的push。identifier:%@,badge:%@,body:%@,categoryIdentifier:%@,launchImageName:%@,sound:%@,subtitle:%@,threadIdentifier:%@,title:%@,userInfo:%@",request.identifier,request.content.badge,request.content.body,request.content.categoryIdentifier,request.content.launchImageName,request.content.sound,request.content.subtitle,request.content.threadIdentifier,request.content.title,request.content.userInfo]];

    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    NSMutableDictionary *userInfo = [request.content.userInfo mutableCopy];
    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    NSString *attachUrlString = [aps objectForKey:@"image"];
    __weak typeof (self) wself =self;
    [self _log:[NSString stringWithFormat:@"img_url = %@", attachUrlString]];
    if ([NSStringFromClass([attachUrlString class]) containsString:@"String"] && attachUrlString.length != 0) {
        [self loadAttachmentForUrlString:attachUrlString
                        completionHandle:^(UNNotificationAttachment *attachment, NSString *extendInfo) {
                            if (attachment) {
                                wself.bestAttemptContent.attachments = [NSArray arrayWithObject:attachment];
                            }
                            wself.bestAttemptContent.userInfo = userInfo;
                            wself.contentHandler(wself.bestAttemptContent);
                        }];
    }
}

- (void)serviceExtensionTimeWillExpire
{
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

- (void)loadAttachmentForUrlString:(NSString *)urlString
                  completionHandle:(void (^)(UNNotificationAttachment *attachment, NSString *attachmentCacheURL))completionHandle
{
    
    __block UNNotificationAttachment *attachment = nil;

    [[YYExtensionDownLoadManager sharedManager]
     downLoadFileWithUrlStr:urlString
     completedBlock:^(NSURL *location, NSURLResponse *response, NSError *error) {
         if (!error) {
             [self _log:[NSString stringWithFormat:@"下载资源成功。downloadUrlString:%@", urlString]];
             NSString *cacheString =
             [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
              stringByAppendingString:response.suggestedFilename];
             NSURL *cacheURL = [NSURL fileURLWithPath:cacheString];
             [[NSFileManager defaultManager] moveItemAtURL:location toURL:cacheURL error:nil];
             NSError *attachmentError = nil;
             attachment = [UNNotificationAttachment attachmentWithIdentifier:@""
                                                                         URL:cacheURL
                                                                     options:nil
                                                                       error:&attachmentError];
             if (!attachmentError) {
                 [self _log:[NSString stringWithFormat:@"生成attachment成功。cacheURL:%@", cacheURL]];
                 completionHandle(attachment, cacheString);
             } else {
                 [self _log:[NSString stringWithFormat:@"生成attachment失败。cacheURL:%@", cacheURL]];
                 attachment = nil;
                 completionHandle(attachment, attachmentError.description);
             }
         } else {
             [self _log:[NSString stringWithFormat:@"下载资源失败。downloadUrlString:%@,error:%@",
                         urlString,
                         error.description]];
             completionHandle(attachment, error.description);
         }
     }];
}

- (void)_log:(NSString *)log
{
    [[YYExtensionLogger sharedObject] log:log extensionName:Extension_NotificationService policy:ExtensionLogPolicyFile];
}


@end
