//
//  iosPay.m
//  PayDemo
//
//  Created by admin on 15/6/25.
//  Copyright (c) 2015年 Crittercism. All rights reserved.
//

#import "iosPay.h"
#import "LsSdkConector.h"

@implementation iosPay



+(id)Share {
   
    static  iosPay*  s_instance = nil;
    if (nil == s_instance) {
        @synchronized(self) {
            if (nil == s_instance) {
                s_instance = [[self alloc] init];
            }
        }
    }
    return s_instance;
    
}


-(id)init {
    //init product id

    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    _deals = [[NSMutableDictionary alloc]init];
    return self;
    
}

-(void)BuyItem:(uint)itemid
{
    NSLog(@"itemid=%d",itemid);
    NSArray *CurProducts = [NSArray arrayWithObjects: @"",
                            @"com.ccydmx.1001", //成长基金
                            @"com.maoxian.50",
                            @"com.maoxian.648",
                            @"com.maoxian.328",
                            @"com.maoxian.198",
                            @"com.maoxian.98",
                            @"com.maoxian.30",
                            @"com.maoxian.6",
                            @"凑一个位子",
                            @"com.maoxian.grow",
                            nil];
    if (itemid <= 0 && itemid >= [CurProducts count]) {
        
        NSLog(@"no such id");   
        return;
    }

    if([SKPaymentQueue canMakePayments]){
        //[self requestProductData: CurProducts[itemid]];
        NSString* string =[NSString stringWithFormat:@"com.ccy.%d", itemid];
        NSLog(@"string = %@",string);
        [self requestProductData:string];
    }else{
        NSLog(@"不允许程序内付费");
    }
}

//请求商品
- (void)requestProductData:(NSString *)type{
    NSLog(@"-------------请求对应的产品信息----------%@-----",type);
    ////NSLog(type);
    NSArray *product = [[NSArray alloc] initWithObjects:type, nil];
    
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
}

//收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    //self.ringIndicator.hidden = YES;
    NSLog(@"--------------收到产品反馈消息---------------------");
    NSArray *product = response.products;
    if([product count] == 0){
        //[self showHUDTipWithTitle:@"没有该商品"];
        NSLog(@"--------------没有商品------------------");
        return;
    }
    
    //NSLog(@"productID:%@", response.invalidProductIdentifiers);
    //NSLog(@"产品付费数量:%d",[product count]);
    
    SKProduct *p = nil;
    for (SKProduct *pro in product) {
        NSLog(@"pro info");
        NSLog(@"SKProduct 描述信息：%@", [pro description]);
        NSLog(@"localizedTitle 产品标题：%@", [pro localizedTitle]);
        NSLog(@"localizedDescription 产品描述信息：%@", [pro localizedDescription]);
        NSLog(@"price 价格：%@", [pro price]);
        NSLog(@"productIdentifier Product id：%@", [pro productIdentifier]);
        p = pro;
        
//        if([pro.productIdentifier isEqualToString:self.productid]){
//            p = pro;
//        }
    }
    
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    
    NSLog(@"发送购买请求");
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    [request autorelease];
}

//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    
    NSLog(@"------------------错误-----------------:%@", error);
}

- (void)requestDidFinish:(SKRequest *)request{
    NSLog(@"------------反馈信息结束-----------------");
}


//监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction{    
    ////NSLog(@"交易完成 cbccbcbcbcb");

    //return;
    for(SKPaymentTransaction *tran in transaction){
        
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"交易完成");
                //[self commitSeversSucceeWithTransaction:tran];
                [self completeTransaction: tran];
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"商品添加进列表");
                
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"已经购买过商品");
                [self restoreTransaction:tran];
                
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"交易失败");
                [self failedTransaction: tran];
                break;
            default:
                break;
        }
    }
}

- (NSString *)encode:(const uint8_t *)input length:(NSInteger)length {
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData *data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t *output = (uint8_t *)data.mutableBytes;
    
    for (NSInteger i = 0; i < length; i += 3) {
        NSInteger value = 0;
        for (NSInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger index = (i / 3) * 4;
        output[index + 0] =                    table[(value >> 18) & 0x3F];
        output[index + 1] =                    table[(value >> 12) & 0x3F];
        output[index + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[index + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] ;
}

- (void)completeTransaction:(SKPaymentTransaction *)tran{
    
    //NSLog(@"交易成功");
    /**
    [_deals setObject:tran forKey:tran.transactionIdentifier];    
    NSString *base64 = [self encode: tran.transactionReceipt.bytes length:tran.transactionReceipt.length];
    //NSLog(base64);
    NSNumber *code = [NSNumber numberWithInt:0];
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys: tran.transactionIdentifier,@"orderId", base64, @"base64", nil];
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"Pay",@"callbackType", code, @"code", data, @"data", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"Pay",@"callbackType",
                         code, @"code",
                         data, @"data",
                         nil];
    NSLog(@"serali dic = %@",dic);
    //[self sendMessage:@"OnUCGameSdkCallback" param:dic];
    //TODO: 购买成功处理
    
    [[LsSdkConector sharedInstance] sendMessage:@"OnUCGameSdkCallback" param:dic];
     */
    
    [_deals setObject:tran forKey:tran.transactionIdentifier];
    NSString *base64 = [self encode: tran.transactionReceipt.bytes length:tran.transactionReceipt.length];
    //NSLog(base64);
    NSNumber *code = [NSNumber numberWithInt:0];
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys: tran.transactionIdentifier,@"orderId", base64, @"base64", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"Pay",@"callbackType", code, @"code", data, @"data", nil];
    //[self sendMessage:@"OnUCGameSdkCallback" param:dic];
    //TODO: 购买成功处理
    [[LsSdkConector sharedInstance] sendMessage:@"OnUCGameSdkCallback" param:dic];
    
    //这个代码有什么问题
    //void LSInitPay() 这个方法这个加个特殊的log
    //看有没有执行过
    
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction{
    
    //NSLog(@"交易失败");
    NSNumber *code = [NSNumber numberWithInt:-500];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"Pay",@"callbackType", code, @"code", @"data", @"data", nil];
    
    //[self sendMessage:@"OnUCGameSdkCallback" param:dic];
    //TODO: 购买失败
    [[LsSdkConector sharedInstance] sendMessage:@"OnUCGameSdkCallback" param:dic];
    [self endTheTransaction: transaction];
}

-(void)endTheTransaction:(SKPaymentTransaction *) transaction{
    //NSLog(@"交易结束");
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

-(void)FinishTheTransaction:(NSString*) tradeID
{
    //NSLog(@" %@", tradeID);
    SKPaymentTransaction *cur = [_deals objectForKey: tradeID];
    if(cur == nil){
        return;
    }
    [self endTheTransaction: cur];
    [_deals removeObjectForKey:tradeID];
    //[cur release];
}

- (void)dealloc{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    [super dealloc];
}


- (void)CallServer:(SKPaymentTransaction *)transaction {

    //
    //    1.设置请求路径
    //NSString *urlStr=[NSString stringWithFormat:@"http://192.168.13.36:8888/",self.username.text,self.pwd.text];
    NSURL *url=[NSURL URLWithString: @"http://120.92.141.137:8889/"];
    
    //    2.创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:120];
    //设定请求的参数
    //设置请求的方式
    [request setTimeoutInterval: 5];
    [request setHTTPMethod:@"POST"];

    //创建json
    NSMutableString *Strdata = [[NSMutableString alloc] init];
    [Strdata appendFormat: @"{"];
    [Strdata appendFormat: @"\"%@\":\"%@\",", @"token", @"123"];
    [Strdata appendFormat: @"\"%@\":\"%@\"", @"token", @"123"];
    [Strdata appendFormat: @"}"];
    //设置请求的数据长度
    NSData* bodydata = [Strdata dataUsingEncoding: NSUTF8StringEncoding allowLossyConversion:true];
    NSString * length = [NSString stringWithFormat:@"%d",[bodydata length]];
    [request setValue: length forHTTPHeaderField:@"Content-Length"];
    //设置请求的数值的文件的格式 text/xml
    [request setValue:@"text/json" forHTTPHeaderField:@"Content-Type"];
    //设置请求的内容（请求体数据）
    [request setHTTPBody:bodydata];
    
    //
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
//
//    request.HTTPBody = jsonData;
    //    3.发送请求
    //3.1发送同步请求，在主线程执行
    //    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //（一直在等待服务器返回数据，这行代码会卡住，如果服务器没有返回数据，那么在主线程UI会卡住不能继续执行操作）
    
    //3.1发送异步请求
    //创建一个队列（默认添加到该队列中的任务异步执行）
    //    NSOperationQueue *queue=[[NSOperationQueue alloc]init];
    //获取一个主队列
    NSOperationQueue *queue=[NSOperationQueue mainQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        //NSLog(@"%@",dict);
        ////NSLog(@"sdfdsf %@",Strdata[@"buy"]);
        //判断后，在界面提示登录信息
        NSNumber *ret = (NSNumber*)dict[@"ret"];
        //NSLog(@"%@",ret);
        if ([ret integerValue] != 0) {
            //NSLog(@" FAILED");
        }else
        {
            [self endTheTransaction: transaction];
            //NSLog(@"yes");
        }
    }];
    //NSLog(@"请求发送完毕");
}

@end
