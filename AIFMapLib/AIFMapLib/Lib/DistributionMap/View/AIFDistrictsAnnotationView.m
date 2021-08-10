//
//  AIFDistrictsAnnotationView.m
//  AI_Farming
//
//  Created by moyazi on 2019/12/25.
//  Copyright © 2019 het. All rights reserved.
//

#import "AIFDistrictsAnnotationView.h"
#import "AIFBaselandDistrictsAnnotation.h"
#import "CommonHeader.h"
@interface AIFDistrictsAnnotationView ()
@property (strong, nonatomic) UIImageView *iconView;
@property (strong, nonatomic) UILabel *districtsLabel;
@property (strong, nonatomic) UILabel *countLabel;
@end

@implementation AIFDistrictsAnnotationView

- (void)setModel:(AIFBaselandDistrictsAnnotation *)annotation{
    AIFLog(@"%@",annotation.icon);
    WEAKSELF
    
//    self.iconView.image
    self.districtsLabel.text = annotation.districtsName;
    self.countLabel.text = [NSString stringWithFormat:@"%ld个",(long)annotation.count];
}

#pragma mark - Life Cycle
- (id)initWithAnnotation:(AIFBaselandDistrictsAnnotation *)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self configUI];
    }
    self.model = annotation;
    return self;
}


- (void)configUI{
    self.bounds = CGRectMake(0.f, 0.f, 64*iPhone6BasicWidth, 64*iPhone6BasicWidth);
    self.layer.cornerRadius = 32*iPhone6BasicWidth;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.7];
    [self addSubview:self.iconView];
    [self addSubview:self.districtsLabel];
    [self addSubview:self.countLabel];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(22*iPhone6BasicHeight);
        make.width.mas_equalTo(30*iPhone6BasicHeight);
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(5);
    }];
    
    [self.districtsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.countLabel.mas_top);
        make.left.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-5);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
        make.left.right.equalTo(self.districtsLabel);
    }];
}

- (UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [UIImageView new];
        _iconView.contentMode =  UIViewContentModeScaleAspectFill;
        _iconView.image = [UIImage imageNamed:@"BaselandLocatedBaselandIcon"];
    }
    return _iconView;
}

- (UILabel *)districtsLabel
{
    if (!_districtsLabel) {
        _districtsLabel = [UILabel new];
        _districtsLabel.textAlignment = NSTextAlignmentCenter;
        _districtsLabel.textColor = [UIColor whiteColor];
        _districtsLabel.font = [UIFont systemFontOfSize:11];
    }
    return _districtsLabel;
}

- (UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [UILabel new];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.font = [UIFont systemFontOfSize:11];
    }
    return _countLabel;
}

@end
