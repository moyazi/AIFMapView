//
//  AIFMapTool.h
//  AI_Farming
//
//  Created by moyazi on 2019/12/25.
//  Copyright © 2019 het. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import "AIFBaseDrawViewStateObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface AIFMapTool : NSObject
+ (CLLocationCoordinate2D *)coordinatesForString:(NSString *)string
                                 coordinateCount:(NSUInteger *)coordinateCount
                                      parseToken:(NSString *)token;
+ (MAPolyline *)polylineForCoordinateString:(NSString *)coordinateString;


/**
 计算多边形区域面积
 */
+ (double)aif_calculcatePolygonArea:(NSArray*)points;
/**
 根据经纬度判断线段是否相交
 return NO:不相交
 */
+ (BOOL)isIntersectByCoorLine1:(NSArray *)line1 line2:(NSArray *)line2;
/**
 根据经纬度判断两多边形边界是否相交
 return NO:不相交
 */
+ (BOOL)isPolygonsIntersectantByCoorPolygon1:(NSArray *)polygon1 polygon2:(NSArray *)polygon2;
/**
 根据经纬度判断polygon1所有顶点是不是在polygon2里面
 return NO:不在
 */
+ (BOOL)isPolygonInPolygon1:(NSArray *)polygon1 polygon2:(NSArray *)polygon2;
/**
 根据CGPoint判断线段是否相交
 */
+ (BOOL)isIntersectByPointLine1:(NSArray<AIFBaseDrawPointObject *> *)line1 line2:(NSArray<AIFBaseDrawPointObject *> *)line2;


@end

NS_ASSUME_NONNULL_END
