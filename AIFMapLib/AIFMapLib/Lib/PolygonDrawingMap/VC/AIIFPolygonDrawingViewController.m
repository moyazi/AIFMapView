//
//  AIIFPolygonDrawingViewController.m
//  AIFMapLib
//
//  Created by moyazi on 2020/2/12.
//  Copyright © 2020 moyazi. All rights reserved.
//

#import "AIIFPolygonDrawingViewController.h"
#import "AIFPolygonDrawingMapView.h"
#import "AIFBaseMapDrawTopInfoView.h"
#import "CommonHeader.h"


@interface AIIFPolygonDrawingViewController ()<UIGestureRecognizerDelegate,AIFPolygonDrawingMapViewDelegate>
@property (strong, nonatomic) AIFPolygonDrawingMapView *mapView;

@property (strong, nonatomic) UIButton *drawBtn;
@property (strong, nonatomic) AIFBaseMapDrawTopInfoView *topInfoView;

@end

@implementation AIIFPolygonDrawingViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    [self setupEvents];
}


- (void)configUI{
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.drawBtn];
    [self.drawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-IPX_HOMEINDICATORHEIGHT-20);
    }];
    
}

- (void)setupEvents{
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(drawClick:)];
    ges.delegate = self;
    [self.mapView addGestureRecognizer:ges];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panClick:)];
    pan.delegate = self;
    [self.mapView addGestureRecognizer:pan];
    
    [self.drawBtn addTarget:self action:@selector(drawBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)drawBtnAction:(UIButton *)sender{
    self.beginDraw = YES;
    self.drawBtn.hidden = YES;
}


#pragma mark - 绘制轮廓及移动轮廓点
- (void)drawClick:(UITapGestureRecognizer*)ges{
    if (self.closeOutline) {
        return;
    }
    CGPoint point = [ges locationInView:self.view];
    if (self.drawPointArray.count > 2) {
        //可以闭合
        AIFBaseDrawPointObject *firstValue = self.drawPointArray.firstObject;
        CGPoint firstP = firstValue.point;
        
        CGFloat distance = sqrt(pow((firstP.x - point.x), 2) + pow((firstP.y - point.y), 2));
        if (distance <= kDotViewCircle) {
            self.closeOutline = YES;
            [self updateEditPointArraySaveState:YES checkOutline:YES];
            return;
        }
    }
    
    [self drawToPoint:point];
}

- (void)panClick:(UIPanGestureRecognizer *)pan{
    CGPoint newPoint = [pan locationInView:self.view];
    AIFBaseDrawPointObject *newPointObj = [[AIFBaseDrawPointObject alloc]init];
    newPointObj.pointType = 1;
    newPointObj.point = newPoint;
    
    CLLocationCoordinate2D coor = [self.mapView convertCGPoint2Coor:newPoint];
    newPointObj.coor = coor;
    
    NSInteger index = [self.drawEditPointArray indexOfObject:self.currentDrawPoint];
    if (index >= 0 && index < self.drawEditPointArray.count) {
        if (self.currentDrawPoint.pointType == 0) {
            NSInteger newIndex = (index +1)/2;
            [self.drawPointArray insertObject:newPointObj atIndex:newIndex];
        }else{
            NSInteger newIndex = [self.drawPointArray indexOfObject:self.currentDrawPoint];
            [self.drawPointArray replaceObjectAtIndex:newIndex withObject:newPointObj];
        }
        self.currentDrawPoint = newPointObj;
        
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        [self updateEditPointArraySaveState:YES checkOutline:YES];
    }else{
        [self updateEditPointArraySaveState:NO checkOutline:NO];
    }
}

- (void)drawToPoint:(CGPoint)point{
    AIFBaseDrawPointObject *newPointObj = [[AIFBaseDrawPointObject alloc]init];
    newPointObj.pointType = 1;//1大点
    newPointObj.point = point;
    
    CLLocationCoordinate2D coor = [self.mapView convertCGPoint2Coor:point];
    newPointObj.coor = coor;
    [self.drawPointArray addObject:newPointObj];
    [self updateEditPointArraySaveState:YES checkOutline:YES];
}

- (void)updateEditPointArraySaveState:(BOOL)saveState checkOutline:(BOOL)check{
    [self accountOutlineInfo];
    [self.drawEditPointArray removeAllObjects];
    AIFBaseDrawPointObject *lastObj = nil;
    for (int i = 0; i < self.drawPointArray.count; i++) {
        AIFBaseDrawPointObject *obj = self.drawPointArray[i];
        if (lastObj) {
            AIFBaseDrawPointObject *midObj = [[AIFBaseDrawPointObject alloc]init];
            CGPoint midPoint = CGPointMake((lastObj.point.x + obj.point.x)/2, (lastObj.point.y + obj.point.y)/2);
            midObj.point = midPoint;
            midObj.pointType = 0;
            CLLocationCoordinate2D coor = [self.mapView convertCGPoint2Coor:midPoint];
            midObj.coor = coor;
            [self.drawEditPointArray addObject:midObj];
        }
        [self.drawEditPointArray addObject:obj];
        lastObj = obj;
    }
    //是否闭合
    if (self.closeOutline) {
        AIFBaseDrawPointObject *firstObj = self.drawPointArray.firstObject;
        AIFBaseDrawPointObject *lastObj = self.drawPointArray.lastObject;
        AIFBaseDrawPointObject *midObj = [[AIFBaseDrawPointObject alloc]init];
        CGPoint midPoint = CGPointMake((lastObj.point.x + firstObj.point.x)/2, (lastObj.point.y + firstObj.point.y)/2);
        midObj.point = midPoint;
        midObj.pointType = 0;
        CLLocationCoordinate2D coor = [self.mapView convertCGPoint2Coor:midPoint];
        midObj.coor = coor;
        [self.drawEditPointArray addObject:midObj];
    }
    
    
    AIFBaseDrawViewStateObject *stateObj = [[AIFBaseDrawViewStateObject alloc]init];
    stateObj.editPoints = self.drawEditPointArray;
    stateObj.orignalPoints = self.drawPointArray;
    stateObj.close = self.closeOutline;
    [stateObj checkLegitimate];
    
    [self.mapView refreshDrawView:stateObj];
    self.curentDrawState = stateObj;
    if (saveState) {
        [self.drawStateArray addObject:stateObj];
    }
    if (!stateObj.legitimate) {
//        self.topInfoView.confirmBtn.enabled = NO;
        return;
    }
    if (stateObj.close && check) {
//        NSString *errorString = [stateObj errorString];
//        if ([errorString isCanUsed]) {
//            [HETMBProgressHUD showHudWithMessage:errorString hiddenAfterDelay:2.f];
//        }
    }
    
//    BOOL outline = ![[stateObj errorString] isCanUsed];
//    self.topInfoView.confirmBtn.enabled = stateObj.close&&outline;
    
}


- (void)accountOutlineInfo{
    //根据经纬度计算多边形面积:平方米
    double s = [AIFMapTool aif_calculcatePolygonArea:self.drawPointArray];
    double areaMu = s*0.0015;
//    NSString *str = [AIFTools takeUpToTwoDecimalPlaces:areaMu];
//    self.pointDrawAreaMu = [NSNumber numberWithFloat:str.floatValue];
//    self.topInfoView.areaLabel.text = [NSString stringWithFormat:@"面积:%@亩",str];
    
    CLLocationDistance distance = 0.f;
    if (self.drawPointArray.count > 1) {
        for (int i = 0; i < self.drawPointArray.count-1; i++) {
            AIFBaseDrawPointObject *obj1 = self.drawPointArray[i];
            AIFBaseDrawPointObject *obj2 = self.drawPointArray[i+1];
            MAMapPoint point1 = MAMapPointForCoordinate(obj1.coor);
            MAMapPoint point2 = MAMapPointForCoordinate(obj2.coor);
            distance += MAMetersBetweenMapPoints(point1,point2);
        }
        
        if (self.closeOutline) {
            AIFBaseDrawPointObject *obj1 = self.drawPointArray.firstObject;
            AIFBaseDrawPointObject *obj2 = self.drawPointArray.lastObject;
            MAMapPoint point1 = MAMapPointForCoordinate(obj1.coor);
            MAMapPoint point2 = MAMapPointForCoordinate(obj2.coor);
            distance += MAMetersBetweenMapPoints(point1,point2);
        }
    }
    
//    NSString *str1 = [AIFTools takeUpToTwoDecimalPlaces:distance];
//    self.pointDrawPerimeter = [NSNumber numberWithFloat:str.floatValue];
//    self.topInfoView.perimeterLabel.text = [NSString stringWithFormat:@"周长:%@米",str1];
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //高德地图无法屏蔽点击手势,这么处理
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        return YES;
    }
    return NO;
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        if (!self.beginDraw) {
            return NO;
        }
        //未闭合
        if (self.closeOutline) {
            return NO;
        }
        [self.mapView updateMapViewGesEnabled:NO];
        return YES;
    }
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        //判断是否在分段点上,是refresh--
        for (AIFBaseDrawPointObject *value in self.drawEditPointArray) {
            CGPoint dotPoint = value.point;
            CGPoint point = [touch locationInView:self.view];
            CGFloat distance = sqrt(pow((dotPoint.x - point.x), 2) + pow((dotPoint.y - point.y), 2));
            if (distance <= kDotViewCircle+20) {
                self.currentDrawPoint = value;
                //关闭mapView手势
                [self.mapView updateMapViewGesEnabled:NO];
                return YES;
            }
            self.currentDrawPoint = nil;
        }
    }
    [self.mapView updateMapViewGesEnabled:YES];
    return NO;
}


#pragma mark  - mapViewDeleagte
- (void)refreshDrawViewbyCoors{
    for (AIFBaseDrawPointObject *obj in self.drawPointArray) {
        CLLocationCoordinate2D coor = obj.coor;
        CGPoint point =  [self.mapView convertCoor2CGPoint:coor];
        obj.point = point;
    }
    [self updateEditPointArraySaveState:NO checkOutline:NO];
}


#pragma mark  - lazy
- (AIFPolygonDrawingMapView *)mapView
{
    if (!_mapView) {
        _mapView = [AIFPolygonDrawingMapView new];
        _mapView.deleagte = self;
    }
    return _mapView;
}

- (UIButton *)drawBtn
{
    if (!_drawBtn) {
        _drawBtn = [UIButton new];
        [_drawBtn setTitle:@"开始绘制" forState:UIControlStateNormal];
        [_drawBtn setBackgroundImage:[UIConfig imageWithColor:THEMECOLOR] forState:UIControlStateNormal];
    }
    return _drawBtn;
}

- (NSMutableArray *)drawPointArray
{
    if (!_drawPointArray) {
        _drawPointArray = [NSMutableArray array];
    }
    return _drawPointArray;
}

- (NSMutableArray *)drawEditPointArray
{
    if (!_drawEditPointArray) {
        _drawEditPointArray = [NSMutableArray array];
    }
    return _drawEditPointArray;
}

- (NSMutableArray *)drawStateArray
{
    if (!_drawStateArray) {
        _drawStateArray = [NSMutableArray array];
    }
    return _drawStateArray;
}
@end
