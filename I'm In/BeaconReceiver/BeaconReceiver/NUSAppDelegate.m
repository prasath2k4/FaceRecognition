//
//  NUSAppDelegate.m
//  BeaconReceiver
//
//  Created by Team-7

#import "NUSAppDelegate.h"
#import "Reachability.h"

@implementation NUSAppDelegate
@synthesize nusView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*
    //Reachability *reach=[Reachability reachabilityWithHostName:@"google.co.in"];
    //NetworkStatus nwstatus=[ reach currentReachabilityStatus];
    //if (nwstatus==ReachableViaWiFi|| nwstatus==ReachableViaWWAN)
    bool success = false;
    
    const char *hostName = [@"172.23.185.197"
                           cStringUsingEncoding:NSASCIIStringEncoding];
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL,
    																			hostName);
    SCNetworkReachabilityFlags flags;
    success = SCNetworkReachabilityGetFlags(reachability,&flags);
    bool isAvailable = success && (flags & kSCNetworkFlagsReachable) &&
    !(flags & kSCNetworkFlagsConnectionRequired);
    if(isAvailable)
    {
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)];
    NSLog(@"registerForRemoteNotificationTypes");
    return YES;
    }
    else
    {
        {
            UIAlertView *alert=[[UIAlertView alloc]
                                initWithTitle:@"Alert" message:@"Not authorised to use the app" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.tag=101;
            [alert show];
            return NO;
        }
    }
     */
    
    return YES;
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0)
    {
        exit(0);
    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"My token is: %@", deviceToken);
}
 
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Failed to get token, error: %@", error);
}
                                                                           
                                                                           
@end
