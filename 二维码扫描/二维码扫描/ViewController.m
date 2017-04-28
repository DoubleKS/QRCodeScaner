//
//  ViewController.m
//  二维码扫描
//
//  Created by doublek on 2017/4/26.
//  Copyright © 2017年 doublek. All rights reserved.
//

#import "ViewController.h"
#import "DKQRCodeScaner.h"
#import <SafariServices/SafariServices.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [[DKQRCodeScaner shareInstance] beginQRCodeScanWithPreView:self.view Completion:^(NSString *string) {
        
        if ([string hasPrefix:@"http://"]||[string hasPrefix:@"https://"]) {
            
            SFSafariViewController *safari = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:string]];
            
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:safari animated:YES completion:nil];
        }
        
    }];
 
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
