//
//  AIFLocationManager.m
//  AIFMapLib
//
//  Created by moyazi on 2020/2/12.
//  Copyright © 2020 moyazi. All rights reserved.
//

#import "AIFLocationManager.h"
#import <CoreLocation/CLLocationManager.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface AIFLocationManager ()<AMapSearchDelegate,AMapLocationManagerDelegate>

@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, assign) CLLocationCoordinate2D currentLocationCoordinate2D;

@property (nonatomic, copy) void (^GetAddressSuccessBlock)(NSString *,NSString *, NSString *, NSString *, NSString *, id);
@property (nonatomic, copy) void (^GetAddressFailBlock)(void);

@property (nonatomic, copy) void (^GetCoordSuccessBlock)(CLLocationCoordinate2D coord);
@property (nonatomic, copy) void (^GetCoordFailBlock)(void);

@end

@implementation AIFLocationManager


- (void)getAddressFail{
    if (self.GetAddressFailBlock) {
        self.GetAddressFailBlock();
    }
    [self cleanAddressBlock];
}


- (void)getCoordFail{
    if (self.GetCoordFailBlock) {
        self.GetCoordFailBlock();
    }
    [self cleanCoordBlock];
}

- (void)cleanAddressBlock{
    self.GetAddressFailBlock = nil;
    self.GetAddressSuccessBlock = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(getAddressFail) object:nil];
}



- (void)cleanCoordBlock{
    self.GetCoordSuccessBlock = nil;
    self.GetCoordFailBlock = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(getCoordFail) object:nil];
}

- (void)getCurrentPhoneLocationSuccess:(void(^)(NSString *country, NSString *province,NSString *city,NSString *county,NSString *addressName,id addressObject,CLLocationCoordinate2D coordinate))success fail:(void(^)(void))fail;{
    
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error) {
            if (fail) {
                fail();
            }
            return ;
        }
        if (success) {
            success(regeocode.country,regeocode.province, regeocode.city, regeocode.district, regeocode.formattedAddress, regeocode, location.coordinate);
        }
    }];

}

- (void)getAddressInfoByCoordinate:(CLLocationCoordinate2D)coordinate
                           success:(void (^)(NSString *country, NSString *, NSString *, NSString *, NSString *, id))success
                              fail:(void (^)(void))fail{
    if (self.GetAddressSuccessBlock) {
        [self cleanAddressBlock];
    }
    self.GetAddressSuccessBlock = success;
    self.GetAddressFailBlock = fail;
    [self performSelector:@selector(getAddressFail) withObject:nil afterDelay:3];
    
    //初始化请求参数类AMapReGeocodeSearchRequest的实例
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];

    regeo.location                    = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension            = YES;
    [self.search AMapReGoecodeSearch:regeo];
}

- (void)getCoordByAddress:(NSString *)address
                  success:(void (^)(CLLocationCoordinate2D))success
                     fail:(void (^)(void))fail{
    if (self.GetCoordSuccessBlock) {
        [self cleanCoordBlock];
    }
    self.GetCoordSuccessBlock = success;
    self.GetCoordFailBlock = fail;
    [self performSelector:@selector(getCoordFail) withObject:nil afterDelay:3];
    
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = address;
    [self.search AMapGeocodeSearch:geo];
}
#pragma mark - <BMKSuggestionSearchDelegate>
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    if (response.geocodes.count == 0)
    {
        return;
    }
    AMapGeocode *result = response.geocodes.firstObject;
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(result.location.latitude, result.location.longitude);
    if (self.GetCoordSuccessBlock) {
        self.GetCoordSuccessBlock(coor);
    }
    [self cleanCoordBlock];
}

#pragma mark - <AMapSearchDelegate>
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response;{
    if (response.pois.count == 0)
    {
        return;
    }
    
    AMapPOI *poi = response.pois[0];
    if (poi) {
        
        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
        if (self.GetCoordSuccessBlock) {
            self.GetCoordSuccessBlock(coor);
        }
        [self cleanCoordBlock];
    }
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    
    if (response.regeocode != nil)
    {
        AMapReGeocode *result = response.regeocode;
        
        if (self.GetAddressSuccessBlock && result) {
            self.GetAddressSuccessBlock(result.addressComponent.country,result.addressComponent.province, result.addressComponent.city, result.addressComponent.district, result.formattedAddress, result);
        }
        [self cleanAddressBlock];
    }
}
#pragma mark - init
+ (id)shareInstance{
    static AIFLocationManager *static_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        static_manager = [[AIFLocationManager alloc]init];
        [static_manager search];
        [static_manager locationManager];
    });
    return static_manager;
}

- (AMapSearchAPI *)search{
    if (!_search) {
        AMapSearchAPI *search = [[AMapSearchAPI alloc]init];
        search.delegate = self;
        _search = search;
    }
    return _search;
}

- (AMapLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc]init];
        _locationManager.delegate = self;
        
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.pausesLocationUpdatesAutomatically = YES;
        _locationManager.allowsBackgroundLocationUpdates = NO;
        _locationManager.locationTimeout = 6;
        _locationManager.reGeocodeTimeout = 3;
    }
    return _locationManager;
}




#pragma mark  - 定位权限
+ (void)requestLocationAuthorization{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
}


+ (BOOL)isAPPLocationAuthorizationStatus{
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
        //定位功能可用
        return YES;
        
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        //定位不能用
        return NO;
    }
    return NO;
}

+ (void)showLocationAuthorizationError{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                             message:@"添加设备需要使用位置信息，现在去开启定位权限？" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //跳转到定位权限页面
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if( [[UIApplication sharedApplication]canOpenURL:url] ) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
    }]];

    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appdelegate.window.rootViewController presentViewController:alertController animated:true completion:nil];
}
@end
