# scanQRCode
原生的二维码相关demo

#####功能
- 二维码扫描控制器ScanQRCodeController
    + 扫描聚焦范围限制
    + 扫描成功语音提示
    + 扫描结果回调
- 二维码工具类QRCodeUtil
    + 支持二维码生成
    + 支持从图片中解析二维码（可以解析一张图片包含多个二维码）

#####使用
- 直接把整个目录拉近项目中即可
- 扫描二维码，直接使用快速构造方法创建控制器对象，扫描到结果会执行scanSuccess
- 生成二维码与解析图片中二维码均是类方法