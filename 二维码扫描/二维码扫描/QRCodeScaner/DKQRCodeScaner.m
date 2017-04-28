//
//  DKQRCodeScaner.m
//  二维码扫描
//
//  Created by doublek on 2017/4/26.
//  Copyright © 2017年 doublek. All rights reserved.
//

#import "DKQRCodeScaner.h"
#import <AVFoundation/AVFoundation.h>

@interface DKQRCodeScaner ()<AVCaptureMetadataOutputObjectsDelegate>

//输入设备 (摄像头,麦克风)
@property(nonatomic,strong)AVCaptureDeviceInput *captureDeviceInput;
//输出设备: 二维码的原理就是用摄像头捕捉信心流
@property(nonatomic,strong)AVCaptureMetadataOutput *captureMetadataOutput;
//拍摄会话
@property(nonatomic,strong)AVCaptureSession *captureSession;

//扫描完成回调
@property(nonatomic,strong)AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

//定义一个block的属性来保存信息
@property(nonatomic,copy)void(^block)(NSString *);

@end

@implementation DKQRCodeScaner

+(instancetype)shareInstance{
    
    static DKQRCodeScaner *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[DKQRCodeScaner alloc]init];
    });
    
    return manager;
}

-(void)beginQRCodeScanWithPreView:(UIView *)preView Completion:(void (^)(NSString *string))block{
    
    //创建设备 defaultDeviceWithMediaType: 根据多媒体类型创建默认的设备(有前后摄像头,一般默认为后摄像头)
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //创建输入设备
    self.captureDeviceInput = [[AVCaptureDeviceInput alloc]initWithDevice:device error:nil];
    
    //创建输出设备
    self.captureMetadataOutput = [[AVCaptureMetadataOutput alloc]init];
    
    //设置输出设备的代理(当摄像头捕捉到数据通过代理告知APP)
    [self.captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //拍摄会话
    self.captureSession = [[AVCaptureSession alloc]init];
    
    //添加设备之前要做一个能添加的判断: 1 硬件的损坏 2 模拟器
    if ([self.captureSession canAddInput:self.captureDeviceInput]) {
        
        [self.captureSession addInput:self.captureDeviceInput];
    }
    //判断设备是否可以输出
    if ([self.captureSession canAddOutput:self.captureMetadataOutput]) {
        [self.captureSession addOutput:self.captureMetadataOutput];
    }
    
    //设置输出设备捕捉信息流类型:这是一个数组 AVMetadataObjectTypeQRCode二维码  AVMetadataObjectTypeEAN13Code：中国常用的一维码
    /*注意！！！！！  输出设备要先添加到拍摄会话中才可以设置捕捉类型，否会崩溃报错：[AVCaptureMetadataOutput setMetadataObjectTypes:] - unsupported type found.  Use -availableMetadataObjectTypes*/
    [self.captureMetadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code]];
    
    //预览图层
    self.captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession];
    
    //layer本身不能直接显示,需要添加到视图中
    [preView.layer addSublayer:self.captureVideoPreviewLayer];
    
    self.captureVideoPreviewLayer.bounds = preView.bounds;
    
    self.captureVideoPreviewLayer.anchorPoint = CGPointMake(0, 0);
    
    //开启拍摄会话
    [self.captureSession startRunning];
    
    self.block = block;
}
#pragma mark - AVCaptureMetadataOutputObjectsDelegate 代理方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    //AVMetadataMachineReadableCodeObject
    for (AVMetadataMachineReadableCodeObject *object in metadataObjects) {
        
//        NSLog(@"%@",object);
        if (self.block) {
           //将捕捉到的数据通过block传出去
            self.block(object.stringValue);
        }
        
    }
    
}


@end
