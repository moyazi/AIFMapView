//
//  CommonHeader.h
//  AI_Farming
//
//  Created by leoo on 2018/8/7.
//  Copyright © 2018年 polo. All rights reserved.
//

#import "Masonry.h"
#import "AIFMapTool.h"
#import "UIConfig.h"


#ifndef CommonHeader_h
#define CommonHeader_h

//Log打印不全的问题,大量数据的打印
#ifdef DEBUG
#define MyString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define MyLog(...) printf("%s 第%d行: %s\n\n",[MyString UTF8String] ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);
#else
#define MyLog(...)
#endif


//Log
#ifdef DEBUG
#define AIFLog(...) NSLog(__VA_ARGS__);
#define AIFDebugLog(fmt, ...) NSLog(fmt, ##__VA_ARGS__);
#define AIFLog_METHOD NSLog(@"%s", __func__);
#else
#define AIFLog(...);
#define AIFDebugLog(...);
#define AIFLog_METHOD;
#endif

//系统版本
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

//屏幕适配
#define iPhone6Width  375.0
#define iPhone6Height 667.0

#define iPhone6PWidth  414.0
#define iPhone6PHeight 736.0

#define isiPhone4 ([[UIScreen mainScreen] bounds].size.height <568)
#define isiPhone5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define isiPhone6 (([[UIScreen mainScreen] bounds].size.width>320)&&([[UIScreen mainScreen] bounds].size.width<=375))
#define isiPhone6Plus (([[UIScreen mainScreen] bounds].size.width>375)&&([[UIScreen mainScreen] bounds].size.width<=414))

//获取屏幕的物理高度 高度
#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define kSCreenScale  [UIScreen mainScreen].scale
#define nav_normal_height 44
#define nav_expand_height 62

//获取设备的中心X Y
#define SCREEN_WIDTH_2  SCREEN_WIDTH/2
#define SCREEN_HEIGHT_2 SCREEN_HEIGHT/2

#define SCREEN_WIDTH_3  SCREEN_WIDTH/3
//全局距左边的距离
#define Left_Inset 15.f
#define Right_Inset  -15.f


//常用高度
#define IPX_STATUSBAROFFSETHEIGHT   ((kDevice_Is_iPhoneX) ? 24.0 : 0.0)
#define IPX_HOMEINDICATORHEIGHT     ((kDevice_Is_iPhoneX) ? 34.0 : 0.0)

#define STATUSBARHEIGHT         (20.0 + IPX_STATUSBAROFFSETHEIGHT)
#define NAVIBARHEIGHT           44.0
#define TABBARHEIGHT            ((kDevice_Is_iPhoneX) ? 83.0 : 49.0)

//#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define kDevice_Is_iPhoneX ({\
int tmp = 0;\
if (@available(iOS 11.0, *)) {\
if ([UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom > 0) {\
tmp = 1;\
}else{\
tmp = 0;\
}\
}else{\
tmp = 0;\
}\
tmp;\
})

#define BottomOfView(view) (view.frame.origin.y+view.frame.size.height)

//Frame基础值
#define iphone5BasicHeight  (1/iPhone5Height*(isiPhone4?iPhone5Height:SCREEN_HEIGHT))
#define iphone5BasicWidth   (1/iPhone5Width*SCREEN_WIDTH)

#define iPhone6BasicHeight  (ScaleHeightFactor/iPhone6Height)
#define iPhone6BasicWidth   (1/iPhone6Width*SCREEN_WIDTH)

//iphone X高度不缩放
#define ScaleHeightFactor  ((SCREEN_HEIGHT>iPhone6PHeight)?iPhone6Height:SCREEN_HEIGHT)

#define SINGLE_LINE_WIDTH          (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET  ((1 / [UIScreen mainScreen].scale) / 2)

//安全赋值
#define NULL_NUMBER  @"null"
#define SAFE_STRING(str)    (![str isKindOfClass: [NSString class]] ? @"" : str)
#define SAFE_NUMBER(value)  (![value isKindOfClass: [NSNumber class]] ? @(-1) : value)


//语言类型
#define CURRENT_LANGUAGE_IS_CHINESE  ([[[NSLocale preferredLanguages] objectAtIndex:0] isEqualToString:@"zh-Hans"]||[[[NSLocale preferredLanguages] objectAtIndex:0] isEqualToString:@"zh-Hant"])

//UIColor
// rgb颜色转换（16进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define RGBCOLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define SAMERGB(R) RGBCOLOR(R, R, R, 1.0f)

#define KFONT(o) [UIFont systemFontOfSize:o]
#define KCOLOR(o) [UIConfig colorFromHexRGB:o]
#define GREENCOLOR [UIConfig colorFromHexRGB:@"2f7568"]
#define THEMECOLOR [UIConfig colorFromHexRGB:@"00C686"]
#define kPlaceholderImage [UIImage imageNamed:@"icon_placeholder"]
#define CHARTCOLOR RGBCOLOR(192, 244, 206, 0.8)
//Math
//角度获取弧度
#define DEGREES_TO_RADIAN(x)      (M_PI * (x) / 180.0)
//弧度获取角度
#define RADIAN_TO_DEGREES(radian) (radian*180.0)/(M_PI)

#define WEAKSELF typeof(self) __weak weakSelf = self;

#define AIFLocalizedString(defineString) NSLocalizedString(defineString, defineString)

//window
#define AppMainWindow  [[[UIApplication sharedApplication] delegate] window]
#define AppKeyWindow  [[[UIApplication sharedApplication] windows] firstObject]





















//全局头文件
#ifdef __OBJC__
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#endif
#endif /* CommonHeader_h */
