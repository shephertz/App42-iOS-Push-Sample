//
//  ViewController.m
//  App42PushNotificationSample
//
//  Created by Rajeev Ranjan on 29/07/13.
//  Copyright (c) 2013 ShepHertz Technologies Pvt Ltd. All rights reserved.
//

#import "ViewController.h"
#import "Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize deviceToken;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


-(IBAction)sendPushButtonAction:(id)sender
{
    [self sendPush:@"Hello, Ur Friend has poked you!" toUser:@"User Name"];
}

-(void)sendPush:(NSString*)message toUser:(NSString*)userName
{
    @try
    {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:message forKey:@"alert"];
        [dictionary setObject:@"default" forKey:@"sound"];
        [dictionary setObject:@"2" forKey:@"badge"];
        
        PushNotificationService *pushObj=[App42API buildPushService];
        [pushObj sendPushMessageToUser:userName withMessageDictionary:dictionary];
        [pushObj release];
    }
    @catch (App42Exception *exception)
    {
        NSLog(@"Reason = %@",exception.reason);
    }
    @finally
    {
        
    }
}


-(void)subscribeChannel:(NSString*)channelName toUser:(NSString*)userName
{
    @try
    {
        PushNotificationService *pushObj=[App42API buildPushService];
        [pushObj subscribeToChannel:channelName userName:userName deviceToken:deviceToken deviceType:@"iOS"];
        [pushObj release];
    }
    @catch (App42Exception *exception)
    {
        NSLog(@"Reason = %@",exception.reason);
    }
    @finally
    {
        
    }

}

-(void)sendPush:(NSString*)message toChannel:(NSString*)channelName
{
    @try
    {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:message forKey:@"alert"];
        [dictionary setObject:@"default" forKey:@"sound"];
        [dictionary setObject:@"2" forKey:@"badge"];
        
        PushNotificationService *pushObj=[App42API buildPushService];
        [pushObj sendPushMessageToChannel:channelName withMessageDictionary:dictionary];
        [pushObj release];
    }
    @catch (App42Exception *exception)
    {
        NSLog(@"Reason = %@",exception.reason);
    }
    @finally
    {
        
    }
    
}




-(void)setEvent:(NSString*)eventName forModule:(NSString*)module
{
    NSLog(@"%s",__FUNCTION__);
    
    @try
    {
        LogService *logService = [App42API buildLogService];
        [logService setEventWithName:eventName forModule:module];
        [logService release];
    }
    @catch (App42Exception *exception)
    {
        NSLog(@"Description=%@",exception.reason);
    }
    @finally
    {
        
    }
}


-(void)updatePushMessageLabel:(NSString*)message
{
    pushNotification.text = message;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
