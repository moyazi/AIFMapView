//
//  AIFMapTypeSelectView.h
//  AI_Farming
//
//  Created by moyazi on 2020/1/11.
//  Copyright © 2020 het. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AIFMapTypeSelectView : UIView
@property (nonatomic, assign) int mapType;

@property (copy, nonatomic) void(^mapTypeBlock)(NSInteger);

+ (AIFMapTypeSelectView *)getMapTypeViewBySuperView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
