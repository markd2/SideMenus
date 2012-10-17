#import "BWViewController.h"

#import "BWScribbleView.h"
#import "BWSideMenuView.h"


@interface BWViewController ()

@property (nonatomic, weak) IBOutlet BWSideMenuView *menu1;
@property (nonatomic, weak) IBOutlet BWSideMenuView *menu2;
@property (nonatomic, weak) IBOutlet BWSideMenuView *menu3;
@property (nonatomic, weak) IBOutlet BWSideMenuView *menu4;

@property (nonatomic, weak) IBOutlet UISlider *wideSegmentCountSlider;
@property (nonatomic, weak) IBOutlet UISlider *tallSegmentCountSlider;

@property (nonatomic, weak) IBOutlet UILabel *wideSegmentCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *tallSegmentCountLabel;

@property (nonatomic, weak) IBOutlet UILabel *menuSelectionsLabel;

@property (nonatomic, weak) IBOutlet BWScribbleView *scribbleView;

@end // BWViewController


@implementation BWViewController

#define SWF(x) [NSString stringWithFormat: @"%d", (x)]

- (void) updateUI {
    self.wideSegmentCountLabel.text = SWF(self.menu1.sectionCount);
    self.tallSegmentCountLabel.text = SWF(self.menu2.sectionCount);

    self.wideSegmentCountSlider.value = self.menu1.sectionCount;
    self.tallSegmentCountSlider.value = self.menu2.sectionCount;

} // updateUI


- (void) pollMenus: (NSTimer *) timer {
    NSMutableArray *items = [NSMutableArray array];
    if (self.menu1.selectedItem >= 0) [items addObject: SWF(self.menu1.selectedItem)];
    if (self.menu2.selectedItem >= 0) [items addObject: SWF(self.menu2.selectedItem)];
    if (self.menu3.selectedItem >= 0) [items addObject: SWF(self.menu3.selectedItem)];
    if (self.menu4.selectedItem >= 0) [items addObject: SWF(self.menu4.selectedItem)];

    NSString *allTheThings = [items componentsJoinedByString: @", "];

    NSString *text = [@"Menu Selections " stringByAppendingString: allTheThings];
    self.menuSelectionsLabel.text = text;

} // pollMenus


- (void) startTimer {
    (void) [NSTimer scheduledTimerWithTimeInterval: 0.1
                    target: self
                    selector: @selector(pollMenus:)
                    userInfo: nil
                    repeats: YES];
} // startTimer


- (void) viewDidLoad {
    [super viewDidLoad];

    self.menu1.sectionCount = 10;
    self.menu2.sectionCount = 20;
    self.menu3.sectionCount = 10;
    self.menu4.sectionCount = 20;

    [self updateUI];

    [self startTimer];

} // viewDidLoad


- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation {
    return YES;
} // shouldAutorotate


- (IBAction) setWideSegmentCount: (UISlider *) slider {
    self.menu1.sectionCount = slider.value;
    self.menu3.sectionCount = slider.value;
    [self updateUI];

} // setWideSegmentCount


- (IBAction) setTallSegmentCount: (UISlider *) slider {
    self.menu2.sectionCount = slider.value;
    self.menu4.sectionCount = slider.value;
    [self updateUI];

} // setTallSegmentCount


- (void) didRotateFromInterfaceOrientation:
    (UIInterfaceOrientation) fromInterfaceOrientation {
    [self.scribbleView setNeedsDisplay];

    [self.menu1 setNeedsDisplay];
    [self.menu2 setNeedsDisplay];
    [self.menu3 setNeedsDisplay];
    [self.menu4 setNeedsDisplay];

} // didRotate


@end
