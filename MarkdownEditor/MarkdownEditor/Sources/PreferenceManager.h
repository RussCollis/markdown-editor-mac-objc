//
//  PreferenceManager.h
//  MarkdownEditor
//
//  Created by Iwaki Satoshi on 2018/04/11.
//  Copyright © 2018年 Satoshi Iwaki. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PreferenceManager : NSObject

@property (class, readonly, strong) PreferenceManager *sharedManager;

@property BOOL autoReloadEnabled;

/// Registers factory default values. Call before any UI bound to user defaults loads.
+ (void)registerDefaults;

@end

NS_ASSUME_NONNULL_END
