//
//  QRCodeUtil.h
//  wenshuapp
//
//  Created by lawyee on 16/7/18.
//  Copyright © 2016年 LAWYEE. All rights reserved.
//  二维码生成工具

#import <UIKit/UIKit.h>

@interface QRCodeUtil : NSObject

/**
 *  生成默认200 * 200的二维码图片
 *
 *  @param key 关键字
 *
 *  @return 二维码图片
 */
+ (UIImage *)generateQRCodeWithKey:(NSString *)key;

/**
 *  生成定制大小的二维码图片
 *
 *  @param key  关键字
 *  @param size 指定图片大小
 *
 *  @return 二维码图片
 */
+ (UIImage *)generateQRCodeWithKey:(NSString *)key ImageSize:(CGSize)size;

/**
 *  根据二维码图片生成一个解析后的结果字符串
 *
 *  @param image 包含一个二维码的图片
 *
 *  @return 返回解析出来的字符串，如果不包含信息返回nil
 */
+ (NSString *)deCodeWithQRCode:(UIImage *)image;

/**
 *  根据二维码图片生成解析后的结果字符串结果数组
 *
 *  @param image 包含多个二维码的图片
 *
 *  @return 返回解析出来的字符串数组，如果不包含信息返回nil
 */
+ (NSArray<NSString *>*)deCodeWithMultiQRCode:(UIImage *)image;

@end
