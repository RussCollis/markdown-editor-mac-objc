//
//  MainWindowController.m
//  MarkdownEditor
//
//  Created by Iwaki Satoshi on 2018/03/03.
//  Copyright © 2018年 Satoshi Iwaki. All rights reserved.
//

#import "MainWindowController.h"
#import "GitHubGistsClient.h"

@interface MainWindowController () {
}

@end

@implementation MainWindowController

- (NSArray<NSString *> *)converters {
    return ConverterManager.sharedInstance.converters;
}

- (NSUInteger)selectedConverterIndex {
    return ConverterManager.sharedInstance.selectedConverterIndex;
}

- (void)setSelectedConverterIndex:(NSUInteger)selectedFormatIndex {
    ConverterManager.sharedInstance.selectedConverterIndex = selectedFormatIndex;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // macOS can rebuild toolbar items after the window loads (macOS 27 does), which
    // discards anything set on the original items, so configure each item as it's added too.
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(toolbarWillAddItem:)
                                               name:NSToolbarWillAddItemNotification
                                             object:self.window.toolbar];
    for (NSToolbarItem *item in self.window.toolbar.items) {
        [self configureToolbarItem:item];
    }

    // Split the editor and preview panes evenly once the window has been laid out.
    dispatch_async(dispatch_get_main_queue(), ^{
        for (NSToolbarItem *item in self.window.toolbar.items) {
            [self configureToolbarItem:item];
        }
        [self centerSplitViewDivider];
    });
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)toolbarWillAddItem:(NSNotification *)notification {
    [self configureToolbarItem:notification.userInfo[@"item"]];
}

/// The toolbar drops storyboard button images and tags when it copies its items, so the
/// formatting buttons get their icons (SF Symbols) and heading levels here, keyed by label.
- (void)configureToolbarItem:(NSToolbarItem *)item {
    if (![item.view isKindOfClass:[NSButton class]]) {
        return;
    }
    NSButton *button = (NSButton *)item.view;
    button.toolTip = item.label;

    // "Heading N" buttons use their tag as the heading level.
    if ([item.label hasPrefix:@"Heading "]) {
        NSInteger level = [item.label substringFromIndex:@"Heading ".length].integerValue;
        item.tag = level;
        button.tag = level;
        return;
    }

    static NSDictionary<NSString *, NSString *> *symbols;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        symbols = @{
            @"Bold": @"bold",
            @"Strike Through": @"strikethrough",
            @"Italic": @"italic",
            @"Quote": @"text.quote",
            @"Code": @"chevron.left.forwardslash.chevron.right",
            @"Link": @"link",
            @"Bulleted List": @"list.bullet",
            @"Numbered List": @"list.number",
            @"Task List": @"checklist",
            @"Horizontal Rule": @"minus",
        };
    });
    NSString *symbol = symbols[item.label];
    if (!symbol) {
        return;
    }
    NSImage *image = [NSImage imageWithSystemSymbolName:symbol accessibilityDescription:item.label];
    button.image = image;
    button.title = @"";
    button.imagePosition = NSImageOnly;
    item.image = image;
}

- (void)centerSplitViewDivider {
    if (![self.contentViewController isKindOfClass:[NSSplitViewController class]]) {
        return;
    }
    NSSplitView *splitView = ((NSSplitViewController *)self.contentViewController).splitView;
    [splitView layoutSubtreeIfNeeded];
    CGFloat available = NSWidth(splitView.bounds) - splitView.dividerThickness;
    [splitView setPosition:floor(available / 2.0) ofDividerAtIndex:0];
}

- (IBAction)loginButtonClicked:(id)sender {
    [GitHubGistsClient.sharedClient login];
}

@end
