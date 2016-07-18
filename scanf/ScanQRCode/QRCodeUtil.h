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


@end
