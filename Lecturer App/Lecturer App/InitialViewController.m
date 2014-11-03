//
//  InitialViewController.m
//  Lecturer App
//
//  Created by Kailash Ramachandran on 4/7/14.
//  Copyright (c) 2014 Team-7. All rights reserved.
//

#import "InitialViewController.h"
#include "StudentViewController.h"

@interface InitialViewController ()

@end

@implementation InitialViewController

@synthesize studID,buffer,classDate,activityIndicatorView;

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
	// Do any additional setup after loading the view, typically from a nib.
    studID.delegate=self;
    classDate.delegate=self;
    self.activityIndicatorView.hidesWhenStopped=YES;
    self.studData=NULL;
    
   
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:@"UIKeyboardWillShowNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:@"UIKeyboardDidHideNotification"
                                               object:nil];
    
}

- (void) keyboardWillShow:(NSNotification *)note {
    NSDictionary *userInfo = [note userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    NSLog(@"Keyboard Height: %f Width: %f", kbSize.height, kbSize.width);
    
    // move the view up by 30 pts
    CGRect frame = self.view.frame;
    frame.origin.y = -50;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = frame;
    }];
}

- (void) keyboardDidHide:(NSNotification *)note {
    
    // move the view back to the origin
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = frame;
    }];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // uncomment for non-ARC:
    // [super dealloc];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [studID resignFirstResponder];
    [classDate resignFirstResponder];
    return YES;
}

-(void) exitApp
{
    exit(0);
}

-(void)markAttendance
{
    [studID resignFirstResponder];
    [self jsonCall];
    [activityIndicatorView startAnimating];
}

-(void)getAttendeesList{
    
    [classDate resignFirstResponder];
    [self jsonRetrieve];
    NSLog(@"Date value in getatt is %@",classDate);
}

-(void)jsonCall

{
    self.buffer = [NSMutableData data];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    [[session dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://172.23.186.201/iOS_Student/AttendanceUpdate.asmx/AttendeeAttendanceUpdate?updateName=%@",studID.text]]] resume];
    [activityIndicatorView stopAnimating];
}

-(void)jsonRetrieve

{
    self.buffer = [NSMutableData data];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSLog(@"Data Valus is %@",classDate);
    [[session dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://172.23.186.201/iOS_Lecturer/AttendeeFetch.asmx/AttendeeList?classDate=%@",classDate.text ]]] resume];
    [activityIndicatorView stopAnimating];
}

-(NSString*) retDate
{
    return classDate.text;
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data

{
    [buffer appendData:data];
    
    NSLog(@"buffer %@",buffer);
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error

{
    if(error == nil)
        
    {
        NSLog(@"Download is Succesfull");
        NSString *dataString = [[NSString alloc] initWithData:buffer encoding:NSASCIIStringEncoding];
        NSLog(@"In session task %@",dataString);
        
        if (![studID.text isEqualToString:@""]) {
            
            if([dataString isEqualToString:@"\"Attendance Taken\""])
            {
                [self printMessage];
                classDate.text=@"";
            }
            else if([dataString isEqualToString:@"Already Updated"]){
                [self printTakenMessage];
                classDate.text=@"";
            }
            
        }
        
        if (![classDate.text isEqualToString:@""]){
            NSString *formattedData=[dataString stringByReplacingOccurrencesOfString:@"\",\"" withString:@"\n"];
            formattedData=[formattedData stringByReplacingOccurrencesOfString:@"[\"" withString:@""];
            formattedData=[formattedData stringByReplacingOccurrencesOfString:@"\"]" withString:@"\n"];
            NSLog(@"Data %@",formattedData);
            classDate.text=@"";
            self.studData = [formattedData componentsSeparatedByString:@"\n"];
            NSLog(@"Student Data is %@",[self studData]);
            
            
            StudentViewController *st = [[StudentViewController alloc] initWithNibName:@"StudentViewController" bundle:nil];
            st.studArray=[self studData];
            NSLog(@"studArray is %@",st.studArray);
            [self presentViewController:st animated:YES completion:nil];
            
            
        }
    }
    else
    {
        NSLog(@"Error %@",[error userInfo]);
    }
}

-(void) printMessage

{
    [self.activityIndicatorView stopAnimating];
    self.activityIndicatorView.hidesWhenStopped=YES;
    NSString *studName=studID.text;
    UIAlertView *alertPopUp = [[UIAlertView alloc] initWithTitle:studName
                                                         message:@"Attendance Taken"
                                                        delegate:self cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
    [alertPopUp show];
    studID.text =@"";
    
}


-(void) printTakenMessage

{
    [self.activityIndicatorView stopAnimating];
    self.activityIndicatorView.hidesWhenStopped=YES;
    
    UIAlertView *alertPopUp = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                         message:@"Attendance already taken"
                                                        delegate:self cancelButtonTitle:@"ok"
                                               otherButtonTitles:nil];
    [alertPopUp show];
    studID.text =@"";
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
