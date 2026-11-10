//
//  main.m
//  MarkdownEditor
//
//  Created by Iwaki Satoshi on 2018/02/27.
//  Copyright © 2018年 Satoshi Iwaki. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PreferenceManager.h"

int main(int argc, const char * argv[]) {
    [PreferenceManager registerDefaults];
    return NSApplicationMain(argc, argv);
}
