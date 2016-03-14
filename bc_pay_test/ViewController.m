//
//  ViewController.m
//  bc_pay_test
//
//  Created by yl on 16/2/29.
//  Copyright © 2016年 yl. All rights reserved.
//

#import "ViewController.h"
#import "PaymentMethodViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setPayUI];
    [self setBeeCloud];
}

- (void)setBeeCloud {
    /*
    [BeeCloud setBeeCloudDelegate:self];
    NSArray *tempArray = @[@{@"channel":@"线上支付",
                             @"subChannel":@[@{@"sub":@(PayChannelWxApp), @"img":@"wx", @"title":@"微信APP支付"},
                                             @{@"sub":@(PayChannelAliApp), @"img":@"ali", @"title":@"支付宝APP支付"},
                                             @{@"sub":@(PayChannelUnApp), @"img":@"un", @"title":@"银联在线"},
                                             @{@"sub":@(PayChannelBaiduApp), @"img":@"baidu", @"title":@"百度钱包"},
                                             @{@"sub":@(PayChannelPayPal), @"img":@"paypal", @"title":@"PayPal"}
                                             ]},
                           @{@"channel":@"线下收款",
                             @"subChannel":@[@{@"sub":@(PayChannelWxNative), @"img":@"wx", @"title":@"微信扫码支付"},
                                             @{@"sub":@(PayChannelWxScan), @"img":@"wx", @"title":@"微信刷卡支付"},
                                             @{@"sub":@(PayChannelAliOfflineQrCode), @"img":@"ali", @"title":@"支付宝扫码支付"},
                                             @{@"sub":@(PayChannelAliScan), @"img":@"ali", @"title":@"支付宝条码支付"}]}
                           ];

     */
}

- (void)setPayUI {
    //
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(10, 200, 200, 30)];
    tf.placeholder = @"支付金额，默认0.01";
    tf.tag = 100;
    tf.keyboardType = UIKeyboardTypeDecimalPad;
    tf.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:tf];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(250, 200, 60, 30);
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [button setTitle:@"付款" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}


- (void)payAction {
    PaymentMethodViewController *pm = [[PaymentMethodViewController alloc] init];
    //[self.navigationController pushViewController:pm animated:YES];
    UITextField *tf = [self.view viewWithTag:100];
    if (tf.text.length) {
        pm.price = tf.text;
    } else {
        pm.price = @"1";
    }
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:pm];
    [self presentViewController:nc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
