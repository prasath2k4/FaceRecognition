//
//  AttendanceTakenController.m
//  FaceRecognition
//
//  Created by Kailash Ramachandran on 8/5/14.
//
//

#import "AttendanceTakenController.h"

@interface AttendanceTakenController ()

@end

@implementation AttendanceTakenController
@synthesize uiIndicator,updateLabell;


-(void)exitApplication{
    exit(0);
    }

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[uiIndicator startAnimating];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
