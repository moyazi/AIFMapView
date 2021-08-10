//
//  AIFBaselandAnnotationView.m
//  AI_Farming
//
//  Created by moyazi on 2019/12/25.
//  Copyright © 2019 het. All rights reserved.
//

#import "AIFBaselandAnnotationView.h"
#import "AIFBaselandDistrictsBaselandAnnotation.h"
#import "CommonHeader.h"

@interface AIFBaselandAnnotationView ()
@property (strong, nonatomic) UIImageView *iconView;
@property (strong, nonatomic) UILabel *baselandLabel;
@end

@implementation AIFBaselandAnnotationView
-(void)setModel:(AIFBaselandDistrictsBaselandAnnotation*)annotation{
//    self.iconView.image
    self.baselandLabel.text = annotation.baselandName;
}
#pragma mark - Life Cycle
- (id)initWithAnnotation:(AIFBaselandDistrictsBaselandAnnotation *)annotation reuseIdentifier:(NSString *)reuseIdentifier
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
    [self addSubview:self.baselandLabel];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(22*iPhone6BasicHeight);
        make.width.mas_equalTo(30*iPhone6BasicHeight);
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_centerY).offset(-2);
    }];
    
    [self.baselandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_centerY);//.offset(2);
        make.left.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-5);
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

- (UILabel *)baselandLabel
{
    if (!_baselandLabel) {
        _baselandLabel = [UILabel new];
        _baselandLabel.textAlignment = NSTextAlignmentCenter;
        _baselandLabel.numberOfLines = 2;
        _baselandLabel.textColor = [UIColor whiteColor];
        _baselandLabel.font = [UIFont systemFontOfSize:12];
    }
    return _baselandLabel;
}
@end
