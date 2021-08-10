//
//  AIIFPolygonDrawingViewController.h
//  AIFMapLib
//
//  Created by moyazi on 2020/2/12.
//  Copyright © 2020 moyazi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class AIFBaseDrawPointObject,AIFBaseDrawViewStateObject;
@interface AIIFPolygonDrawingViewController : UIViewController
@property (assign, nonatomic) BOOL beginDraw;//是否开始绘制
@property (assign, nonatomic) BOOL closeOutline;//图形是否闭合
@property (strong, nonatomic) NSMutableArray *drawPointArray;//用户点击的点即我们要拿到的点的合集
@property (strong, nonatomic) NSMutableArray *drawEditPointArray;//用户点击的点+中间生成的编辑点(小点)
@property (strong, nonatomic) AIFBaseDrawPointObject *currentDrawPoint;//当前拖动的点
@property (strong, nonatomic) NSMutableArray<AIFBaseDrawViewStateObject*> *drawStateArray;//保存每次操作后的状态,用于撤回
@property (strong, nonatomic) AIFBaseDrawViewStateObject *curentDrawState;
@end

NS_ASSUME_NONNULL_END
