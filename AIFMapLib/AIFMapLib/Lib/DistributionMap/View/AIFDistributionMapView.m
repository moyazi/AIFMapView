//
//  AIFDistributionMapView.m
//  AI_Farming
//
//  Created by moyazi on 2020/1/9.
//  Copyright © 2020 het. All rights reserved.
//

#import "AIFDistributionMapView.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "AIFMapTypeSelectView.h"
#import "CommonHeader.h"

@interface AIFDistributionMapView  ()<MAMapViewDelegate,AMapSearchDelegate,AMapLocationManagerDelegate>
@property (copy, nonatomic) MAAnnotationView*(^viewForAnotationBlock) (MAMapView *,id<MAAnnotation> annotation);
@property (copy, nonatomic) MAOverlayRenderer*(^rendererForOverlayBlock) (MAMapView *,id<MAOverlay> overlay);

@property (copy, nonatomic) void (^mapDidZoomByUser)(MAMapView *,BOOL);
@property (copy, nonatomic) void (^didSelectAnnotationView)(MAMapView *,MAAnnotationView*);
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;

@property (nonatomic, strong) AMapLocationManager *locationManager;//位置定位服务
@property (nonatomic, strong) MAUserLocation *userLocation; //当前位置对象
@property (nonatomic, strong) UIButton *currentLocationBtn;//当前位置按钮
@property (strong, nonatomic) UIButton *mapTypeBtn;//切换地图类型按钮
@property (strong, nonatomic) AIFMapTypeSelectView *mapTypeSelectView;
@property (assign, nonatomic) MAMapType currentMapType;
@property (nonatomic, assign) CLLocationCoordinate2D currentLocationCoordinate2D;
@end

@implementation AIFDistributionMapView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
        [self setupEvents];
    }
    return self;
}

- (void)setupEvents{
    self.currentMapType = 1;
    [self.locationManager startUpdatingLocation];//开启定位服务
}


- (void)configUI{
    [self addSubview:self.mapView];
    [self addSubview:self.currentLocationBtn];
    [self addSubview:self.mapTypeBtn];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.currentLocationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.bottom.equalTo(self).offset(-50-IPX_HOMEINDICATORHEIGHT);
        make.width.height.mas_equalTo(40*iPhone6BasicWidth);
    }];
    
    [self.mapTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(self).offset(50);
        make.width.height.mas_equalTo(34*iPhone6BasicWidth);
    }];
}


-(void)setZoomLevel:(NSInteger)zoomLevel{
    [self.mapView setZoomLevel:zoomLevel animated:YES];
}

-(NSInteger)getZoomLevel{
    return self.mapView.zoomLevel;
}


- (void)removeAnnotations:(NSArray *)annotations;{
    [self.mapView removeAnnotations:annotations];
}
- (void)addAnnotations:(NSArray *)annotations;{
    [self.mapView addAnnotations:annotations];
}


-(void)setShowCurentLocation:(BOOL)showCurentLocation{
    _showCurentLocation = showCurentLocation;
    self.mapView.showsUserLocation = showCurentLocation;
}

-(void)setShowLocateBtn:(BOOL)showLocateBtn{
    _showLocateBtn = showLocateBtn;
    self.currentLocationBtn.hidden = !showLocateBtn;
}

-(void)setShowMapTypeSelecteView:(BOOL)showMapTypeSelecteView{
    _showMapTypeSelecteView = showMapTypeSelecteView;
    self.mapTypeBtn.hidden = !showMapTypeSelecteView;
}

- (void)locateBtnAciton:(UIButton *)sender{
    [self.mapView setCenterCoordinate:self.currentLocationCoordinate2D animated:YES];
}

- (void)mapTypeBtnAciton:(UIButton *)sender{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.3];
    self.mapTypeSelectView.mapType = self.currentMapType;
    [view addSubview:self.mapTypeSelectView];
    [AppKeyWindow addSubview:view];
    __weak typeof(self) weakSelf = self;
    self.mapTypeSelectView.mapTypeBlock = ^(NSInteger mapType) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.currentMapType = mapType;
        strongSelf.mapView.mapType = mapType;
    };
}

- (void)searchDistrictWithName:(NSString *)name
{
    AMapDistrictSearchRequest *dist = [[AMapDistrictSearchRequest alloc] init];
    dist.keywords = name;
    dist.requireExtension = YES;
    
    [self.search AMapDistrictSearch:dist];
}

- (void)handleDistrictResponse:(AMapDistrictSearchResponse *)response
{
    if (response == nil)
    {
        return;
    }
    
    for (AMapDistrict *dist in response.districts)
    {
        if (dist.polylines.count > 0)
        {
            MAMapRect bounds = MAMapRectZero;
            for (NSString *polylineStr in dist.polylines)
            {
                MAPolyline *polyline = [AIFMapTool polylineForCoordinateString:polylineStr];
                [self.mapView addOverlay:polyline];
                if(MAMapRectEqualToRect(bounds, MAMapRectZero)) {
                    bounds = polyline.boundingMapRect;
                } else {
                    bounds = MAMapRectUnion(bounds, polyline.boundingMapRect);
                }
            }
            for (NSString *polylineStr in dist.polylines)
            {
                NSUInteger tempCount = 0;
                CLLocationCoordinate2D *coordinates = [AIFMapTool coordinatesForString:polylineStr
                                                                       coordinateCount:&tempCount
                                                                            parseToken:@";"];
                MAPolygon *polygon = [MAPolygon polygonWithCoordinates:coordinates count:tempCount];
                free(coordinates);
                [self.mapView addOverlay:polygon];
            }
            
            [self.mapView setVisibleMapRect:bounds animated:YES];
        }
    }
}


#pragma mark  - mapDelegate
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    if (self.didSelectAnnotationView) {
        self.didSelectAnnotationView(mapView, view);
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if (self.viewForAnotationBlock) {
        return self.viewForAnotationBlock(mapView, annotation);
    }
    return nil;
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay{
    if (self.rendererForOverlayBlock) {
        return self.rendererForOverlayBlock(mapView, overlay);
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView mapDidZoomByUser:(BOOL)wasUserAction{
    if (self.mapDidZoomByUser) {
        self.mapDidZoomByUser(mapView, wasUserAction);
    }
}


#pragma mark  - locationDelegate
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    AIFLog(@"location:{lat:%f; lon:%f; accuracy:%f; reGeocode:%@}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy, reGeocode.formattedAddress);
    self.currentLocationCoordinate2D = location.coordinate;
}


#pragma mark - AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}

- (void)onDistrictSearchDone:(AMapDistrictSearchRequest *)request response:(AMapDistrictSearchResponse *)response
{
    NSLog(@"response: %@", response);
    [self.mapView removeOverlays:self.mapView.overlays];
    //    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self handleDistrictResponse:response];
}

#pragma mark - set
- (void)aifRendererForOverlay:(MAOverlayRenderer *(^)(MAMapView *mapView,id<MAOverlay> overlay))block;{
    self.rendererForOverlayBlock = block;
}
- (void)aifViewForAnnotation:(MAAnnotationView *(^)(MAMapView *mapView,id<MAAnnotation> annotation))block;{
    self.viewForAnotationBlock = block;
}

- (void)aifMapDidZoomByUser:(void (^)(MAMapView *mapView,BOOL wasUserAction))block;{
    self.mapDidZoomByUser = block;
}
- (void)aifDidSelectAnnotationView:(void (^)(MAMapView *mapView,MAAnnotationView* annotationView))block;{
    self.didSelectAnnotationView = block;
}

#pragma mark - lazy
- (MAMapView *)mapView{
    if (!_mapView) {
        MAMapView *mapView = [[MAMapView alloc]init];
        mapView.mapType = MAMapTypeSatellite;
        mapView.showsUserLocation = YES;
        mapView.delegate = self;
        mapView.showsCompass = NO;
        mapView.showsScale = YES;
        mapView.zoomLevel = kDistrictLevelCountry;
        mapView.scaleOrigin = CGPointMake(20, SCREEN_HEIGHT-50-64);
        mapView.rotateEnabled = NO;
        mapView.rotateCameraEnabled = NO;
        _mapView = mapView;
    }
    return _mapView;
}

- (AMapSearchAPI *)search
{
    if (!_search) {
        _search = [AMapSearchAPI new];
        _search.delegate = self;
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

- (UIButton *)currentLocationBtn
{
    if (!_currentLocationBtn) {
        _currentLocationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_currentLocationBtn setImage:[UIImage imageNamed:@"WorkPlatform_bachselfLocation"] forState:UIControlStateNormal];
        [_currentLocationBtn addTarget:self action:@selector(locateBtnAciton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _currentLocationBtn;
}

- (UIButton *)mapTypeBtn
{
    if (!_mapTypeBtn) {
        _mapTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mapTypeBtn setImage:[UIImage imageNamed:@"real_map_icon"] forState:UIControlStateNormal];
        [_mapTypeBtn addTarget:self action:@selector(mapTypeBtnAciton:) forControlEvents:UIControlEventTouchUpInside];
        _mapTypeBtn.backgroundColor = [UIColor whiteColor];
        _mapTypeBtn.layer.cornerRadius = 5.f;
        _mapTypeBtn.layer.masksToBounds = YES;
    }
    return _mapTypeBtn;
}

- (AIFMapTypeSelectView *)mapTypeSelectView
{
    if (!_mapTypeSelectView) {
        _mapTypeSelectView = [AIFMapTypeSelectView getMapTypeViewBySuperView:self];
    }
    return _mapTypeSelectView;
}


@end
