//
//  NUSAppDelegate.h
//  BeaconReceiver
//
//  Created by Team-7


#import <UIKit/UIKit.h>
#import "NUSViewController.h"

@class NUSViewController;

@interface NUSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NUSViewController *nusView;
@end
