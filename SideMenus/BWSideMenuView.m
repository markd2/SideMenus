#import "BWSideMenuView.h"

static const NSInteger kNoSelection = -1;

@interface BWSideMenuView ()

@end // extension

@implementation BWSideMenuView


- (void) commonInit {
    _selectedItem = kNoSelection;
} // commonInit


- (id) initWithCoder: (NSCoder *) decoder {
    if ((self = [super initWithCoder: decoder])) {
        [self commonInit];
    }
    return self;

} // initWithCoder


- (id) initWithFrame: (CGRect) frame {
    if ((self = [super initWithFrame: frame])) {
        [self commonInit];
    }
    return self;
} // initWithFrame


- (void) setSelectedItem: (NSInteger) selectedItem {
    _selectedItem = selectedItem;
    [self setNeedsDisplay];
} // setSelectedItem


- (void) setSectionCount: (NSInteger) sectionCount {
    _sectionCount = sectionCount;
    [self setNeedsDisplay];
} // setSelectedItem


- (CGRect) boundsForSegment: (NSInteger) segment {
    CGRect bounds = self.bounds;

    CGFloat longSide = MAX (bounds.size.width, bounds.size.height);
    CGFloat shortSide = MIN (bounds.size.width, bounds.size.height);
    
    // Evenly divide segments.
    CGFloat dimension = longSide / _sectionCount;

    CGRect rect;

    if (bounds.size.width < bounds.size.height) { // portrait
        rect = CGRectMake (bounds.origin.x, bounds.origin.y + segment * dimension,
                           shortSide, dimension);
    } else {
        rect = CGRectMake (bounds.origin.x + segment * dimension, bounds.origin.y,
                           dimension, shortSide);
    }

    return rect;

} // boundsForSegment



- (void) drawText: (NSString *) text
   centeredInRect: (CGRect) rect
             font: (UIFont *) font {
    CGSize textSize = [text sizeWithFont: font
                            constrainedToSize: rect.size
                            lineBreakMode: UILineBreakModeWordWrap];

    // Center text rect inside of |rect|.
    CGRect textRect = CGRectMake (CGRectGetMidX(rect) - textSize.width / 2.0,
                                  CGRectGetMidY(rect) - textSize.height / 2.0,
                                  textSize.width, textSize.height);

    [text drawInRect: textRect
          withFont: font
          lineBreakMode: UILineBreakModeWordWrap
          alignment: UITextAlignmentCenter];

} // drawText


- (void) drawRect: (CGRect) rect {

    CGRect bounds = self.bounds;

    UIColor *color = [UIColor colorWithRed: 0.8
                              green: 0.7
                              blue: 0.6
                              alpha: 1.0]; // TODO(markd): experiment with alpha
    [color set];
    UIRectFill (bounds);

    UIFont *font = [UIFont boldSystemFontOfSize: 18];

    [[UIColor darkGrayColor] set];
    for (int i = 0; i < _sectionCount; i++) {
        // TODO(markd): proper coordinate rounding for the rect.
        CGRect rect = [self boundsForSegment: i];

        if (self.selectedItem == i) {
            [[UIColor purpleColor] set];
            UIRectFill (rect);
            [[UIColor darkGrayColor] set];
        }

        NSString *label = [NSString stringWithFormat: @"- %d -", i];
        [self drawText: label
              centeredInRect: rect
              font: font];

        UIRectFrame (rect);
    }

    [[UIColor blackColor] set];
    UIRectFrame (bounds);

} // drawRect


// --------------------------------------------------

- (NSInteger) selectedIndexForTouch: (UITouch *) touch {
    NSInteger selectedIndex = kNoSelection;

    CGPoint point = [touch locationInView: self];

    for (NSInteger i = 0; i < _sectionCount; i++) {
        CGRect rect = [self boundsForSegment: i];

        if (CGRectContainsPoint(rect, point)) {
            selectedIndex = i;
            break;
        }
    }
    return selectedIndex;

} // selectedIndexForTouch


- (void) updateSelectionToIndex: (NSInteger) newIndex {
    if (newIndex != self.selectedItem) self.selectedItem = newIndex;
} // udpateSelectionToIndex


- (void) touchesBegan: (NSSet *) touches  withEvent: (UIEvent *) event {
    UITouch *touch = [touches anyObject];
    NSInteger selectedIndex = [self selectedIndexForTouch: touch];
    [self updateSelectionToIndex: selectedIndex];

} // touchesBegan


- (void) touchesMoved: (NSSet *) touches  withEvent: (UIEvent *) event {
    UITouch *touch = [touches anyObject];
    NSInteger selectedIndex = [self selectedIndexForTouch: touch];
    [self updateSelectionToIndex: selectedIndex];

} // touchesMoved


- (void) touchesEnded: (NSSet *) touches  withEvent: (UIEvent *) event {
    UITouch *touch = [touches anyObject];
    NSInteger selectedIndex = [self selectedIndexForTouch: touch];
    [self updateSelectionToIndex: selectedIndex];
    // Notify on release?
    // Set to kNoSelection?

} // touchesEnded


- (void) touchesCancelled: (NSSet *) touches  withEvent: (UIEvent *) event {
    [self updateSelectionToIndex: kNoSelection];
} // touchesCancelled


@end // BWSideMenuView

