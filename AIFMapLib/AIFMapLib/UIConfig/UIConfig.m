//
//  UIConfig.m
//  AI_Farming
//
//  Created by polo on 2018/8/2.
//  Copyright © 2018年 polo. All rights reserved.
//

#import "UIConfig.h"

@implementation UIConfig

+ (UIColor *)getColor:(NSString *)hexColor
{
    if (hexColor.length < 6) {
        return nil;
    }
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:1.0f];
}

+ (UIColor *) colorFromHexRGB:(NSString *) inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}

+ (UIColor *) colorFromHexRGB:(NSString *) inColorString alpha:(CGFloat)colorAlpha {
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:colorAlpha];
    return result;
}

+ (UIColor *)randomColor{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

//缩放图片以充满整个屏幕
+(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}


+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 @ 加水印图片
 */
+ (UIImage *)addImage:(UIImage *)useImage addImage1:(UIImage *)addImage1
{
    UIGraphicsBeginImageContext(useImage.size);
    [useImage drawInRect:CGRectMake(0, 0, useImage.size.width, useImage.size.height)];
    [addImage1 drawInRect:CGRectMake((useImage.size.width - addImage1.size.width/2) / 2, useImage.size.height-addImage1.size.height/2 -5, addImage1.size.width/2, addImage1.size.height/2)];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

//根据颜色生成image
+ (UIImage*) ImageFromColors:(NSArray*)colors ByGradientType:(GradientType)gradientType ImageSize:(CGSize)imageSize
{
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
            case topToBottom:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, imageSize.height);
            break;
            case leftToRight:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imageSize.width, 0.0);
            break;
            case upleftTolowRight:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imageSize.width, imageSize.height);
            break;
            case uprightTolowLeft:
            start = CGPointMake(imageSize.width, 0.0);
            end = CGPointMake(0.0, imageSize.height);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

+(CGSize)sizeWithString:(NSString *)string Font:(UIFont*)font maxSize:(CGSize)maxsize{
    if (![string isKindOfClass:[NSString class]]) {
        return CGSizeZero;
    }
    CGRect rect = [string boundingRectWithSize:maxsize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return CGSizeMake(CGRectGetWidth(rect), CGRectGetHeight(rect));
}
//根据字体号获取字体的高度
+(CGFloat)HeightWithFont:(CGFloat)fontsize{
    return [self sizeWithString:@"test" Font:[UIFont systemFontOfSize:fontsize] maxSize:CGSizeMake(150, 150)].height;
}

//图片缓存
+(UIImage *)getImageWithUrl:(NSString *)UrlStr{
    UIImage *image ;
    NSString * documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    documentPath = [documentPath stringByAppendingPathComponent:[UrlStr stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];
    NSData * avatar = [NSData dataWithContentsOfFile:documentPath];
    
    if (avatar==nil) {
        if (UrlStr&&![UrlStr isEqualToString:@""]) {
            avatar = [NSData dataWithContentsOfURL:[NSURL URLWithString:UrlStr]];
            image = [UIImage imageWithData:avatar];
            [avatar writeToFile:documentPath atomically:YES];
        }
        else{
            image = nil;
        }
    }
    else{
        image = [UIImage imageWithData:avatar];
    }
    return image;
}

//去除tableview空cell的line
+ (void)setExtraCellLineHidden: (UITableView *)mytableView
{
    UIView *view =[[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [mytableView setTableFooterView:view];
}

// ------这种方法对图片既进行压缩，又进行裁剪
+ (NSData *)imageWithImage:(UIImage*)image scaledToSize:(CGSize) newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.8);
}


/**
 *  返回一张可以随意拉伸不变形的图片
 *  @param name 图片名字
 */
+(UIImage *)stretchableImageWithImgae:(NSString *)name{
    
    UIImage *normal = [UIImage imageNamed:name];
    CGFloat w = normal.size.width * 0.5;
    CGFloat h = normal.size.height * 0.5;
    return [normal stretchableImageWithLeftCapWidth:w topCapHeight:h];
}

@end
