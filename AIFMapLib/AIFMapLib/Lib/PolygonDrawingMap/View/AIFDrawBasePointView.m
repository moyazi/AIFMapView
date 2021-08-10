//
//  AIFDrawBasePointView.m
//  AIFMapLib
//
//  Created by moyazi on 2020/2/12.
//  Copyright © 2020 moyazi. All rights reserved.
//

#import "AIFDrawBasePointView.h"


@interface AIFDrawBasePointView ()
@property (strong, nonatomic) UIBezierPath *linePath;
@property (strong, nonatomic) CAShapeLayer *lineLayer;
@end
@implementation AIFDrawBasePointView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        [self configUI];
        [self setupEvents];
    }
    return self;
}

- (void)setupEvents{
    self.userInteractionEnabled = NO;
}


-(void)refreshView:(id)state{
    
    AIFBaseDrawViewStateObject *stateObj = state;
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    UIBezierPath *path = [UIBezierPath bezierPath];
    self.linePath = path;
    path.lineWidth = 1;
    path.lineCapStyle = kCGLineCapRound; //线条拐角
    path.lineJoinStyle = kCGLineCapRound; //终点处理
    
    if (stateObj.editPoints.count>1) {
        for (int i = 0; i<stateObj.editPoints.count; i++) {
            AIFBaseDrawPointObject *value = stateObj.editPoints[i];
            CGPoint point = value.point;
            if (i == 0) {
                [path moveToPoint:point];
            }else{
                [path addLineToPoint:point];
            }
        }
        if (stateObj.close) {
            [path closePath];
        }
    }
    [self.lineLayer removeFromSuperlayer];
    CAShapeLayer *caShapelayer = [CAShapeLayer layer];
    self.lineLayer = caShapelayer;
    caShapelayer.path = self.linePath.CGPath;
    //线条宽度
    caShapelayer.lineWidth = 2.f;
    if (!stateObj.close) {
        caShapelayer.lineDashPattern = @[@(10),@(10)];;
    }
    caShapelayer.frame = self.bounds;
    UIColor *color = [UIColor greenColor];
//    UIColor *color = [UIConfig getColor:stateObj.colorStr];
    //线条颜色
    caShapelayer.strokeColor = color.CGColor;
    //填充颜色
    caShapelayer.fillColor = [UIColor clearColor].CGColor;
    
    //合法判断
    if (!stateObj.legitimate) {
        caShapelayer.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.5].CGColor;
    }else{
        //合法 是否close
        if (stateObj.close) {
//            switch (stateObj.overlapStyle) {
//                case AIFBaseBlockMapViewOverlapStyleDefault:
//                {
//                    caShapelayer.fillColor = [color colorWithAlphaComponent:0.3].CGColor;
//                }
//                    break;
//                default:
//                {
//                    caShapelayer.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.5].CGColor;
//                }
//                    break;
//            }
        }
        
        
    }
    [self.layer addSublayer:caShapelayer];
    
    //添加移动圆点
    for (AIFBaseDrawPointObject *obj in stateObj.editPoints) {
        UIView *dot = [self createDot:obj];
        [self addSubview:dot];
        dot.center = obj.point;
    }
}

- (UIView *)createDot:(AIFBaseDrawPointObject*)obj{
    CGFloat viewH = 10;
    if (obj.pointType == 1) {
        viewH = 20;
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewH, viewH)];
    view.layer.cornerRadius = viewH/2.f;
    view.layer.masksToBounds = YES;
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

@end
