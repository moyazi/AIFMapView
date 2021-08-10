//
//  AIFBaseDrawViewStateObject.m
//  AIFMapLib
//
//  Created by moyazi on 2020/2/12.
//  Copyright © 2020 moyazi. All rights reserved.
//

#import "AIFBaseDrawViewStateObject.h"
#import "AIFMapTool.h"

@implementation AIFBaseDrawPointObject

@end



@interface AIFBaseDrawViewStateObject ()
@property (assign, nonatomic ,readwrite) BOOL legitimate;//当前图形是否合法
@end

@implementation AIFBaseDrawViewStateObject


- (void)checkLegitimate{
    self.legitimate = YES;
    if (self.orignalPoints.count < 2) {
        return;
    }
    NSMutableArray *lines = [NSMutableArray array];
    for (int i = 0; i < self.orignalPoints.count -1; i++) {
        AIFBaseDrawPointObject *p1 = self.orignalPoints[i];
        AIFBaseDrawPointObject *p2 = self.orignalPoints[i+1];
        NSArray *line = [NSArray arrayWithObjects:p1,p2, nil];
        [lines addObject:line];
    }
    if (self.close) {
        //加上起点到终点的线
        NSArray *line = [NSArray arrayWithObjects:self.orignalPoints.lastObject,self.orignalPoints.firstObject, nil];
        [lines addObject:line];
    }
    for (int i = 0; i < lines.count - 1; i++) {
        NSArray *line1 = lines[i];
        for (int j = i+1; j < lines.count ; j++) {
            NSArray *line2 = lines[j];
            BOOL result = [AIFMapTool isIntersectByCoorLine1:line1 line2:line2];
            if (result) {
                self.legitimate = NO;
                break;
            }
        }
    }
}




@end
