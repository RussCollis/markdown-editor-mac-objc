//
//  LineNumberRulerView.h
//  MarkdownEditor
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

/// A vertical ruler that draws line numbers alongside an NSTextView.
@interface LineNumberRulerView : NSRulerView

- (instancetype)initWithTextView:(NSTextView *)textView;

@end

NS_ASSUME_NONNULL_END
