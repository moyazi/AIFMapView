//
//  AIFBaseMapDrawTopInfoView.h
//  AIFMapLib
//
//  Created by moyazi on 2020/2/12.
//  Copyright © 2020 moyazi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AIFBaseMapDrawTopInfoView : UIView
@property (strong, nonatomic) UILabel *areaLabel;
@property (strong, nonatomic) UILabel *perimeterLabel;
@property (strong, nonatomic) UIButton *confirmBtn;
+ (AIFBaseMapDrawTopInfoView *)getMapDrawTopView;
@end

NS_ASSUME_NONNULL_END
