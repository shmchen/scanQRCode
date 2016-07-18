//
//  QRCodeUtil.m
//  wenshuapp
//
//  Created by lawyee on 16/7/18.
//  Copyright © 2016年 LAWYEE. All rights reserved.
//

#import "QRCodeUtil.h"

@implementation QRCodeUtil

+ (UIImage *)generateQRCodeWithKey:(NSString *)key
{
    return [self generateQRCodeWithKey:key ImageSize:CGSizeMake(200, 200)];
}

+ (UIImage *)generateQRCodeWithKey:(NSString *)key ImageSize:(CGSize)size
{

    if (0 == key.length) {
        return nil;
    }
    
    // 1.创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.恢复默认
    [filter setDefaults];
    
    // 3.给过滤器添加数据
    NSString *dataString = key;
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    
    //因为生成的二维码模糊，所以通过createNonInterpolatedUIImageFormCIImage:outputImage来获得高清的二维码图片
    
    // 5.显示二维码
    return [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:size];
}

/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGSize) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size.width / CGRectGetWidth(extent), size.height / CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

+ (NSString *)deCodeWithQRCode:(UIImage *)image
{
    NSArray *resultArray = [self deCodeWithMultiQRCode:image];
    return [resultArray lastObject];
}

+ (NSArray<NSString *>*)deCodeWithMultiQRCode:(UIImage *)image
{
    //初始化一个监测器
    CIDetector*detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    
    //监测到的结果数组
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    
    if (!features.count) return nil;
    
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:features.count];
    
    for (CIQRCodeFeature *feature in features) {
        NSString *scanResult = feature.messageString;
        [resultArray addObject:scanResult];
    }
    
    return resultArray;
}

@end
