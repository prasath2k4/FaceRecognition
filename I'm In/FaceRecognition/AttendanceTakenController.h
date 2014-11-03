//
//  AttendanceTakenController.h
//  FaceRecognition
//
//  Created by Kailash Ramachandran on 8/5/14.
//
//

#import <UIKit/UIKit.h>

@interface AttendanceTakenController : UIViewController
@property(strong,nonatomic)IBOutlet UIActivityIndicatorView *uiIndicator;

-(IBAction)exitApplication;
@property(strong,nonatomic)IBOutlet UILabel *updateLabell;
@end
