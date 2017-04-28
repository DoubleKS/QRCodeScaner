//
//  DKQRCodeScaner.h
//  二维码扫描
//
//  Created by doublek on 2017/4/26.
//  Copyright © 2017年 doublek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface DKQRCodeScaner : NSObject

//将 DKQRCodeScaner 封装成一个单例类
+(instancetype)shareInstance;

-(void)beginQRCodeScanWithPreView:(UIView *)preView Completion:(void (^)(NSString *string))block;


@end
