//
//  ViewController.m
//  App42PushNotificationSample
//
//  Created by Rajeev Ranjan on 29/07/13.
//  Copyright (c) 2013 ShepHertz Technologies Pvt Ltd. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()
{
    NSString *userName;
}
@end

@implementation ViewController
@synthesize deviceToken;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    indicator.hidden = YES;
    storageService = [App42API buildStorageService];
    userName = @"";
}


-(IBAction)registerDeviceToken:(id)sender 
{
    if (userNameTextField.isFirstResponder)
    {
        [userNameTextField resignFirstResponder];
    }
    indicator.hidden = NO;
    [indicator startAnimating];
    userName = userNameTextField.text;
    userName = [userName stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (userName.length)
    {
        @try
        {
            /***
             * Registering Device Token to App42 Cloud API
             */
            PushNotificationService *pushObj=[App42API buildPushService];
            PushNotification *push = [pushObj registerDeviceToken:deviceToken withUser:userName];
            responseView.text = push.strResponse;
            [pushObj release];
        }
        @catch (App42Exception *exception)
        {
            NSLog(@"Reason = %@",exception.reason);
            responseView.text = exception.reason;
        }
        @finally
        {
            
        }
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please, enter the user name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [self.view addSubview:alertView];
        [alertView show];
    }

    [indicator stopAnimating];
    indicator.hidden = YES;
}


-(IBAction)sendPushButtonAction:(id)sender
{
    if (userNameTextField.isFirstResponder)
    {
        [userNameTextField resignFirstResponder];
    }
    userName = userNameTextField.text;
    userName = [userName stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (userName.length)
    {
        [self sendPush:@"Hello, Ur Friend has poked you!" toUser:userName];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please, enter the user name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [self.view addSubview:alertView];
        [alertView show];
    }
}

-(void)sendPush:(NSString*)message toUser:(NSString*)_userName
{
    @try
    {
        indicator.hidden = NO;
        [indicator startAnimating];
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:message forKey:@"alert"];
        [dictionary setObject:@"default" forKey:@"sound"];
        [dictionary setObject:[NSNumber numberWithInt:1] forKey:@"badge"];
        
        PushNotificationService *pushObj=[App42API buildPushService];
        PushNotification *push = [pushObj sendPushMessageToUser:_userName withMessageDictionary:dictionary];
        responseView.text = push.strResponse;
        [indicator stopAnimating];
        indicator.hidden = YES;

        [pushObj release];
    }
    @catch (App42Exception *exception)
    {
        NSLog(@"Reason = %@",exception.reason);
        responseView.text = exception.reason;
    }
    @finally
    {
        
    }
}


-(void)subscribeChannel:(NSString*)channelName toUser:(NSString*)_userName
{
    @try
    {
        PushNotificationService *pushObj=[App42API buildPushService];
        [pushObj subscribeToChannel:channelName userName:_userName deviceToken:deviceToken deviceType:@"iOS"];
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
