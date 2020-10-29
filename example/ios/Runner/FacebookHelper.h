//
//  FacebookHelper.h
//  Runner
//
//  Created by Kin Wong on 2020/8/6.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#ifndef FacebookHelper_h
#define FacebookHelper_h

@interface FacebookHelper : NSObject

+ (instancetype)sharedInstance;
- (void)initFacebookDeepLinks;

@end


#endif /* FacebookHelper_h */
