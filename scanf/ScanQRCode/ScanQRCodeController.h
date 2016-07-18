//  扫描二维码的控制器
//  SMScanQRCoreController.h
//
//
//  Created by 陈沈明 on 15/3/5.
//  Copyright © 2015年 white_screen@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ScanQRCodeController;
typedef void (^ScanSuccess)(ScanQRCodeController *QRCodeVc, NSString *scanfResult);
@interface ScanQRCodeController : UIViewController

/**
 *  快速构造方法
 *
 *  @param scanSuccess 扫描成功后回调block
 *
 *  @return ScanQRCodeController class
 */
+ (ScanQRCodeController *)scanQRCodeControllerWithHandle:(ScanSuccess)scanSuccess;

@end
