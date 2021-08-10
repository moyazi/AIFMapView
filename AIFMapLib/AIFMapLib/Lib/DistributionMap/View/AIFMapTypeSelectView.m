//
//  AIFMapTypeSelectView.m
//  AI_Farming
//
//  Created by moyazi on 2020/1/11.
//  Copyright © 2020 het. All rights reserved.
//

#import "AIFMapTypeSelectView.h"
#import "CommonHeader.h"
@interface  AIFMapTypeSelectView()
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIButton *standerBtn;
@property (nonatomic, strong) UIButton *satelliteBtn;
@end

@implementation AIFMapTypeSelectView

+ (AIFMapTypeSelectView *)getMapTypeViewBySuperView:(UIView *)view;{
    CGFloat width = 103*iPhone6BasicWidth;
    CGFloat height = 188*iPhone6BasicHeight;
    CGFloat x = CGRectGetMaxX(view.frame) - width;
    CGFloat y = NAVIBARHEIGHT+STATUSBARHEIGHT+50;
    AIFMapTypeSelectView *theView = [[AIFMapTypeSelectView alloc]initWithFrame:CGRectMake(x, y, width, height)];
    return theView;
}

-(void)setMapType:(int)mapType{
    _mapType = mapType;
    if (mapType) {
        self.satelliteBtn.selected = YES;
        self.standerBtn.selected = NO;
    }else{
        self.satelliteBtn.selected = NO;
        self.standerBtn.selected = YES;
    }
}

- (void)btnAction:(UIButton *)sender{
    NSInteger mapType = 0;
    if (sender == self.standerBtn) {
        [self.superview removeFromSuperview];
        mapType = 0;
    }
    
    if (sender == self.satelliteBtn) {
        [self.superview removeFromSuperview];
        mapType = 1;
    }
    
    if (self.mapTypeBlock) {
        self.mapTypeBlock(mapType);
    }
}

#pragma mark - setupUI
- (void)setupUI{
    [self addSubview:self.bgImageView];
    [self addSubview:self.standerBtn];
    [self addSubview:self.satelliteBtn];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    [self.standerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top).offset(10*iPhone6BasicHeight);
        make.bottom.equalTo(self.mas_centerY).offset(-iPhone6BasicHeight*5);
    }];
    
    [self.satelliteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom).offset(-5*iPhone6BasicHeight);
        make.top.equalTo(self.mas_centerY).offset(5*iPhone6BasicHeight);
    }];
}
#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self setupUI];
        //mapType 默认为2 卫星地图
        self.satelliteBtn.selected = YES;
    }
    return self;
}

- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"map_type_bg"]];
        _bgImageView = imageView;
    }
    return _bgImageView;
}

- (UIButton *)standerBtn{
    if (!_standerBtn) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"WorkPlatform_customMap"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"WorkPlatform_selectMap0"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _standerBtn = button;
    }
    return _standerBtn;
}

- (UIButton *)satelliteBtn{
    if (!_satelliteBtn) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"WorkPlatform_stateMap"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"WorkPlatform_selectMapguge"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _satelliteBtn = button;
    }
    return _satelliteBtn;
}

@end
