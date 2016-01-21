//  扫描二维码的控制器
//  SMScanQRCoreController.h
//
//
//  Created by 陈沈明 on 15/3/5.
//  Copyright © 2015年 white_screen@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ScanSuccess)(NSString *scanfResult);
@interface SMScanQRCodeController : UIViewController
/**
 *  扫描成功后执行该block代码
 */
@property (copy, nonatomic) ScanSuccess scanSuccess;

+ (SMScanQRCodeController *)scanQRCodeControllerWithScanSuccessExecute:(ScanSuccess)scanSuccess;

@end
