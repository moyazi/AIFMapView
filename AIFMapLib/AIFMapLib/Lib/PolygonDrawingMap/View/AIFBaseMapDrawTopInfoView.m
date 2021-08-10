//
//  AIFBaseMapDrawTopInfoView.m
//  AIFMapLib
//
//  Created by moyazi on 2020/2/12.
//  Copyright © 2020 moyazi. All rights reserved.
//

#import "AIFBaseMapDrawTopInfoView.h"
#import "CommonHeader.h"


@implementation AIFBaseMapDrawTopInfoView

+ (AIFBaseMapDrawTopInfoView *)getMapDrawTopView{
    AIFBaseMapDrawTopInfoView *view = [[AIFBaseMapDrawTopInfoView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, STATUSBARHEIGHT+20+40)];
    view.backgroundColor = RGBCOLOR(0, 0, 0, 0.5);
    return view;
}

#pragma mark - setupUI

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.perimeterLabel];
    [self addSubview:self.areaLabel];
    [self addSubview:self.confirmBtn];
    
    [self.perimeterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_centerX).offset(-3);
        make.centerY.equalTo(self.confirmBtn);
    }];
    [self.areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_centerX).offset(3);
        make.centerY.equalTo(self.confirmBtn);
    }];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-17);
        make.width.mas_equalTo(64);
        make.height.mas_equalTo(33);
        make.centerY.equalTo(self.mas_bottom).offset(-30);
    }];
}



- (UILabel *)areaLabel{
    if (!_areaLabel) {
        UILabel *label = [UILabel new];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12];
        label.text = @"面积:0亩";
        _areaLabel = label;
    }
    return _areaLabel;
}
- (UILabel *)perimeterLabel{
    if (!_perimeterLabel) {
        UILabel *label = [UILabel new];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12];
        label.text = @"周长:0米";
        _perimeterLabel = label;
    }
    return _perimeterLabel;
}

- (UIButton *)confirmBtn{
    if (!_confirmBtn) {
        UIButton *button = [[UIButton alloc]init];
        
//        [button setBackgroundImage:SAMERGB(137) forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor blueColor]];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.layer.cornerRadius = 5.f;
        button.layer.masksToBounds = YES;
        _confirmBtn = button;
    }
    return _confirmBtn;
}


@end
