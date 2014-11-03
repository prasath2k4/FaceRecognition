//
//  StudentViewController.m
//  Lecturer App
//
//  Created by Kailash Ramachandran on 4/7/14.
//  Copyright (c) 2014 Team-7. All rights reserved.
//

#import "StudentViewController.h"
#import "InitialViewController.h"

@interface StudentViewController ()

@end

@implementation StudentViewController
@synthesize ic=_ic;
@synthesize studArray,window;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)goBack
{
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //self.vc= [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    //[self presentViewController:vc animated:YES completion:nil];
    //[self.navigationController pushViewController:vc animated:YES];
    self.window.rootViewController=self.ic;
    [self.window makeKeyAndVisible];
    //   [window addSubview:[self.vc view]];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // UIStoryboard *sboard = [UIStoryboard storyboardWithName:@"Main"
    //      bundle:nil];
    // ViewController *vc = [sboard instantiateInitialViewController];
    //self.vc = [sboard instantiateInitialViewController];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.ic= [[InitialViewController alloc] initWithNibName:@"InitialViewController" bundle:nil];
    //self.newStudArray=studArray;
    NSLog(@"New Stud Array is %@",studArray);
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     if(studArray.count==1 && [[studArray objectAtIndex:0]isEqualToString:@"[]"])
     {
         UIAlertView *alertPopUp = [[UIAlertView alloc] initWithTitle:@"Attenees Data"
                                                              message:@"No attendees"
                                                             delegate:self cancelButtonTitle:@"ok"
                                                    otherButtonTitles:nil];
         [alertPopUp show];
         
     }
    return [self.studArray count];
   
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0)
    {
        [self goBack];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if([[self.studArray objectAtIndex:0]isEqualToString:@"[]"])
        {
            cell.textLabel.text=nil;
            return cell;
        }
    else
    {
    cell.textLabel.text = [self.studArray objectAtIndex:indexPath.row];
    return cell;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
