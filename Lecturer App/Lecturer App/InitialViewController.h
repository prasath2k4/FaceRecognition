//
//  InitialViewController.h
//  Lecturer App
//
//  Created by Kailash Ramachandran on 4/7/14.
//  Copyright (c) 2014 Team-7. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InitialViewController : UIViewController <UITextFieldDelegate, NSURLSessionDelegate, UITextViewDelegate>
@property(strong, nonatomic) IBOutlet UITextField *studID;
@property(strong, nonatomic) NSMutableData *buffer;
@property(strong, nonatomic) IBOutlet UITextField *classDate;
@property(strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property(strong, nonatomic) NSArray *studData;

-(IBAction)markAttendance;
-(IBAction)getAttendeesList;
-(IBAction)exitApp;

@end
