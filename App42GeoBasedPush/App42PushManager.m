//
//  App42PushManager.m
//  App42PushSample
//
//  Created by Rajeev Ranjan on 03/03/15.
//  Copyright (c) 2015 Rajeev Ranjan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "App42PushManager.h"

#define APP42_GEOBASE           @"app42_geoBase"
#define APP42_ADDRESSBASE       @"addressBase"
#define APP42_COORDINATEBASE    @"coordinateBase"
#define APP42_COUNTRYCODE       @"app42_countryCode"
#define APP42_COUNTRYNAME       @"app42_countryName"
#define APP42_STATENAME         @"app42_stateName"
#define APP42_CITYNAME          @"app42_cityName"
#define APP42_DISTANCE          @"app42_distance"

#define APP42_PUSH_MESSAGE      @"app42_message"
#define APP42_LONGITUDE         @"app42_lng"
#define APP42_LATITUDE          @"app42_lat"
#define APP42_RADIUS            @"app42_distance"
#define APP42_LOC_IDENTIFIER    @"APP42_LOC_IDENTIFIER"

typedef void (^App42FetchCompletion)(UIBackgroundFetchResult);

@interface App42PushManager ()
{
    App42FetchCompletion fetchCompletion;
}
@property(nonatomic) CLLocationManager *locManager;
@property(nonatomic) NSDictionary *pushMessageDict;

-(void)requestToAccessLocation;
-(BOOL)isApp42GeoBasedPush:(NSDictionary*)userInfo;
-(BOOL)isEligibleForNotificationWithCoordinate:(CLLocation*)newLocation;
-(void)showNotificationIfEligibleWithAddress:(CLLocation*)newLocation;
-(void)scheduleNotificationWithMessage:(NSString*)pushMessage;

@end

@implementation App42PushManager

+(instancetype)sharedManager
{
    static App42PushManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self requestToAccessLocation];
    }
    return self;
}

-(void)requestToAccessLocation
{
    NSLog(@"%s",__func__);
    if (!_locManager)
    {
        _locManager= [[CLLocationManager alloc] init];
    }
    _locManager.delegate = self;
    
    // request authorization to track the user’s location
    [_locManager requestAlwaysAuthorization];
}

-(void)handleGeoBasedPush:(NSDictionary*)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSString *geoBaseType = [userInfo objectForKey:APP42_GEOBASE];
    if (geoBaseType) {
        self.pushMessageDict = userInfo;
        fetchCompletion = completionHandler;
        [_locManager startUpdatingLocation];
    }
    else
    {
        completionHandler(UIBackgroundFetchResultNoData);
    }
}

#pragma mark- Location Manager Delegates
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"%s",__func__);
    // check status to see if we’re authorized
    BOOL canUseLocationNotifications = (status == kCLAuthorizationStatusAuthorizedAlways);
    if (canUseLocationNotifications)
    {
        NSLog(@"%s   SUCCESS",__func__);
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"%s",__func__);
    [_locManager stopUpdatingLocation];
    CLLocation *newLocation = [locations lastObject];
    
    NSString *geoBaseType = [_pushMessageDict objectForKey:APP42_GEOBASE];
    if ([geoBaseType isEqualToString:APP42_COORDINATEBASE])
    {
        if ([self isEligibleForNotificationWithCoordinate:newLocation])
        {
            [self scheduleNotificationWithMessage:[_pushMessageDict objectForKey:APP42_PUSH_MESSAGE]];
        }
        else
        {
            NSLog(@".....Not in the region");
        }
        // Turn off the location manager to save power.
        fetchCompletion(UIBackgroundFetchResultNoData);
    }
    else if ([geoBaseType isEqualToString:APP42_ADDRESSBASE])
    {
        [self showNotificationIfEligibleWithAddress:newLocation];
    }
    else
    {
        // Turn off the location manager to save power.
        fetchCompletion(UIBackgroundFetchResultNoData);
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Cannot find the location.");
     [_locManager stopUpdatingLocation];
    fetchCompletion(UIBackgroundFetchResultNoData);
}


#pragma mark- Others

-(BOOL)isApp42GeoBasedPush:(NSDictionary*)userInfo
{
    BOOL isGeoBasedPush = NO;
    NSString *geoBaseType = [userInfo objectForKey:APP42_GEOBASE];
    
    if (geoBaseType)
    {
        isGeoBasedPush = YES;
    }
    NSLog(@"%s isGeoBasedPush= %d",__func__,isGeoBasedPush);
    return isGeoBasedPush;
}


-(BOOL)isEligibleForNotificationWithCoordinate:(CLLocation*)newLocation
{
    NSLog(@"%s",__func__);
    
    CLLocationCoordinate2D center;
    center.longitude = [[_pushMessageDict objectForKey:APP42_LONGITUDE] doubleValue];
    center.latitude  = [[_pushMessageDict objectForKey:APP42_LATITUDE] doubleValue];
    
    CLLocationDistance radius = [[_pushMessageDict objectForKey:APP42_RADIUS] doubleValue];
    
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:center radius:radius identifier:@"App42Fence"];
    
    return [region containsCoordinate:newLocation.coordinate];
}

-(void)showNotificationIfEligibleWithAddress:(CLLocation*)newLocation
{
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error == nil && [placemarks count] >0)
        {
            BOOL isEligible = NO;
            CLPlacemark *placemark = [placemarks lastObject];
            
            NSString *state, *country,*city;
            state = placemark.administrativeArea;
            country = placemark.ISOcountryCode;
            city = placemark.locality;
            
            NSString *countryForPush,*stateForPush,*cityForPush;
            stateForPush = [_pushMessageDict objectForKey:APP42_STATENAME];
            countryForPush = [_pushMessageDict objectForKey:APP42_COUNTRYCODE];
            cityForPush = [_pushMessageDict objectForKey:APP42_CITYNAME];
            
            if (countryForPush && [countryForPush isEqualToString:country])
            {
                if (stateForPush && [stateForPush isEqualToString:state])
                {
                    if (cityForPush && [cityForPush isEqualToString:city])
                    {
                        isEligible = YES;
                    }
                    else if(!cityForPush)
                    {
                        isEligible = YES;
                    }
                }
                else if(!stateForPush)
                {
                    isEligible = YES;
                }
            }
            
            if (isEligible)
            {
                [self scheduleNotificationWithMessage:[_pushMessageDict objectForKey:APP42_PUSH_MESSAGE]];
            }
            else
            {
                NSLog(@"%s.....Not in the region",__func__);
            }
            
            // Turn off the location manager to save power.
            //[_locManager stopUpdatingLocation];
            fetchCompletion(UIBackgroundFetchResultNoData);
            
        }
        else
        {
            NSLog(@"%@", error.debugDescription);
        }
    }];
}

-(void)scheduleNotificationWithMessage:(NSString*)pushMessage
{
    NSLog(@"%s",__func__);
    UILocalNotification *locNotification = [[UILocalNotification alloc] init];
    locNotification.alertBody = pushMessage;
    locNotification.soundName = UILocalNotificationDefaultSoundName;
    locNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
    locNotification.repeatInterval = 0;
    [[UIApplication sharedApplication] scheduleLocalNotification:locNotification];
}


@end
