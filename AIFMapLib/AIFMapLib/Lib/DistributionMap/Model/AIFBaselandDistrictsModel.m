//
//  AIFBaselandDistrictsModel.m
//  AI_Farming
//
//  Created by moyazi on 2019/12/25.
//  Copyright © 2019 het. All rights reserved.
//

#import "AIFBaselandDistrictsModel.h"
#import "AIFBaseLandDetailModel.h"


@implementation AIFBaselandDistrictsModel
- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"districts"]) {
        NSMutableArray *list = [NSMutableArray new];
        for (NSDictionary *dic  in value) {
            AIFBaselandDistrictsModel *model = [[AIFBaselandDistrictsModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [list addObject:model];
        }
        self.districts = list;
        return;
    }
    
    if ([key isEqualToString:@"baselandMapBriefInfoList"]) {
        NSMutableArray *list = [NSMutableArray new];
        for (NSDictionary *dic  in value) {
            AIFBaseLandDetailModel *model = [[AIFBaseLandDetailModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [list addObject:model];
        }
        self.baselandMapBriefInfoList = list;
        return;
    }
    
    [super setValue:value forKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}


@end
