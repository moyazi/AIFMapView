//
//  AIFBaselandDistrictsModel.h
//  AI_Farming
//
//  Created by moyazi on 2019/12/25.
//  Copyright © 2019 het. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@class AIFBaseLandDetailModel;

@interface AIFBaselandDistrictsModel : NSObject
@property (copy, nonatomic) NSNumber *baselandNum;
@property (copy, nonatomic) NSString *regionName;
@property (copy, nonatomic) NSNumber *longitude;
@property (copy, nonatomic) NSNumber *latitude;
@property (copy, nonatomic) NSString *cropIcon;
@property (strong, nonatomic) NSArray<AIFBaselandDistrictsModel*> *districts;
@property (strong, nonatomic) NSArray<AIFBaseLandDetailModel*> *baselandMapBriefInfoList;

@end

NS_ASSUME_NONNULL_END
