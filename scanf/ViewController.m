//
//  ViewController.m
//  scanf
//
//  Created by 123456 on 15/12/5.
//  Copyright © 2015年 123456. All rights reserved.
//

#import "ViewController.h"
#import "ScanQRCodeController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    __weak typeof(self) weakSelf = self;
    ScanQRCodeController *scanQRCodeVc = [ScanQRCodeController scanQRCodeControllerWithHandle:^(ScanQRCodeController *QRCodeVc, NSString *scanfResult) {
        
        [weakSelf getScanfResult:scanfResult ScanQRCodeController:QRCodeVc];
    }];

    
    [self presentViewController:scanQRCodeVc animated:YES completion:nil];

}

#pragma mark - 处理扫描二维码的结果
- (void)getScanfResult:(NSString *)scanfResultStr ScanQRCodeController:(UIViewController *)QRCodeVc
{
    
    [QRCodeVc dismissViewControllerAnimated:YES completion:^{
        NSLog(@"扫描结果是%@",scanfResultStr);
    }];
    
    
}


@end
