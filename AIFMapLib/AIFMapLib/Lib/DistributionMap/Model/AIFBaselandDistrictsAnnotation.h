//
//  AIFBaselandDistrictsAnnotation.h
//  AI_Farming
//
//  Created by moyazi on 2019/12/25.
//  Copyright © 2019 het. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AIFBaselandDistrictsAnnotation : MAPointAnnotation
@property (copy, nonatomic) NSString *icon;//作物icon
@property (copy, nonatomic) NSString *districtsName;//区域名称
@property (assign, nonatomic) NSInteger count;//基地数目
@end

NS_ASSUME_NONNULL_END
