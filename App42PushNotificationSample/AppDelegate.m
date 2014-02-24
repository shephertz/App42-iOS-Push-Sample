//
//  AppDelegate.m
//  App42PushNotificationSample
//
//  Created by Rajeev Ranjan on 29/07/13.
//  Copyright (c) 2013 ShepHertz Technologies Pvt Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h"

#define APP42_APP_KEY       @"3c1d8c1d23e1dde0d820b06e33e6260e3b9ac0438d522a4ac9d524fc12cb8559"
#define APP42_SECRET_KEY    @"254964c8a7fcc95cee0362adc2e0e06e0a64ec53c7a9e5279c11b3c4303edf73"


@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil] autorelease];
    }
    else
    {
        self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil] autorelease];
    }
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    [App42API initializeWithAPIKey:APP42_APP_KEY andSecretKey:APP42_SECRET_KEY];
    [App42API setCacheStoragePolicy:0];
    [App42API enableApp42Trace:YES];
    // Let the device know we want to receive push notifications
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    return YES;
}


///**
// * You have to register your device token to App42 server to receive push notification
// */
//-(void)registerDeviceTokenToApp42Server:(NSString*)deviceToken
//{
//    @try
//    {
//        PushNotificationService *pushObj=[App42API buildPushService];
//        [pushObj registerDeviceToken:deviceToken withUser:@"IPhoneTesting"];
//        [pushObj release];
//    }
//    @catch (App42Exception *exception)
//    {
//        NSLog(@"Reason = %@",exception.reason);
//    }
//    @finally
//    {
//        
//    }
//}


-(void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"My token is: %@", deviceToken);
    // Prepare the Device Token for Registration (remove spaces and < >)
	NSString *devToken = [[[[deviceToken description]
                            stringByReplacingOccurrencesOfString:@"<"withString:@""]
                           stringByReplacingOccurrencesOfString:@">" withString:@""]
                          stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    NSLog(@"My token is: %@", devToken);
   
    [_viewController setDeviceToken:devToken];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
        NSLog(@"%s ..error=%@",__FUNCTION__,error);
    [_viewController setDeviceToken:@"b1d6b70a7fe5a29be43b823f7bd3aa072f60d849c931b3465915773b835f00f3"];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"%s ..userInfo=%@",__FUNCTION__,userInfo);
    [_viewController setEvent:@"Push Delivered" forModule:@"Push"];
    [_viewController updatePushMessageLabel:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]];
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

@end
