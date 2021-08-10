//
//  AIFDistributionMapView.h
//  AI_Farming
//
//  Created by moyazi on 2020/1/9.
//  Copyright © 2020 het. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import "AIFMapTool.h"
NS_ASSUME_NONNULL_BEGIN

#define kDistrictLevelCountry        3
#define kDistrictLevelProvince        5
#define kDistrictLevelCity            9
#define kDistrictLevelDistrict        11
#define kDistrictLevelBaseland        13


@interface AIFDistributionMapView : UIView
//是否展示定位到当前位置按钮,默认yes
@property (assign, nonatomic) BOOL showLocateBtn;
//是否展示mapType切换按钮,默认yes
@property (assign, nonatomic) BOOL showMapTypeSelecteView;
@property (assign, nonatomic) BOOL showCurentLocation;
//地图缩放比例
@property (assign, nonatomic) NSInteger zoomLevel;
//行政区域边界样式
- (void)aifRendererForOverlay:(MAOverlayRenderer *(^)(MAMapView *mapView,id<MAOverlay> overlay))block;
//标注点样式
- (void)aifViewForAnnotation:(MAAnnotationView *(^)(MAMapView *mapView,id<MAAnnotation> annotation))block;
//地图缩放操作回调
- (void)aifMapDidZoomByUser:(void (^)(MAMapView *mapView,BOOL wasUserAction))block;
//标注点点击事件
- (void)aifDidSelectAnnotationView:(void (^)(MAMapView *mapView,MAAnnotationView* annotationView))block;

//- (NSInteger)getCurrentZoomLevel;
//搜索行政区域
- (void)searchDistrictWithName:(NSString *)name;

- (void)removeAnnotations:(NSArray *)annotations;
- (void)addAnnotations:(NSArray *)annotations;
@end

NS_ASSUME_NONNULL_END
