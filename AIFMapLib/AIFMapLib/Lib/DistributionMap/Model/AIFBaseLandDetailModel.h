//
//  AIFBaseLandDetailModel.h
//  AIFMapLib
//
//  Created by moyazi on 2020/2/12.
//  Copyright © 2020 moyazi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AIFBaseLandDetailModel : NSObject
@property (copy, nonatomic) NSString *cropIcon;
@property (nonatomic, strong) NSString *baselandName; // 基地名
@property (assign, nonatomic) BOOL isDemoData;
@property (nonatomic, strong) NSString *longitude; // 经度
@property (nonatomic, strong) NSString *latitude; // 纬度
@property (copy, nonatomic)   NSNumber *baselandId;
@end

NS_ASSUME_NONNULL_END
