//
//  AIFPolygonDrawingMapView.h
//  AIFMapLib
//
//  Created by moyazi on 2020/2/12.
//  Copyright © 2020 moyazi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AIFDrawBasePointView.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
NS_ASSUME_NONNULL_BEGIN

@protocol AIFPolygonDrawingMapViewDelegate <NSObject>

- (void)refreshDrawViewbyCoors;

@end

@interface AIFPolygonDrawingMapView : UIView
@property (weak, nonatomic) id<AIFPolygonDrawingMapViewDelegate> deleagte;

@property (nonatomic, assign) int mapType;//地图map显示类型
- (void)updateMapViewGesEnabled:(BOOL)value;
- (MAPointAnnotation *)getAnnotationByPoint:(CGPoint)point;//根据视图点获取对象
- (MAPointAnnotation *)getAnnotationByCoordinate:(CLLocationCoordinate2D)coordinate;//根据经纬度获取对象

- (CGPoint)convertCoor2CGPoint:(CLLocationCoordinate2D)coor;
- (CLLocationCoordinate2D)convertCGPoint2Coor:(CGPoint)point;

- (void)refreshDrawView:(id)state;

@end

NS_ASSUME_NONNULL_END
