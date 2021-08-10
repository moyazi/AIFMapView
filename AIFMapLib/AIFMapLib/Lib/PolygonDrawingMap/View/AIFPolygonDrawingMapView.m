//
//  AIFPolygonDrawingMapView.m
//  AIFMapLib
//
//  Created by moyazi on 2020/2/12.
//  Copyright © 2020 moyazi. All rights reserved.
//

#import "AIFPolygonDrawingMapView.h"


@interface AIFPolygonDrawingMapView ()<MAMapViewDelegate>
@property (nonatomic, strong) MAMapView *mapView;//地图
@property (strong, nonatomic) AIFDrawBasePointView *drawPointView;//drawView,显示编辑轮廓的图层

@end


@implementation AIFPolygonDrawingMapView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
        [self setupEvents];
    }
    return self;
}

- (void)configUI{
    [self addSubview:self.mapView];
    [self addSubview:self.drawPointView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    [self.drawPointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
}

- (void)setupEvents{
    
}





#pragma mark  - method
- (void)updateMapViewGesEnabled:(BOOL)value{
    self.mapView.userInteractionEnabled = value;
}

- (void)setMapType:(int)mapType{
    [self.mapView setMapType:mapType];
}


- (MAPointAnnotation *)getAnnotationByPoint:(CGPoint)point{
    CGPoint touchPoint = point;
    CGPoint new = CGPointMake(touchPoint.x, touchPoint.y+28.f);
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:new toCoordinateFromView:self];
    MAPointAnnotation *anno = [[MAPointAnnotation alloc]init];
    anno.coordinate = coordinate;
    return anno;
}

- (MAPointAnnotation *)getAnnotationByCoordinate:(CLLocationCoordinate2D)coordinate{
    MAPointAnnotation *anno = [[MAPointAnnotation alloc]init];
    anno.coordinate = coordinate;
    return anno;
}


- (CGPoint)convertCoor2CGPoint:(CLLocationCoordinate2D)coor{
    CGPoint point= [self.mapView convertCoordinate:coor toPointToView:self];
    return point;
    
}
- (CLLocationCoordinate2D)convertCGPoint2Coor:(CGPoint)point{
    CLLocationCoordinate2D coor = [self.mapView convertPoint:point toCoordinateFromView:self];
    return coor;
}

- (void)refreshDrawView:(id)state{
    [self.drawPointView refreshView:state];
}


#pragma mark  - mapViewDelegate
/**
 * @brief 地图区域改变过程中会调用此接口
 */
- (void)mapViewRegionChanged:(MAMapView *)mapView;{
    //pointArrayNeedUpdate
    if (self.deleagte && [self.deleagte respondsToSelector:@selector(refreshDrawViewbyCoors)]) {
        [self.deleagte refreshDrawViewbyCoors];
    }
}

#pragma mark  - lazy
- (AIFDrawBasePointView *)drawPointView
{
    if (!_drawPointView) {
        _drawPointView = [AIFDrawBasePointView new];
    }
    return _drawPointView;
}

- (MAMapView *)mapView{//因为采用pod形式，我的位置icon先不改变
    if (!_mapView) {
        MAMapView *mapView = [[MAMapView alloc]init];
        mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
        mapView.mapType = MAMapTypeSatellite;
        mapView.showsUserLocation = YES;
        mapView.delegate = self;
        mapView.showsScale = YES;
        mapView.scaleOrigin = CGPointMake(20, SCREEN_HEIGHT-50-64);
        mapView.rotateEnabled = NO;
        mapView.rotateCameraEnabled = NO;
        _mapView = mapView;
    }
    return _mapView;
}
@end
