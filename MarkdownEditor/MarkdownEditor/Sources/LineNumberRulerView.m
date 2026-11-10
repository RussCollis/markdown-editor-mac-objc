//
//  LineNumberRulerView.m
//  MarkdownEditor
//

#import "LineNumberRulerView.h"

static const CGFloat kMinimumThickness = 32.0;
static const CGFloat kHorizontalPadding = 8.0;

@implementation LineNumberRulerView

- (instancetype)initWithTextView:(NSTextView *)textView {
    self = [super initWithScrollView:textView.enclosingScrollView orientation:NSVerticalRuler];
    if (self) {
        self.clientView = textView;
        self.ruleThickness = kMinimumThickness;
        // Views don't clip to their bounds by default (macOS 14+), so without this the
        // gutter's background fill would paint over the text beside it.
        self.clipsToBounds = YES;

        // Redraw when the text changes or the editor scrolls.
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(textDidChange:)
                                                   name:NSTextDidChangeNotification
                                                 object:textView];
        NSClipView *clipView = textView.enclosingScrollView.contentView;
        clipView.postsBoundsChangedNotifications = YES;
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(boundsDidChange:)
                                                   name:NSViewBoundsDidChangeNotification
                                                 object:clipView];
    }
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (NSTextView *)textView {
    return (NSTextView *)self.clientView;
}

- (NSDictionary<NSAttributedStringKey, id> *)labelAttributes {
    NSFont *font = [NSFont monospacedDigitSystemFontOfSize:NSFont.smallSystemFontSize weight:NSFontWeightRegular];
    return @{NSFontAttributeName: font,
             NSForegroundColorAttributeName: NSColor.secondaryLabelColor};
}

- (void)textDidChange:(NSNotification *)notification {
    [self updateThickness];
    self.needsDisplay = YES;
}

- (void)boundsDidChange:(NSNotification *)notification {
    self.needsDisplay = YES;
}

/// Widens the gutter as the document gains more digits of lines.
- (void)updateThickness {
    NSString *string = self.textView.string;
    NSUInteger lineCount = 1;
    for (NSUInteger i = 0; i < string.length; i++) {
        if ([string characterAtIndex:i] == '\n') {
            lineCount++;
        }
    }
    NSString *widest = [@"" stringByPaddingToLength:[NSString stringWithFormat:@"%lu", (unsigned long)lineCount].length
                                         withString:@"8"
                                    startingAtIndex:0];
    CGFloat width = ceil([widest sizeWithAttributes:[self labelAttributes]].width) + kHorizontalPadding * 2;
    CGFloat thickness = MAX(kMinimumThickness, width);
    if (thickness != self.ruleThickness) {
        self.ruleThickness = thickness;
    }
}

- (void)drawHashMarksAndLabelsInRect:(NSRect)rect {
    NSTextView *textView = self.textView;
    NSLayoutManager *layoutManager = textView.layoutManager;
    NSTextContainer *textContainer = textView.textContainer;
    if (!layoutManager || !textContainer) {
        return;
    }

    NSRect fillRect = NSIntersectionRect(rect, self.bounds);
    [textView.backgroundColor setFill];
    NSRectFill(fillRect);
    [NSColor.separatorColor setFill];
    NSRectFill(NSMakeRect(NSMaxX(self.bounds) - 1.0, NSMinY(fillRect), 1.0, NSHeight(fillRect)));

    NSString *string = textView.string;
    NSDictionary *attributes = [self labelAttributes];
    NSRect visibleRect = textView.visibleRect;
    NSRange glyphRange = [layoutManager glyphRangeForBoundingRect:visibleRect inTextContainer:textContainer];
    NSRange charRange = [layoutManager characterRangeForGlyphRange:glyphRange actualGlyphRange:NULL];

    // Count the lines that sit above the visible area.
    NSUInteger lineNumber = 1;
    for (NSUInteger i = 0; i < charRange.location; i++) {
        if ([string characterAtIndex:i] == '\n') {
            lineNumber++;
        }
    }

    NSUInteger index = charRange.location;
    NSUInteger end = NSMaxRange(charRange);
    // Rewind to the start of the paragraph that contains the first visible character.
    index = [string lineRangeForRange:NSMakeRange(index, 0)].location;
    while (index < end || (index == end && index < string.length)) {
        NSUInteger glyphIndex = [layoutManager glyphIndexForCharacterAtIndex:index];
        NSRect lineRect = [layoutManager lineFragmentRectForGlyphAtIndex:glyphIndex effectiveRange:NULL];
        [self drawLineNumber:lineNumber inLineRect:lineRect attributes:attributes];
        lineNumber++;
        index = NSMaxRange([string lineRangeForRange:NSMakeRange(index, 0)]);
    }

    // The empty line after a trailing newline (or an empty document) has no glyphs.
    NSRect extraRect = layoutManager.extraLineFragmentRect;
    if (!NSIsEmptyRect(extraRect) || string.length == 0) {
        if (string.length == 0) {
            lineNumber = 1;
        }
        [self drawLineNumber:lineNumber inLineRect:extraRect attributes:attributes];
    }
}

- (void)drawLineNumber:(NSUInteger)lineNumber inLineRect:(NSRect)lineRect attributes:(NSDictionary *)attributes {
    NSTextView *textView = self.textView;
    NSPoint origin = textView.textContainerOrigin;
    NSPoint lineTop = [self convertPoint:NSMakePoint(0, NSMinY(lineRect) + origin.y) fromView:textView];

    NSString *label = [NSString stringWithFormat:@"%lu", (unsigned long)lineNumber];
    NSSize size = [label sizeWithAttributes:attributes];
    CGFloat x = self.ruleThickness - kHorizontalPadding - size.width;
    CGFloat y = lineTop.y + (NSHeight(lineRect) - size.height) / 2.0;
    [label drawAtPoint:NSMakePoint(x, y) withAttributes:attributes];
}

@end
