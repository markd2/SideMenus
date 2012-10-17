#import <UIKit/UIKit.h>

// A pie-menu kind of thing that sits on the side of the screen for easy 
// interaction with the holding thumb.

// Supports momentary (tap to toggle) and continuous (hold to turn on, release 
// to turn off) touches.

// Usage model is that the side menu won't actually notify anybody, but can
// be polled for what the user is doing.  (This may need to change)


@interface BWSideMenuView : UIView

@property (nonatomic, copy) NSArray *menuImages;
@property (nonatomic, assign) NSInteger sectionCount;

@property (nonatomic, assign) NSInteger selectedItem;

@end // BWSideMenuView
