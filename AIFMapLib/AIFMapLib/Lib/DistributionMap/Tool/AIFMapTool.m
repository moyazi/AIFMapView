//
//  AIFMapTool.m
//  AI_Farming
//
//  Created by moyazi on 2019/12/25.
//  Copyright © 2019 het. All rights reserved.
//

#import "AIFMapTool.h"


@implementation AIFMapTool
+ (CLLocationCoordinate2D *)coordinatesForString:(NSString *)string
                                 coordinateCount:(NSUInteger *)coordinateCount
                                      parseToken:(NSString *)token
{
    if (string == nil) {
        return NULL;
    }
    if (token == nil) {
        token = @",";
    }
    NSString *str = @"";
    if (![token isEqualToString:@","]) {
        str = [string stringByReplacingOccurrencesOfString:token withString:@","];
    }
    else {
        str = [NSString stringWithString:string];
    }
    NSArray *components = [str componentsSeparatedByString:@","];
    NSUInteger count = [components count] / 2;
    if (coordinateCount != NULL) {
        *coordinateCount = count;
    }
    CLLocationCoordinate2D *coordinates = (CLLocationCoordinate2D*)malloc(count * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < count; i++) {
        coordinates[i].longitude = [[components objectAtIndex:2 * i]     doubleValue];
        coordinates[i].latitude  = [[components objectAtIndex:2 * i + 1] doubleValue];
    }
    
    return coordinates;
}

+ (MAPolyline *)polylineForCoordinateString:(NSString *)coordinateString
{
    if (coordinateString.length == 0)
    {
        return nil;
    }
    
    NSUInteger count = 0;
    
    CLLocationCoordinate2D *coordinates = [self coordinatesForString:coordinateString
                                                     coordinateCount:&count
                                                          parseToken:@";"];
    
    MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coordinates count:count];
    
    free(coordinates), coordinates = NULL;
    
    return polyline;
}


+ (double)aif_calculcatePolygonArea:(NSArray<AIFBaseDrawPointObject *>*)points;{
    double total=  0.f;
    if (points.count < 3) {
        return 0;
    }
    double radius = 6371009;
    AIFBaseDrawPointObject *prev = points.lastObject;
    double a = [self toRadians:prev.coor.latitude];
    double prevTanLat = tan((M_PI / 2 - a)/2);
    double prevLng = [self toRadians:prev.coor.longitude];
    
    for (AIFBaseDrawPointObject *point in points) {
        double a = [self toRadians:point.coor.latitude];
        double tanLat = tan((M_PI / 2 - a)/2);
        double lng = [self toRadians:point.coor.longitude];
        total += [self polarTriangleAreaTan1:tanLat lng1:lng tan2:prevTanLat lng2:prevLng];
        prevTanLat = tanLat;
        prevLng = lng;
    }
    double s = total * (radius * radius);
    return fabs(s);
}

//coor 计算线段相交
+ (BOOL)isIntersectByCoorLine1:(NSArray *)line1 line2:(NSArray *)line2{
    id a1 = line1.firstObject;
    id a2 = line1.lastObject;
    id a3 = line2.firstObject;
    id a4 = line2.lastObject;
    
    CLLocationCoordinate2D p0;
    CLLocationCoordinate2D p1;
    CLLocationCoordinate2D q0;
    CLLocationCoordinate2D q1;
    
    if ([a1 isKindOfClass:[AIFBaseDrawPointObject class]]) {
        AIFBaseDrawPointObject *obj = (AIFBaseDrawPointObject*)a1;
        p0 = obj.coor;
    }else if ([a1 isKindOfClass:[MAPointAnnotation class]]){
        MAPointAnnotation *obj = (MAPointAnnotation*)a1;
        p0 = obj.coordinate;
    }else{
        return YES;
    }
    
    if ([a2 isKindOfClass:[AIFBaseDrawPointObject class]]) {
        AIFBaseDrawPointObject *obj = (AIFBaseDrawPointObject*)a2;
        p1 = obj.coor;
    }else if ([a1 isKindOfClass:[MAPointAnnotation class]]){
        MAPointAnnotation *obj = (MAPointAnnotation*)a2;
        p1 = obj.coordinate;
    }else{
        return YES;
    }
    
    if ([a3 isKindOfClass:[AIFBaseDrawPointObject class]]) {
        AIFBaseDrawPointObject *obj = (AIFBaseDrawPointObject*)a3;
        q0 = obj.coor;
    }else if ([a1 isKindOfClass:[MAPointAnnotation class]]){
        MAPointAnnotation *obj = (MAPointAnnotation*)a3;
        q0 = obj.coordinate;
    }else{
        return YES;
    }
    
    if ([a4 isKindOfClass:[AIFBaseDrawPointObject class]]) {
        AIFBaseDrawPointObject *obj = (AIFBaseDrawPointObject*)a4;
        q1 = obj.coor;
    }else if ([a1 isKindOfClass:[MAPointAnnotation class]]){
        MAPointAnnotation *obj = (MAPointAnnotation*)a4;
        q1 = obj.coordinate;
    }else{
        return YES;
    }
    
    CGFloat abc = (p0.latitude - q0.latitude) * (p1.longitude -q0.longitude) - (p0.longitude - q0.longitude) * (p1.latitude - q0.latitude);
    CGFloat abd = (p0.latitude - q1.latitude) * (p1.longitude - q1.longitude) - (p0.longitude - q1.longitude) * (p1.latitude - q1.latitude);
    if (abc * abd >= 0) {
        //不相交
        return NO;
    }
    
    CGFloat cda = (q0.latitude - p0.latitude) * (q1.longitude - p0.longitude) - (q0.longitude - p0.longitude) * (q1.latitude - p0.latitude);
    CGFloat cdb = cda + abc - abd;
    return !(cda * cdb >= 0);
}

//coor 多边形边界是否相交
+ (BOOL)isPolygonsIntersectantByCoorPolygon1:(NSArray *)polygon1 polygon2:(NSArray *)polygon2{
    NSMutableArray *lines1 = [NSMutableArray array];
    NSMutableArray *lines2 = [NSMutableArray array];
    for (int i = 0; i < polygon1.count -1; i++) {
        id p1 = polygon1[i];
        id p2 = polygon1[i+1];
        NSArray *line = [NSArray arrayWithObjects:p1,p2, nil];
        [lines1 addObject:line];
    }
    
    for (int i = 0; i < polygon2.count -1; i++) {
        id p1 = polygon2[i];
        id p2 = polygon2[i+1];
        NSArray *line = [NSArray arrayWithObjects:p1,p2, nil];
        [lines2 addObject:line];
    }
    
    //加上起点到终点的线
    NSArray *line1 = [NSArray arrayWithObjects:polygon1.lastObject,polygon1.firstObject, nil];
    NSArray *line2 = [NSArray arrayWithObjects:polygon2.lastObject,polygon2.firstObject, nil];
    [lines1 addObject:line1];
    [lines2 addObject:line2];
    
    for (NSArray *line1 in lines1) {
        for (NSArray *line2 in lines2) {
            if ([self isIntersectByCoorLine1:line1 line2:line2]) {
                return YES;
            }
        }
    }
    return NO;
}

//coor 多边形是否存在包含关系(地块点全部在基地区域内)
+ (BOOL)isPolygonInPolygon1:(NSArray *)polygon1 polygon2:(NSArray *)polygon2{
    //计算polygon2的区域
    CLLocationCoordinate2D coordinates[polygon2.count];
    for (int i = 0; i<polygon2.count; i++) {
        id point = polygon2[i];
        CLLocationCoordinate2D coor;
        if ([point isKindOfClass:[AIFBaseDrawPointObject class]]) {
            AIFBaseDrawPointObject *obj = (AIFBaseDrawPointObject*)point;
            coor = obj.coor;
        }else if ([point isKindOfClass:[MAPointAnnotation class]]){
            MAPointAnnotation *obj = (MAPointAnnotation*)point;
            coor = obj.coordinate;
        }else{
            return YES;
        }
        coordinates[i].latitude = coor.latitude;
        coordinates[i].longitude = coor.longitude;
    }
    
    for ( id point1 in polygon1) {
        CLLocationCoordinate2D coor1;
        if ([point1 isKindOfClass:[AIFBaseDrawPointObject class]]) {
            AIFBaseDrawPointObject *obj = (AIFBaseDrawPointObject*)point1;
            coor1 = obj.coor;
        }else if ([point1 isKindOfClass:[MAPointAnnotation class]]){
            MAPointAnnotation *obj = (MAPointAnnotation*)point1;
            coor1 = obj.coordinate;
        }else{
            return YES;
        }
        MAMapPoint p1 = MAMapPointForCoordinate(coor1);
        MAPolygon *polygon = [MAPolygon polygonWithCoordinates:coordinates count:polygon2.count];
        BOOL result = MAPolygonContainsPoint(p1, polygon.points, polygon2.count);
        if (!result) {
            return NO;
        }
    }
    return YES;
}

//point 计算线段相交
+ (BOOL)isIntersectByPointLine1:(NSArray<AIFBaseDrawPointObject *> *)line1 line2:(NSArray<AIFBaseDrawPointObject *> *)line2{
    AIFBaseDrawPointObject *p1 = line1.firstObject;
    AIFBaseDrawPointObject *p2 = line1.lastObject;
    AIFBaseDrawPointObject *q1 = line2.firstObject;
    AIFBaseDrawPointObject *q2 = line2.lastObject;
    
    CGFloat a1 = (p2.point.x - p1.point.x) * (q1.point.y - p1.point.y) - (q1.point.x - p1.point.x) * (p2.point.y - p1.point.y);
    CGFloat a2 = (p2.point.x - p1.point.x) * (q2.point.y - p1.point.y) - (q2.point.x - p1.point.x) * (p2.point.y - p1.point.y);
    
    CGFloat b1 = (q2.point.x - q1.point.x) * (p1.point.y - q1.point.y) - (p1.point.x - q1.point.x) * (q2.point.y - q1.point.y);
    CGFloat b2 = (q2.point.x - q1.point.x) * (p2.point.y - q1.point.y) - (p2.point.x - q1.point.x) * (q2.point.y - q1.point.y);
    
    if (a1 * a2 < 0 && b1 * b2 < 0 ) {
        //相交
        return YES;
    }
    //不相交
    return NO;
}

+ (double )polarTriangleAreaTan1:(double)tan1 lng1:(double)lng1 tan2:(double)tan2 lng2:(double)lng2{
    double deltaLng = lng1 - lng2;
    double t = tan1 * tan2;
    return 2 * atan2(t * sin(deltaLng), 1 + t * cos(deltaLng));
}
    

+ (double)toRadians:(double)input{
    return input / 180.0 * M_PI;
}
@end
