//
//  AppDelegate+MyApp.m
//  App42PushNotificationSample
//
//  Created by Rajeev Ranjan on 02/08/13.
//  Copyright (c) 2013 ShepHertz Technologies Pvt Ltd. All rights reserved.
//

#import "AppDelegate+MyApp.h"

@implementation AppDelegate (MyApp)
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"%s .. My token is: %@",__FUNCTION__, deviceToken);
    // Prepare the Device Token for Registration (remove spaces and < >)
	NSString *devToken = [[[[deviceToken description]
                            stringByReplacingOccurrencesOfString:@"<"withString:@""]
                           stringByReplacingOccurrencesOfString:@">" withString:@""]
                          stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    NSLog(@"My token is: %@", devToken);
    
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"%s ..error=%@",__FUNCTION__,error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"%s ..userInfo=%@",__FUNCTION__,userInfo);
}


@end
