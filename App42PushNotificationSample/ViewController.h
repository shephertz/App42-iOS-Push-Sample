//
//  ViewController.h
//  App42PushNotificationSample
//
//  Created by Rajeev Ranjan on 29/07/13.
//  Copyright (c) 2013 ShepHertz Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    IBOutlet UILabel *pushNotification;
    IBOutlet UITextView *responseView;
    IBOutlet UITextField *valueView;
    IBOutlet UIActivityIndicatorView *indicator;
    NSMutableArray *docIDArray;
}

@property(nonatomic,retain) NSString *deviceToken;

-(IBAction)sendPushButtonAction:(id)sender;
-(void)updatePushMessageLabel:(NSString*)message;
-(void)setEvent:(NSString*)eventName forModule:(NSString*)module;
-(IBAction)addItem:(id)sender;
-(IBAction)getItems:(id)sender;
-(IBAction)deleteData:(id)sender;
@end
