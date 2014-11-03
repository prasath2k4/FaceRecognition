//
//  NUSViewController.h
//  BeaconReceiver
//
//  Created by Team-7

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "NUSSampleViewController.h"

@interface NUSViewController : UIViewController<CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblBeaconFound;
@property (weak, nonatomic) IBOutlet UILabel *lblUUID;
@property (weak, nonatomic) IBOutlet UILabel *lblMajor;
@property (weak, nonatomic) IBOutlet UILabel *lblMinor;
@property (weak, nonatomic) IBOutlet UILabel *lblAccuracy;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
@property (weak, nonatomic) IBOutlet UILabel *lblRSSI;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;

@property (strong, nonatomic) UILocalNotification *localNotification;
//UI setting
@property(nonatomic, assign) UIColor* borderUIColor;


@end
