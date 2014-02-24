//
//  ViewController.m
//  App42PushNotificationSample
//
//  Created by Rajeev Ranjan on 29/07/13.
//  Copyright (c) 2013 ShepHertz Technologies Pvt Ltd. All rights reserved.
//

#import "ViewController.h"
#import "Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h"

#define DOC_NAME @"jsonDocument2"
#define COLLECTION_NAME @"TestDoc"

@interface ViewController ()

@end

@implementation ViewController
@synthesize deviceToken;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    indicator.hidden = YES;
    docIDArray = nil;
}


-(IBAction)registerDeviceToken:(id)sender 
{
    
    
    if (valueView.isFirstResponder)
    {
        [valueView resignFirstResponder];
    }
    indicator.hidden = NO;
    [indicator startAnimating];
    {
        @try
        {
            PushNotificationService *pushObj=[App42API buildPushService];
            PushNotification *push = [pushObj registerDeviceToken:deviceToken withUser:@"IPhoneTesting"];
            responseView.text = push.strResponse;
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
    
    [indicator stopAnimating];
    indicator.hidden = YES;
}


-(IBAction)sendPushButtonAction:(id)sender
{
    [self sendPush:@"Hello, Ur Friend has poked you!" toUser:@"IPhoneTesting"];
}

-(void)sendPush:(NSString*)message toUser:(NSString*)userName
{
    @try
    {
        indicator.hidden = NO;
        [indicator startAnimating];
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:message forKey:@"alert"];
        [dictionary setObject:@"default" forKey:@"sound"];
        [dictionary setObject:@"2" forKey:@"badge"];
        
        PushNotificationService *pushObj=[App42API buildPushService];
        PushNotification *push = [pushObj sendPushMessageToUser:userName withMessageDictionary:dictionary];
        responseView.text = push.strResponse;
        [indicator stopAnimating];
        indicator.hidden = YES;

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
-(IBAction)getItems:(id)sender
{
    if (docIDArray)
    {
        [docIDArray release];
        docIDArray = nil;
    }
    docIDArray = [[NSMutableArray alloc] initWithCapacity:0];
    indicator.hidden = NO;
    [indicator startAnimating];
    if (valueView.isFirstResponder)
    {
        [valueView resignFirstResponder];
    }
    StorageService *storageService = [App42API buildStorageService];
    Storage *storage=[storageService findAllDocuments:DOC_NAME collectionName:COLLECTION_NAME];
    responseView.text = storage.strResponse;
    int count = [[storage jsonDocArray] count];
    for (int i=0; i<count; i++)
    {
        [docIDArray addObject:[[[storage jsonDocArray] objectAtIndex:i] docId]];
    }
    [indicator stopAnimating];
    indicator.hidden = YES;
}

-(IBAction)deleteData:(id)sender
{
    indicator.hidden = NO;
    [indicator startAnimating];
    StorageService *storageService = [App42API buildStorageService];
    
    for (int i=0; i<[docIDArray count]-2; i++)
    {
        App42Response *response = [storageService deleteDocumentById:DOC_NAME collectionName:COLLECTION_NAME docId:[docIDArray objectAtIndex:i]];
        responseView.text = response.strResponse;
    }
    [indicator stopAnimating];
    indicator.hidden = YES;
}

@end
