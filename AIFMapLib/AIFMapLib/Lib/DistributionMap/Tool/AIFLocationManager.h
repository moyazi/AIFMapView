//
//  AIFLocationManager.h
//  AIFMapLib
//
//  Created by moyazi on 2020/2/12.
//  Copyright © 2020 moyazi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface AIFLocationManager : NSObject

+ (BOOL)isAPPLocationAuthorizationStatus;
+ (void)showLocationAuthorizationError;
+ (void)requestLocationAuthorization;


+ (id)shareInstance;

- (void)getCurrentPhoneLocationSuccess:(void(^)(NSString *country, NSString *province,NSString *city,NSString *county,NSString *addressName,id addressObject,CLLocationCoordinate2D coordinate))success fail:(void(^)(void))fail;

- (void)getAddressInfoByCoordinate:(CLLocationCoordinate2D)coordinate
                           success:(void(^)(NSString *country, NSString *province,NSString *city,NSString *county,NSString *addressName,id addressObject))success
                              fail:(void(^)(void))fail;
- (void)getCoordByAddress:(NSString *)address
                  success:(void(^)(CLLocationCoordinate2D coord))success
                     fail:(void(^)(void))fail;

@end

NS_ASSUME_NONNULL_END
