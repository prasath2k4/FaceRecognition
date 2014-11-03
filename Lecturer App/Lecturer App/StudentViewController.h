//
//  StudentViewController.h
//  Lecturer App
//
//  Created by Kailash Ramachandran on 4/7/14.
//  Copyright (c) 2014 Team-7. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InitialViewController;
@interface StudentViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSArray *studArray;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) InitialViewController *ic;
-(IBAction)goBack;
@end
