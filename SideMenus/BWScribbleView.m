#import "BWScribbleView.h"


@interface BWScribbleView () {
    NSMutableArray *_points;
    UIFont *_font;

    BOOL _tracking;
    CGPoint _lastTouch;
}

@end // extension


@implementation BWScribbleView


- (id) initWithCoder: (NSCoder *) decoder {
    if ((self = [super initWithCoder: decoder])) {
        _points = [NSMutableArray array];
        _font = [UIFont boldSystemFontOfSize: 45.0];

        UITapGestureRecognizer *doubleTap =
            [[UITapGestureRecognizer alloc] initWithTarget: self
                                            action: @selector(doubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer: doubleTap];

        self.userInteractionEnabled = YES;
    }

    return self;

} // initWithCoder


- (void) doubleTap: (id) sender {
    NSLog (@"GRONK");
    [_points removeAllObjects];
    [self setNeedsDisplay];

} // doubleTap


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

    [[UIColor whiteColor] set];
    UIRectFill (bounds);

    UIColor *color = [UIColor colorWithRed: 0.9
                              green: 0.9
                              blue: 0.9
                              alpha: 1.0]; // TODO(markd): experiment with alpha
    [color set];
    [self drawText: @"Tap and drag here"
          centeredInRect: bounds
          font: _font];

    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineCapStyle = kCGLineCapRound;
    bezierPath.lineWidth = 1.5;

    [[UIColor darkGrayColor] set];
    
    for (int i = 0; i < _points.count; i++) {
        if (i == 0) continue;

        id startValue = [_points objectAtIndex: i - 1];
        id endValue = [_points objectAtIndex: i];
        if (startValue == [NSNull null] || endValue == [NSNull null]) continue;

        CGPoint start = [startValue CGPointValue];
        CGPoint end = [endValue CGPointValue];
        [bezierPath removeAllPoints];
        [bezierPath moveToPoint: start];
        [bezierPath addLineToPoint: end];
        [bezierPath stroke];
    }

} // drawRect





// --------------------------------------------------

- (void) addTouch: (UITouch *) touch {
    
    if (touch == nil) {
        [_points addObject: [NSNull null]];
    } else {
        CGPoint point = [touch locationInView: self];
        NSValue *value = [NSValue valueWithCGPoint: point];
        [_points addObject: value];
    }

    [self setNeedsDisplay];

} // addTouch


- (void) touchesBegan: (NSSet *) touches  withEvent: (UIEvent *) event {
    UITouch *touch = [touches anyObject];
    _tracking = YES;

    [self addTouch: touch];
    [self setNeedsDisplay];

} // touchesBegan


- (void) touchesMoved: (NSSet *) touches  withEvent: (UIEvent *) event {
    UITouch *touch = [touches anyObject];
    [self addTouch: touch];

} // touchesMoved


- (void) touchesEnded: (NSSet *) touches  withEvent: (UIEvent *) event {
    _tracking = NO;
    [self addTouch: nil];

} // touchesEnded


- (void) touchesCancelled: (NSSet *) touches  withEvent: (UIEvent *) event {
    _tracking = NO;
} // touchesCancelled


@end // BWScribbleView
