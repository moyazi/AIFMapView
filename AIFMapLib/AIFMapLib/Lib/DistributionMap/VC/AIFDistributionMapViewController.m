//
//  AIFDistributionMapViewController.m
//  AIFMapLib
//
//  Created by moyazi on 2020/1/14.
//  Copyright © 2020 moyazi. All rights reserved.
//

#import "AIFDistributionMapViewController.h"
#import "AIFDistributionMapView.h"
#import "CommonHeader.h"
#import "AIFBaselandDistrictsModel.h"
#import "AIFBaseLandDetailModel.h"
#import "AIFBaselandDistrictsAnnotation.h"
#import "AIFBaselandDistrictsBaselandAnnotation.h"
#import "AIFDistrictsAnnotationView.h"
#import "AIFBaselandAnnotationView.h"

#define kDefaultDistrictName        @"中国"

@interface AIFDistributionMapViewController ()
@property (strong, nonatomic) AIFDistributionMapView *mapShowView;

@property (strong, nonatomic) NSMutableArray *annotationArray;
@property (assign, nonatomic) NSInteger currentZoomlevel;
@property (strong, nonatomic) AIFBaselandDistrictsModel *allDistricts;
@end

@implementation AIFDistributionMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
    [self mapViewDelegate];
    
    [self fakeRequest];
}


- (void)configUI{
    [self.view addSubview:self.mapShowView];
    [self.mapShowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - private
- (void)getAreaMainDataWithZoomLevel:(NSInteger)zoomLevel isDidSelect:(BOOL)isDidSelect{
    if (isDidSelect) {//只有在点击的时候才更改缩放级别
        self.mapShowView.zoomLevel = zoomLevel;
    }
    NSInteger rightZoomlevel = self.currentZoomlevel;
    NSMutableArray *dataArray = [NSMutableArray array];
    if (zoomLevel <= kDistrictLevelProvince) {
        rightZoomlevel = kDistrictLevelProvince;
        //展示省级数据
        [dataArray addObjectsFromArray:self.allDistricts.districts];
    }else if (zoomLevel <= kDistrictLevelCity){
        rightZoomlevel = kDistrictLevelCity;
        //展示市级数据
        for (AIFBaselandDistrictsModel *model in self.allDistricts.districts) {
            [dataArray addObjectsFromArray:model.districts];
        }
    }else if (zoomLevel <= kDistrictLevelDistrict){
        rightZoomlevel = kDistrictLevelDistrict;
        //展示区级数据
        for (AIFBaselandDistrictsModel *model in self.allDistricts.districts) {
            for (AIFBaselandDistrictsModel *subModel in model.districts) {
                [dataArray addObjectsFromArray:subModel.districts];
            }
        }
    }else{
        rightZoomlevel = kDistrictLevelBaseland;
        //展示基地数据
        for (AIFBaselandDistrictsModel *model in self.allDistricts.districts) {
            for (AIFBaselandDistrictsModel *subModel in model.districts) {
                for (AIFBaselandDistrictsModel *subsubModel in subModel.districts) {
                    [dataArray addObjectsFromArray:subsubModel.baselandMapBriefInfoList];
                }
            }
        }
    }
    
    if (rightZoomlevel == self.currentZoomlevel) {
        return;
    }
    self.currentZoomlevel = rightZoomlevel;
    [self.mapShowView removeAnnotations:self.annotationArray];//清除已有标注点
    [self.annotationArray removeAllObjects];
    for (int i = 0; i < dataArray.count; i++){
        id model = [dataArray objectAtIndex:i];
        
        if ([model isKindOfClass:[AIFBaselandDistrictsModel class]]) {
            AIFBaselandDistrictsModel *district = model;
            AIFBaselandDistrictsAnnotation *poiAnnotation = [[AIFBaselandDistrictsAnnotation alloc] init];
            
            poiAnnotation.coordinate = CLLocationCoordinate2DMake(district.latitude.doubleValue, district.longitude.doubleValue);
            
            poiAnnotation.icon      = district.cropIcon;
            poiAnnotation.districtsName = district.regionName;
            poiAnnotation.count = district.baselandNum.integerValue;
            [self.annotationArray addObject:poiAnnotation];
        }
        
        if ([model isKindOfClass:[AIFBaseLandDetailModel class]]) {
            AIFBaseLandDetailModel *baseland = model;
            AIFBaselandDistrictsBaselandAnnotation *poiAnnotation = [[AIFBaselandDistrictsBaselandAnnotation alloc] init];
            poiAnnotation.coordinate = CLLocationCoordinate2DMake(baseland.latitude.doubleValue, baseland.longitude.doubleValue);
            
            poiAnnotation.icon      = baseland.cropIcon;
            poiAnnotation.baselandName      = baseland.baselandName;
            poiAnnotation.baselandId      = baseland.baselandId;
            poiAnnotation.isDemoData = baseland.isDemoData;
            [self.annotationArray addObject:poiAnnotation];
        }
    }
    [self.mapShowView addAnnotations:self.annotationArray];
}




- (void)mapViewDelegate{
    [self.mapShowView aifViewForAnnotation:^MAAnnotationView * _Nonnull(MAMapView * _Nonnull mapView, id<MAAnnotation>  _Nonnull annotation) {
        if ([annotation isKindOfClass:[AIFBaselandDistrictsAnnotation class]])
        {
            static NSString *busStopIdentifier = @"AIFBaselandDistrictsAnnotation";
            AIFDistrictsAnnotationView *poiAnnotationView = (AIFDistrictsAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:busStopIdentifier];
            if (poiAnnotationView == nil)
            {
                poiAnnotationView = [[AIFDistrictsAnnotationView alloc] initWithAnnotation:annotation
                                                                    reuseIdentifier:busStopIdentifier];
            }else{
                poiAnnotationView.model = annotation;
            }
            return poiAnnotationView;
        }
        
        if ([annotation isKindOfClass:[AIFBaselandDistrictsBaselandAnnotation class]])
        {
            static NSString *busStopIdentifier = @"AIFBaselandDistrictsBaselandAnnotation";
            
            AIFBaselandAnnotationView *poiAnnotationView = (AIFBaselandAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:busStopIdentifier];
            if (poiAnnotationView == nil)
            {
                poiAnnotationView = [[AIFBaselandAnnotationView alloc] initWithAnnotation:annotation
                                                                    reuseIdentifier:busStopIdentifier];
            }else{
                poiAnnotationView.model = annotation;
            }
            return poiAnnotationView;
        }
        
        return nil;
    }];
    
    [self.mapShowView aifRendererForOverlay:^MAOverlayRenderer * _Nonnull(MAMapView * _Nonnull mapView, id<MAOverlay>  _Nonnull overlay) {
        if ([overlay isKindOfClass:[MAPolygon class]])
        {
            MAPolygonRenderer *render = [[MAPolygonRenderer alloc] initWithPolygon:overlay];
            
            render.lineWidth   = 2.f;
            render.fillColor = [[UIColor greenColor] colorWithAlphaComponent:0.1];
            render.strokeColor = [[UIColor greenColor] colorWithAlphaComponent:0.1];
            
            return render;
        } else if ([overlay isKindOfClass:[MAPolyline class]])
        {
            MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
            
            polylineRenderer.lineWidth   = 2.f;
            polylineRenderer.strokeColor = [UIColor greenColor];
            
            return polylineRenderer;
        }
        
        return nil;
    }];
    
    [self.mapShowView aifDidSelectAnnotationView:^(MAMapView * _Nonnull mapView, MAAnnotationView * _Nonnull annotationView) {
        MAPointAnnotation *ann = annotationView.annotation;
        NSInteger selectLevel = self.currentZoomlevel;
        if ([ann isKindOfClass:[AIFBaselandDistrictsAnnotation class]]) {
            //地区
            AIFBaselandDistrictsAnnotation *districtsAnnotation = (AIFBaselandDistrictsAnnotation *)ann;
            [self.mapShowView searchDistrictWithName:districtsAnnotation.districtsName];
            
            if (self.currentZoomlevel == kDistrictLevelProvince) {
                selectLevel = kDistrictLevelCity;
            }else if (self.currentZoomlevel == kDistrictLevelCity){
                selectLevel = kDistrictLevelDistrict;
            }if (self.currentZoomlevel == kDistrictLevelDistrict){
                selectLevel = kDistrictLevelBaseland;
            }
            [self getAreaMainDataWithZoomLevel:selectLevel isDidSelect:NO];
        }else if([ann isKindOfClass:[AIFBaselandDistrictsBaselandAnnotation class]]){
            //基地
            [mapView setCenterCoordinate:ann.coordinate animated:YES];
            
        }
    }];
    
    [self.mapShowView aifMapDidZoomByUser:^(MAMapView * _Nonnull mapView, BOOL wasUserAction) {
        if (!wasUserAction) {
            return;
        }
        CGFloat zoomlevel = mapView.zoomLevel;
        
        [self getAreaMainDataWithZoomLevel:zoomlevel isDidSelect:NO];
    }];
}




- (void)fakeRequest{
    NSDictionary *data = @{@"regionCode":@"",@"regionName":@"",@"longitude":@"",@"latitude":@"",@"baselandNum":@"",@"cropIcon":@"",@"districts":@[@{@"regionCode":@44,@"regionName":@"广东省",@"longitude":@113.39481800,@"latitude":@23.40800400,@"baselandNum":@6,@"cropIcon":@"http://tencentest.hetyj.com/31038/2fe6cdf3ce771f1be33f9639796fa8f8.png",@"districts":@[@{@"regionCode":@440300000000,@"regionName":@"深圳市",@"longitude":@114.02597400,@"latitude":@22.54605400,@"baselandNum":@6,@"cropIcon":@"http://tencentest.hetyj.com/31038/2fe6cdf3ce771f1be33f9639796fa8f8.png",@"districts":@[@{@"regionCode":@440305000000,@"regionName":@"南山区",@"longitude":@113.9423509526,@"latitude":@22.4990415986,@"baselandNum":@6,@"cropIcon":@"http://tencentest.hetyj.com/31038/2fe6cdf3ce771f1be33f9639796fa8f8.png",@"districts":@[],@"baselandMapBriefInfoList":@[@{@"baselandId":@208,@"parentId":@"",@"unitSize":@"",@"agricultureProductTypeId":@76,@"agricultureProductName":@"",@"longitude":@113.9423509526,@"latitude":@22.4990415986,@"cropIcon":@"http://tencentest.hetyj.com/31038/2fe6cdf3ce771f1be33f9639796fa8f8.png",@"baselandName":@"和而泰南山1号基地",@"isDemoData":@0},@{@"baselandId":@220,@"parentId":@"",@"unitSize":@"",@"agricultureProductTypeId":@241,@"agricultureProductName":@"",@"longitude":@113.9545430000,@"latitude":@22.5379090000,@"cropIcon":@"http://tencentest.hetyj.com/31038/5c6029d241fbdac1d10fa7483747d183.png",@"baselandName":@"和而泰落雨果园",@"isDemoData":@0},@{@"baselandId":@252,@"parentId":@"",@"unitSize":@"",@"agricultureProductTypeId":@77,@"agricultureProductName":@"",@"longitude":@113.9544550000,@"latitude":@22.5378320000,@"cropIcon":@"http://tencentest.hetyj.com/31038/2fe6cdf3ce771f1be33f9639796fa8f8.png",@"baselandName":@"和而泰南山6号基地",@"isDemoData":@0},@{@"baselandId":@522,@"parentId":@"",@"unitSize":@"",@"agricultureProductTypeId":@195,@"agricultureProductName":@"",@"longitude":@113.9189516569,@"latitude":@22.6010740576,@"cropIcon":@"http://tencentest.hetyj.com/31038/6a3ccb2b3f44ea2c0faf27e147f980e7.png",@"baselandName":@"图文基地",@"isDemoData":@0},@{@"baselandId":@699,@"parentId":@"",@"unitSize":@"",@"agricultureProductTypeId":@77,@"agricultureProductName":@"",@"longitude":@113.9545230000,@"latitude":@22.5378880000,@"cropIcon":@"http://tencentest.hetyj.com/31038/2fe6cdf3ce771f1be33f9639796fa8f8.png",@"baselandName":@"基地名字超级长的基地就是这个基地是的没错",@"isDemoData":@0},@{@"baselandId":@701,@"parentId":@"",@"unitSize":@"",@"agricultureProductTypeId":@76,@"agricultureProductName":@"",@"longitude":@113.9545490000,@"latitude":@22.5379070000,@"cropIcon":@"http://tencentest.hetyj.com/31038/2fe6cdf3ce771f1be33f9639796fa8f8.png",@"baselandName":@"新增的基地测试",@"isDemoData":@0}]}],@"baselandMapBriefInfoList":@[]}],@"baselandMapBriefInfoList":@[]}],@"baselandMapBriefInfoList":@[]};
    
    AIFBaselandDistrictsModel *model = [[AIFBaselandDistrictsModel alloc]init];
    [model setValuesForKeysWithDictionary:data];
    self.allDistricts = model;
    [self getAreaMainDataWithZoomLevel:kDistrictLevelCountry isDidSelect:YES];
    
    
}



- (AIFDistributionMapView *)mapShowView
{
    if (!_mapShowView) {
        _mapShowView = [AIFDistributionMapView new];
        _mapShowView.showMapTypeSelecteView = YES;
        _mapShowView.showLocateBtn = YES;
        _mapShowView.showCurentLocation = YES;
    }
    return _mapShowView;
}

- (NSMutableArray *)annotationArray
{
    if (!_annotationArray) {
        _annotationArray = [NSMutableArray array];
    }
    return _annotationArray;
}


@end
