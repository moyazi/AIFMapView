//
//  AIFBaselandDistrictsBaselandAnnotation.h
//  AI_Farming
//
//  Created by moyazi on 2019/12/25.
//  Copyright © 2019 het. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AIFBaselandDistrictsBaselandAnnotation : MAPointAnnotation
@property (copy, nonatomic) NSString *icon;//作物icon
@property (copy, nonatomic) NSString *baselandName;//基地名称
@property (copy, nonatomic) NSNumber *baselandId;//基地id

@property (assign, nonatomic) BOOL isDemoData;//基地id
@end

NS_ASSUME_NONNULL_END
