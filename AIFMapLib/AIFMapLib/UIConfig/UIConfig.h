//
//  UIConfig.h
//  AI_Farming
//
//  Created by polo on 2018/8/2.
//  Copyright © 2018年 polo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum  {
    topToBottom = 0,//从上到小
    leftToRight = 1,//从左到右
    upleftTolowRight = 2,//左上到右下
    uprightTolowLeft = 3,//右上到左下
}GradientType;

@interface UIConfig : NSObject


/**
 获取颜色

 @param hexColor 6位的16进制色值  @"ffffff"
 @return 颜色
 */
+ (UIColor *) getColor:(NSString *)hexColor;

+ (UIColor *) colorFromHexRGB:(NSString *) inColorString;

+ (UIColor *) colorFromHexRGB:(NSString *) inColorString alpha:(CGFloat)colorAlpha;

+ (UIColor *)randomColor;

+(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size;


/**
 获取纯色图片

 @param color 纯色
 @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  添加水印图片
 */
+ (UIImage *)addImage:(UIImage *)useImage addImage1:(UIImage *)addImage1;

//根据颜色生成image
+ (UIImage*) ImageFromColors:(NSArray*)colors ByGradientType:(GradientType)gradientType ImageSize:(CGSize)imageSize;

//根据字符串和字体及最大长度生成字符串的size,适配IOS8
+(CGSize)sizeWithString:(NSString *)string Font:(UIFont*)font maxSize:(CGSize)maxsize;

//根据字体号计算字体的高度
+(CGFloat)HeightWithFont:(CGFloat)fontsize;

//图片缓存
+(UIImage *)getImageWithUrl:(NSString *)UrlStr;

+ (void)setExtraCellLineHidden: (UITableView *)mytableView;

+ (NSData *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

+(UIImage *)stretchableImageWithImgae:(NSString *)name;
@end
