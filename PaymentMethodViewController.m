//
//  PaymentMethodViewController.m
//  bc_pay_test
//
//  Created by yl on 16/2/29.
//  Copyright © 2016年 yl. All rights reserved.
//

#import "PaymentMethodViewController.h"
#import "BeeCloud.h"
#import "PayPalMobile.h"
#import "AFNetworking.h"
#import "BCOffinePay.h"

@interface PaymentMethodViewController () <BeeCloudDelegate> {
    PayPalConfiguration * _payPalConfig;
    PayPalPayment *_completedPayment;
    NSArray *dataArray;
    NSArray *_paychannelArray;
}
@property (strong, nonatomic) BCBaseResp *orderList;


@end

@implementation PaymentMethodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = @[@"支付宝",@"微信",@"paypal"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [BeeCloud setBeeCloudDelegate:self];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseID = @"323";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    cell.textLabel.text = dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            //支付宝
            [self alipayPay];
            break;
        case 1:
            //微信
            [self weixinPay];
            break;
        default:
            //paypal
            [self paypalPay];
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)alipayPay {
    [self doPay:PayChannelAliApp];
}

- (void)weixinPay {
    [self doPay:PayChannelWxApp];
}

- (void)paypalPay {
    [self doPayPal];
}

#pragma mark - 生成订单号
- (NSString *)genBillNo {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    return [formatter stringFromDate:[NSDate date]];
}

#pragma mark - 微信、支付宝、银联、百度钱包
- (void)doPay:(PayChannel)channel {
    NSString *billno = [self genBillNo];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"value",@"key", nil];
    /**
     按住键盘上的option键，点击参数名称，可以查看参数说明
     **/
    BCPayReq *payReq = [[BCPayReq alloc] init];
    payReq.channel = channel; //支付渠道
    payReq.title = @"支付测试";//订单标题
    payReq.totalFee = @"1";//订单价格
    payReq.billNo = billno;//商户自定义订单号
    payReq.scheme = @"payDemo";//URL Scheme,在Info.plist中配置; 支付宝必有参数
    payReq.billTimeOut = 300;//订单超时时间
    payReq.viewController = self; //银联支付和Sandbox环境必填
    payReq.optional = dict;//商户业务扩展参数，会在webhook回调时返回
    [BeeCloud sendBCReq:payReq];
}



#pragma mark - PayPal Pay
- (void)doPayPal {
    BCPayPalReq *payReq = [[BCPayPalReq alloc] init];
    _payPalConfig = [[PayPalConfiguration alloc] init];
    _payPalConfig.acceptCreditCards = YES;
    _payPalConfig.merchantName = @"Awesome Shirts, Inc.";
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    
    PayPalItem *item1 = [PayPalItem itemWithName:@"Old jeans with holes"
                                    withQuantity:2
                                       withPrice:[NSDecimalNumber decimalNumberWithString:@"0.00"]
                                    withCurrency:@"USD"
                                         withSku:@"Hip-00037"];
    
    PayPalItem *item2 = [PayPalItem itemWithName:@"Free rainbow patch"
                                    withQuantity:1
                                       withPrice:[NSDecimalNumber decimalNumberWithString:@"0.00"]
                                    withCurrency:@"USD"
                                         withSku:@"Hip-00066"];
    
    PayPalItem *item3 = [PayPalItem itemWithName:@"Long-sleeve plaid shirt (mustache not included)"
                                    withQuantity:1
                                       withPrice:[NSDecimalNumber decimalNumberWithString:@"0.01"]
                                    withCurrency:@"USD"
                                         withSku:@"Hip-00291"];
    payReq.items = @[item1, item2, item3];
    payReq.shipping = @"0.00";
    payReq.tax = @"0.00";
    payReq.shortDesc = @"呵呵呵呵呵呵";
    payReq.viewController = self;
    payReq.payConfig = _payPalConfig;
    [BeeCloud sendBCReq:payReq];
}

#pragma mark - PayPal Verify
- (void)doPayPalVerify {
    BCPayPalVerifyReq *req = [[BCPayPalVerifyReq alloc] init];
    req.payment = _completedPayment;
    req.optional = @{@"key1":@"value1"};
    [BeeCloud sendBCReq:req];
}

#pragma mark - PayPalPaymentDelegate

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success! %@", completedPayment.description);
    
    _completedPayment = completedPayment;
    
    [self doPayPalVerify];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - BCPay回调
- (void)onBeeCloudResp:(BCBaseResp *)resp {
    
    switch (resp.type) {
        case BCObjsTypePayResp:
        {
            // 支付请求响应
            BCPayResp *tempResp = (BCPayResp *)resp;
            if (tempResp.resultCode == 0) {
                //微信、支付宝、银联支付成功
                [self showAlertView:resp.resultMsg];
            } else {
                //支付取消或者支付失败
                [self showAlertView:[NSString stringWithFormat:@"%@ : %@",tempResp.resultMsg, tempResp.errDetail]];
            }
        }
            break;
        case BCObjsTypeQueryBillsResp:
        {
            BCQueryBillsResp *tempResp = (BCQueryBillsResp *)resp;
            if (resp.resultCode == 0) {
                if (tempResp.count == 0) {
                    [self showAlertView:@"未找到相关订单信息"];
                } else {
                    self.orderList = tempResp;
                    [self performSegueWithIdentifier:@"queryResult" sender:self];
                }
            } else {
                [self showAlertView:[NSString stringWithFormat:@"%@ : %@",tempResp.resultMsg, tempResp.errDetail]];
            }
        }
            break;
        case BCObjsTypeQueryRefundsResp:
        {
            BCQueryRefundsResp *tempResp = (BCQueryRefundsResp *)resp;
            if (resp.resultCode == 0) {
                if (tempResp.count == 0) {
                    [self showAlertView:@"未找到相关订单信息"];
                } else {
                    self.orderList = tempResp;
                    [self performSegueWithIdentifier:@"queryResult" sender:self];
                }
            } else {
                [self showAlertView:[NSString stringWithFormat:@"%@ : %@",tempResp.resultMsg, tempResp.errDetail]];
            }
        }
            break;
            
        case BCObjsTypeOfflinePayResp:
        {
            BCOfflinePayResp *tempResp = (BCOfflinePayResp *)resp;
            if (resp.resultCode == 0) {
                BCOfflinePayReq *payReq = (BCOfflinePayReq *)tempResp.request;
                switch (payReq.channel) {
                    case PayChannelAliOfflineQrCode:
                    case PayChannelWxNative:
                        if (tempResp.codeurl.isValid) {
                            //                            QRCodeViewController *qrCodeView = [[QRCodeViewController alloc] init];
                            //                            qrCodeView.resp = tempResp;
                            //                            qrCodeView.delegate = self;
                            //                            [self.navigationController pushViewController:qrCodeView animated:YES];
                        }
                        break;
                    case PayChannelAliScan:
                    case PayChannelWxScan:
                    {
                        BCOfflineStatusReq *req = [[BCOfflineStatusReq alloc] init];
                        req.channel = payReq.channel;
                        req.billNo = payReq.billNo;
                        [BeeCloud sendBCReq:req];
                    }
                        break;
                    default:
                        break;
                }
            } else {
                [self showAlertView:[NSString stringWithFormat:@"%@ : %@",tempResp.resultMsg, tempResp.errDetail]];
            }
        }
            break;
        case BCObjsTypeOfflineBillStatusResp:
        {
            static int queryTimes = 1;
            BCOfflineStatusResp *tempResp = (BCOfflineStatusResp *)resp;
            if (tempResp.resultCode == 0) {
                if (!tempResp.payResult && queryTimes < 3) {
                    queryTimes++;
                    [BeeCloud sendBCReq:tempResp.request];
                } else {
                    [self showAlertView:tempResp.payResult?@"支付成功":@"支付失败"];
                    //                BCOfflineRevertReq *req = [[BCOfflineRevertReq alloc] init];
                    //                req.channel = tempResp.request.channel;
                    //                req.billno = tempResp.request.billno;
                    //                [BeeCloud sendBCReq:req];
                    queryTimes = 1;
                }
                
            } else {
                [self showAlertView:[NSString stringWithFormat:@"%@ : %@",tempResp.resultMsg, tempResp.errDetail]];
            }
        }
            break;
        case BCObjsTypeOfflineRevertResp:
        {
#pragma mark - 线下撤销订单响应事件类型，包含WX_SCAN,ALI_SCAN,ALI_OFFLINE_QRCODE
            BCOfflineRevertResp *tempResp = (BCOfflineRevertResp *)resp;
            if (resp.resultCode == 0) {
                [self showAlertView:tempResp.revertStatus?@"撤销成功":@"撤销失败"];
            } else {
                [self showAlertView:[NSString stringWithFormat:@"%@ : %@",tempResp.resultMsg, tempResp.errDetail]];
            }
        }
            break;
        default:
        {
            if (resp.resultCode == 0) {
                [self showAlertView:resp.resultMsg];
            } else {
                [self showAlertView:[NSString stringWithFormat:@"%@ : %@",resp.resultMsg, resp.errDetail]];
            }
        }
            break;
    }
}

/**
 *  用户付款后，查询订单状态
 *
 *  @param resp 支付结果
 */
- (void)qrCodeBeScaned:(BCOfflinePayResp *)resp {
    BCOfflineStatusReq *req = [[BCOfflineStatusReq alloc] init];
    BCOfflinePayReq *payReq = (BCOfflinePayReq *)resp.request;
    req.channel = payReq.channel;
    req.billNo = payReq.billNo;
    [BeeCloud sendBCReq:req];
}

- (void)showAlertView:(NSString *)msg {
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}


@end
