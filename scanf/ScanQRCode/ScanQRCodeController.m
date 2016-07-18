//  扫描二维码的控制器
//  SMScanQRCoreController.h
//
//
//  Created by 陈沈明 on 15/3/5.
//  Copyright © 2015年 white_screen@163.com. All rights reserved.
//

#import "ScanQRCodeController.h"
#import <AVFoundation/AVFoundation.h>

#define ALERTVIEW_TAG 998

@interface ScanQRCodeController ()<AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate>

//用于处理采集信息的代理
{
    AVCaptureSession * session;//输入输出的中间桥梁
}

/**
 *  扫描成功后执行该block代码
 */
@property (copy, nonatomic) ScanSuccess scanSuccess;

//扫描条
@property (nonatomic, weak) UIImageView *lineImage;
//是否正在扫描
@property (nonatomic, assign) BOOL isScanning;

@end

@implementation ScanQRCodeController

//类工厂方法
+ (ScanQRCodeController *)scanQRCodeControllerWithHandle:(ScanSuccess)scanSuccess
{
    ScanQRCodeController *scanVc = [[ScanQRCodeController alloc] init];
    scanVc.scanSuccess = scanSuccess;
    return scanVc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self setupNav];
    
    [self initScan];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    self.isScanning = YES;
}

-(void)setupNav{
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.title = @"二维码/条码";
    //返回按钮
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
    [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
}

- (void)initScan
{
    
    BOOL flag = [self ValidatePermission];
    
    if (NO == flag) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请在设备的\"设置-隐私-相机\"中允许访问相机。" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = ALERTVIEW_TAG;
        alert.delegate = self;
        [alert show];
        
        return;
    }
    
    //添加扫描框
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scanning"]];
    [self.view addSubview:imageView];
    imageView.center = self.view.center;
    
    CGSize imageSize = imageView.frame.size;
    CGSize screenWH = [UIScreen mainScreen].bounds.size;
    
    //添加扫描条
    UIImageView *lineImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scanning_line"]];
    [imageView addSubview:lineImage];
    self.lineImage = lineImage;
    
    //添加扫描条动画
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    anim.toValue = @(imageSize.height - 7);
    anim.repeatCount = CGFLOAT_MAX;
    anim.duration = 3.5;
    [lineImage.layer addAnimation:anim forKey:nil];
    
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!device){//无摄像头弹窗提示
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未检测到摄像头设备" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    };
    
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [session addInput:input];
    [session addOutput:output];
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    //设置可扫描区域
    CGFloat x = (screenWH.height - imageSize.height) / 2 / screenWH.height;
    CGFloat y = (screenWH.width - imageSize.width) / 2 /screenWH.width;
    CGFloat width = imageSize.height / screenWH.height;
    CGFloat height = imageSize.width / screenWH.width;
    output.rectOfInterest= CGRectMake(x, y, width, height);
    
    //添加扫描图层
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    
    //开始捕获
    [session startRunning];
}

// 验证权限
- (BOOL)ValidatePermission
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];

    if (authStatus == AVAuthorizationStatusAuthorized) {
        return YES;
    }
    
    return NO;
}

-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//
//    if (!self.isScanning) {
//        //重新开始捕获
//        [session startRunning];
//        //重启扫描条动画
//        [self resumeLayer:self.lineImage.layer];
//        self.isScanning = YES;
//    }
//}

#pragma mark - 扫描结果的代理方法
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        //停止扫描
        [session stopRunning];
        //暂停扫描条动画
        [self pauseLayer:self.lineImage.layer];
        self.isScanning = NO;
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        
        //获取到二维码信息
        [self getQRCodestring:metadataObject.stringValue];

    }
}

#pragma mark - alertView的代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (ALERTVIEW_TAG == alertView.tag && buttonIndex == 1) {
        
        NSURL *settingUrl = [NSURL URLWithString:@"prefs:root=com.lawyee.wenshuapp"];

        // 打开APP相关隐私设置
        if ([[UIApplication sharedApplication] canOpenURL:settingUrl
            ]) {
            [[UIApplication sharedApplication] openURL:settingUrl];
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 图层动画暂停、重启
//暂停图层动画
- (void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

//继续layer上面的动画
- (void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

#pragma mark - 播放音效
/**
 *  播放音效文件
 *
 *  @param name 音频文件名称
 */
-(void)playSoundEffect:(NSString *)name{
    NSString *audioFile=[[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl=[NSURL fileURLWithPath:audioFile];
    //1.获得系统声音ID
    SystemSoundID soundID=0;
    /**
     * inFileUrl:音频文件url
     * outSystemSoundID:声音id（此函数会将音效文件加入到系统音频服务中并返回一个长整形ID）
     */
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    //如果需要在播放完之后执行某些操作，可以调用如下方法注册一个播放完成回调函数
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    //2.播放音频
    AudioServicesPlaySystemSound(soundID);//播放音效
    //    AudioServicesPlayAlertSound(soundID);//播放音效并震动
}

/**
 *  播放完成回调函数
 *
 *  @param soundID    系统声音ID
 *  @param clientData 回调时传递的数据
 */
void soundCompleteCallback(SystemSoundID soundID,void * clientData){
    NSLog(@"播放完成...");
}

#pragma mark - 拿到数据可以在该方法doSomething.............
//获取到二维码信息
- (void)getQRCodestring:(NSString *)QRCodestring
{
    //doSomething.............
    //输出扫描字符串
    NSLog(@"%@",QRCodestring);

    // 播放音效
    [self playSoundEffect:@"qrcode_found.wav"];
    
    //执行block
    if (self.scanSuccess) {
        self.scanSuccess(self, QRCodestring);
    }

}
@end
