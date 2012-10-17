//
//  BWAppDelegate.h
//  SideMenus
//
//  Created by Mark Dalrymple on 9/8/12.
//  Copyright (c) 2012 Mark Dalrymple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BWViewController;

@interface BWAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) BWViewController *viewController;

@end
