//
//  NUSViewController.m
//  BeaconReceiver
//
//  Created by Team-7

#import "NUSViewController.h"

@interface NUSViewController ()
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (strong,nonatomic) CLBeaconRegion *beaconRegion;
@end

@implementation NUSViewController
@synthesize localNotification;

//UI Setting


//UI Setting

- (void)viewDidLoad
{
 
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage //imageNamed:@"page_view_controller_2x.png"]]];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    NSUUID *proxmitityUUID = [[NSUUID alloc] initWithUUIDString:@"3AE96580-33DB-458B-8024-2B3C63E0E920"];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proxmitityUUID identifier:@"classRegion"];
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    localNotification = [[UILocalNotification alloc] init];
    
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{

    NSLog(@"locationManager:didEnterRegion");
    self.lblStatus.text = @"Enter region";
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    //UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = @"You have entered the classroom, please mark you attendance";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.alertAction = @"Details";
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"locationManager:didExitRegion");
    self.lblStatus.text = @"Exist Region";
    self.lblBeaconFound.text = @"NO";
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
   // UILocalNotification *localNotification1 = [[UILocalNotification alloc] init];
    localNotification.alertBody = @"You have left the classroom, Thanks!";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.alertAction = @"Details";
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    NSLog(@"locationManager:didRangeBeacons:inRegion");
    CLBeacon *beacon = [beacons lastObject];
    self.lblBeaconFound.text = @"Yes";
    self.lblUUID.text = beacon.proximityUUID.UUIDString;
    self.lblMajor.text = [NSString stringWithFormat:@"%@", beacon.major];
    self.lblMinor.text = [NSString stringWithFormat:@"%@", beacon.minor];
    self.lblAccuracy.text = [NSString stringWithFormat:@"%f meters", beacon.accuracy];
    switch (beacon.proximity) {
        case CLProximityUnknown:
            self.lblDistance.text = @"Unknown Proximity";
            break;
        case CLProximityImmediate:
            self.lblDistance.text = @"Immediate";
            break;
        case CLProximityNear:
            self.lblDistance.text = @"Near";
            break;
        case CLProximityFar:
            self.lblDistance.text = @"Far";
            break;
    }
    self.lblRSSI.text = [NSString stringWithFormat:@"%li decibels", (long)beacon.rssi];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"locationManager:didUpdateToLocation:newLocation:fromLocation");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"locationManager:didUpdateLocations");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    NSLog(@"locationManager:didUpdateHeading");
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    NSLog(@"locationManager:didDetermineState:forRegion");
    CLBeaconRegion *beaconRegion = ( CLBeaconRegion *)region;
    NSLog(@"UUID is : %@", beaconRegion.proximityUUID.UUIDString);
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error
{
    NSLog(@"locationManager:rangingBeaconsDidFailForRegion:region:withError");
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"locationManager:didFailWithError");
}

@end
