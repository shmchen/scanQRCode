//
//  ViewController.m
//  scanf
//
//  Created by 123456 on 15/12/5.
//  Copyright © 2015年 123456. All rights reserved.
//

#import "ViewController.h"
#import "SMScanQRCodeController.h"
@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    SMScanQRCodeController *scan = [[SMScanQRCodeController alloc] init];
    [self presentViewController:scan animated:YES completion:nil];

}

@end