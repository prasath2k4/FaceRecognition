

#import "RecognizeViewController.h"
#import "AttendanceTakenController.h"
#import "OpenCVData.h"
#define CAPTURE_FPS 30

@interface RecognizeViewController ()
- (IBAction)switchCameraClicked:(id)sender;
@end

@implementation RecognizeViewController
@synthesize buffer,instructionLabel,nameAlert;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.faceDetector = [[FaceDetector alloc] init];
    //self.faceRecognizer = [[CustomFaceRecognizer alloc] initWithEigenFaceRecognizer];
   self.faceRecognizer = [[CustomFaceRecognizer alloc] initWithLBPHFaceRecognizer];
    [self setupCamera];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Re-train the model in case more pictures were added
    self.modelAvailable = [self.faceRecognizer trainModel];
    
    if (!self.modelAvailable)
    {
        //self.instructionLabel.text = @"Add people in the database first";
    }
    
    [self.videoCamera start];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self.videoCamera stop];
}


- (void)setupCamera
{
    self.videoCamera = [[CvVideoCamera alloc] initWithParentView:self.imageView];
    self.videoCamera.delegate = self;
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    self.videoCamera.defaultFPS = CAPTURE_FPS;
    self.videoCamera.grayscaleMode = NO;
}

- (void)processImage:(cv::Mat&)image
{
    // Only process every CAPTURE_FPS'th frame (every 1s)
    if (self.frameNum == CAPTURE_FPS)
    {
        [self parseFaces:[self.faceDetector facesFromImage:image] forImage:image];
        self.frameNum = 0;
    }
    
    self.frameNum++;
}

- (void)parseFaces:(const std::vector<cv::Rect> &)faces forImage:(cv::Mat&)image
{
    // No faces found
    if (faces.size() != 1)
    {
        [self noFaceToDisplay];
        return;
    }
    
    // We only care about the first face
    cv::Rect face = faces[0];
    
    // By default highlight the face in red, no match found
    CGColor *highlightColor = [[UIColor redColor] CGColor];
    NSString *message = @"No match found";
    NSString *confidence = @"";
    
    // Unless the database is empty, try a match
    if (self.modelAvailable)
    {
        NSDictionary *match = [self.faceRecognizer recognizeFace:face inImage:image];
        
        // Match found
        if ([match objectForKey:@"personID"] != [NSNumber numberWithInt:-1])
        {
            message = [match objectForKey:@"personName"];
            highlightColor = [[UIColor greenColor] CGColor];
            NSNumberFormatter *confidenceFormatter = [[NSNumberFormatter alloc] init];
            [confidenceFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            confidenceFormatter.maximumFractionDigits = 2;
            confidence = [NSString stringWithFormat:@"Confidence: %@",[confidenceFormatter stringFromNumber:[match objectForKey:@"confidence"]]];
            nameAlert=message;
        }
    }
    
    // All changes to the UI have to happen on the main thread
    dispatch_sync(dispatch_get_main_queue(), ^{ NSString * nomatch=@"No match found";
        
        self.instructionLabel.text = message;
        self.confidenceLabel.text = confidence;
        [self highlightFace:[OpenCVData faceToCGRect:face] withColor:highlightColor];

        /*
        
        //to connect to attendance DB and show the alert view
        if(![message isEqualToString:nomatch])
        {
            UIViewController *attendence =[[AttendanceTakenController alloc]initWithNibName:@"AttendanceTakenController" bundle:nil];
            
            [self presentViewController:attendence animated:YES completion:nil];
            //[self jsonCall:message];
        }
         */
         
       
        // [self printMessage];
        });
    
}

- (void)noFaceToDisplay
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        
        self.instructionLabel.text = @"No face in image";
        self.confidenceLabel.text = @"";
        self.featureLayer.hidden = YES;
        
    });
}

- (void)highlightFace:(CGRect)faceRect withColor:(CGColor *)color
{
    if (self.featureLayer == nil)
    {
        self.featureLayer = [[CALayer alloc] init];
        self.featureLayer.borderWidth = 4.0;
    }
    
    [self.imageView.layer addSublayer:self.featureLayer];
    self.featureLayer.hidden = NO;
    self.featureLayer.borderColor = color;
    self.featureLayer.frame = faceRect;
}

- (IBAction)switchCameraClicked:(id)sender
{
    
    [self.videoCamera stop];
    if (self.videoCamera.defaultAVCaptureDevicePosition == AVCaptureDevicePositionFront)
    {
        self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    }
    
    else
    {
        self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    }
    
    [self.videoCamera start];
}


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [buffer appendData:data];
    NSLog(@"buffer %@",buffer);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    if(error == nil)
        {
            NSLog(@"Download is Succesfull");
            NSString *dataString = [[NSString alloc] initWithData:buffer encoding:NSASCIIStringEncoding];
            NSLog(@"In session task %@",dataString);
            NSString *comapre = @"Already Updated";
            
            if([dataString isEqualToString:comapre])
            {
                [self printTakenMessage];
            }
            else
            {
                [self printMessage];
            }
        
        }
    
    else
        
        NSLog(@"Error %@",[error userInfo]);
}

-(void) printMessage
{
    //   [alert dismissWithClickedButtonIndex:0 animated:YES];
    UIAlertView *alertPopUp = [[UIAlertView alloc] initWithTitle:nameAlert
                               message:@"Attendance Taken"
                               delegate:self cancelButtonTitle:@"ok"
                               otherButtonTitles:nil];
    [alertPopUp show];
    
   /* UIViewController *attendence =[[AttendanceTakenController alloc]initWithNibName:@"AttendanceTakenController" bundle:nil];
    
    [self presentViewController:attendence animated:YES completion:nil];
    */
}


-(void) printTakenMessage
{
    
 UIAlertView *alertPopUp = [[UIAlertView alloc] initWithTitle:nameAlert
                            message:@"Attendance already taken"
                            delegate:self cancelButtonTitle:@"OK"
                            otherButtonTitles:nil];
 
 [alertPopUp show];
     
     UIViewController *attendence =[[AttendanceTakenController alloc]initWithNibName:@"AttendanceTakenController" bundle:nil];
     [self presentViewController:attendence animated:YES completion:nil];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0)
    {
        exit(0);
    }
}

-(void)jsonCall:(NSString *)msg

{
    self.buffer = [NSMutableData data];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    instructionLabel.text=msg;
    
    NSLog(@"value %@",msg);
    
    [[session dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://172.23.186.201/iOS_Student/AttendanceUpdate.asmx/AttendeeAttendanceUpdate?updateName=%@",instructionLabel.text]]] resume];
}

@end



