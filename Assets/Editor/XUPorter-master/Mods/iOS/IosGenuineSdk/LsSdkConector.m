//
//  LsSdkConector.m
//  unityplusfor91sdk
//
//  Created by lisind on 14-3-20.
//  Copyright (c) 2013年 李思. All rights reserved.
//

#import "iosPay.h"
#import "LsSdkConector.h"
#import <AdSupport/AdSupport.h>




//代码定义区域 C - Begin
@implementation LsSdkConector
{
    NSMutableArray *cacheView;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.unityMsgReceiver = nil;
    self.lastLoginedUin = nil;
    [super dealloc];
}

+ (id)sharedInstance {
    static  LsSdkConector*  s_instance = nil;
    if (nil == s_instance) {
        @synchronized(self) {
            if (nil == s_instance) {
                s_instance = [[self alloc] init];
            }
        }
    }
    return s_instance;
}

char* MakeStringCopy(const char* str)
{
    if(NULL==str)
    {
        return  NULL;
    }
    char* s = (char*)malloc(strlen(str)+1);
    strcpy(s,str);
    return s;
}

- (void)sendDictMessage:(NSString *)messageName param:(NSDictionary *)dict
{
    NSString *param = @"";
    for (NSString *key in dict)
    {
        if ([param length] == 0)
        {
            param = [param stringByAppendingFormat:@"%@=%@", key, [dict valueForKey:key]];
        }
        else
        {
            param = [param stringByAppendingFormat:@"&%@=%@", key, [dict valueForKey:key]];
        }
    }
     UnitySendMessage([self.unityMsgReceiver UTF8String], [messageName UTF8String], [param UTF8String]);
}

- (void)sendMessage:(NSString *)messageName param:(NSDictionary *)dic
{
    NSError *error;
    NSData *jsonData;
    NSString *param;
    if ([NSJSONSerialization isValidJSONObject:dic])
    {
        
        jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
        param = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    //unityMsgReceiver这个值位Null
    NSLog(@"serali unityMsgReceiver = %@",self.unityMsgReceiver);
    NSLog(@"serali messageName = %@",messageName);
   // trantran
    UnitySendMessage([self.unityMsgReceiver UTF8String], [messageName UTF8String], [param UTF8String]);
}




- (BOOL)checkInCacheView:(NSObject*) obj
{
    for (int i = 0; i < [cacheView count]; i++) {
        if ([cacheView objectAtIndex:i] == obj) {
            return YES;
        }
    }
    return NO;
}

- (void)ClearSdkView
{
    
}

const NSString* LsGetDeviceIDFA()
{
    NSString *uid =  [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return uid;
}


//初始化SDK
- (void)Init:(int)appid appkey:(NSString*)appkey isdebug:(BOOL)isdebug
{
    NSString *userIDFA = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSNumber *num = [NSNumber numberWithInt:0];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"InitSDK",@"callbackType",num, @"code",userIDFA, @"data", nil];
    // [dic setValue:@"OnInitResult" forUndefinedKey:@"callbackType"];
    // [dic setValue:@"0" forUndefinedKey:@"code"];
    // [dic setValue:@"init success" forUndefinedKey:@"data"];
    //  NSError *error;
    //  NSData *jsonData;
    //// NSString *json;
    // if ([NSJSONSerialization isValidJSONObject:dic])
    // {
    
    //     jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    //     json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    // }
    [self sendMessage:@"OnUCGameSdkCallback" param:dic];
    //_myPay = [[iosPay alloc] init];
}

-(void)initPay{
    self.unityMsgReceiver = @"GameManager";
    [iosPay Share];
    
    NSString *userIDFA = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSNumber *num = [NSNumber numberWithInt:0];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"InitSDK",@"callbackType",num, @"code",userIDFA, @"data", nil];
    [self sendMessage:@"OnUCGameSdkCallback" param:dic];
    //_myPay = [[iosPay alloc] init];
}
//初始化完成监听
- (void)InitResult:(NSNotification *)notify
{

}

//账号登陆
- (void)Login
{
//    if(_myPay == nil){
//         _myPay = [[iosPay alloc] init];
//    }
    //static iosPay *osp =[[iosPay alloc] init];
//    [[iosPay Share] BuyItem:5];
    NSLog(@"login login !!!!-////////`1!!!!!!");
}

//游客登陆
- (void)LoginEx
{
    
}


//账号登陆监听
- (void)LoginResult:(NSNotification *)notify
{

}

//显示÷工具条
- (void)ShowToolBar
{
    
}

//隐藏工具条
- (void)HideToolBar
{
    
}

//显示暂停页
- (void)ShowPause
{
    
}

//暂停退出监听
- (void)PauseExit:(NSNotification *)notify
{

}


//判断是否登陆
- (BOOL)isLogined
{
    return true;//[[NdComPlatform defaultPlatform] isLogined];
}

//返回账号状态：0表示未登陆、1表示游客登陆、2表示普通账号登陆
- (int)getCurrentLoginState
{
    return 0;//[[NdComPlatform defaultPlatform] getCurrentLoginState];
}

//返回玩家ID
- (NSString *)loginUin
{
    return @"";//[[NdComPlatform defaultPlatform] loginUin];
}

//返回玩家sessionId
- (NSString *)sessionId
{
    return @"";//[NdComPlatform defaultPlatform] sessionId];
}

//返回玩家昵称
- (NSString *)nickName
{
    return @"";//[[NdComPlatform defaultPlatform] nickName];
}

//注销,返回错误码,param: 0,表示注销；1，表示注销，并清除自动登录
- (void)Logout:(int)param
{
//    if (param == 0)
//       [[NdComPlatform defaultPlatform] NdLogout:1];
//    NSNumber *code = [NSNumber numberWithInt:0];
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"Logout",@"callbackType", code, @"code", @"logout message", @"data", nil];
//    [self sendMessage:@"OnUCGameSdkCallback" param:dic];
    
}

//支付监听
- (void)PayResult:(NSNotification *)notify
{
//    NSDictionary *dic = [notify userInfo];
//    BOOL bSuccess = [[dic objectForKey:@"result"] boolValue];
//    if (!bSuccess) {
//        //TODO: 购买失败处理
//            NSNumber *code = [NSNumber numberWithInt:-500];
//        //  [dic setValue:@"data" forKey:@"login success"];
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"Pay",@"callbackType", code, @"code", @"Pay failed", @"data", nil];
//        [self sendMessage:@"OnUCGameSdkCallback" param:dic];
//      
//    }
//    else {
//        //TODO: 购买失败处理
//        NSNumber *code = [NSNumber numberWithInt:0];
//        NSNumber *payWayId = [NSNumber numberWithInt:0];
//        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"orderId", payWayId, @"payWayId", @"91",@"payWayName", @"0", @"orderAmount", nil];
//        //  [dic setValue:@"data" forKey:@"login success"];
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"Pay",@"callbackType", code, @"code", data, @"data", nil];
//        //[self sendMessage:@"OnUCGameSdkCallback" param:dic];
//        //TODO: 购买成功处理
//        [self sendMessage:@"OnUCGameSdkCallback" param:dic];
//    }
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNdCPBuyResultNotification object:nil];
}

//同步支付
- (void)UniPay:(NSString *)cooOrderSerial productId :(NSString *)productId  productName :(NSString *)productName productPrice:(float)productPrice productCount:(int) productCount payDescription:(NSString *)payDescription
{
    int product_id = [productId intValue];
    //NSLog(@"  %@", product_id);
    [[iosPay Share] BuyItem: [productId intValue]];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PayResult:) name:(NSString *)kNdCPBuyResultNotification object:nil];
//    
//   // NSString *name = @"123";
//    NdBuyInfo *buyInfo = [NdBuyInfo new];
//    NSMutableString *str = [NSMutableString stringWithString:cooOrderSerial];
//   [str replaceOccurrencesOfString:@"|" withString:@"_" options:nil range:NSMakeRange(0, [str length])];
// 
//    buyInfo.cooOrderSerial = str;
//    buyInfo.productId = productId;  //自定义的产品ID
//    if ([productName isEqual: @"月卡"]){
//          NSString *str = [NSString stringWithFormat:@"%.2f",productPrice/(100)];
//          float price = [str floatValue];
//        buyInfo.productName = [str stringByAppendingString: @"元月卡"];
//     //   [str stringByAppendingString:@"元" stringByAppendingString:productName] ;//产品名称
//        buyInfo.productPrice = price;//productPrice/(100*productCount); //产品现价，价格大等于0.01,支付价格以此为准
//       buyInfo.productOrignalPrice =price;//productPrice/(100*productCount); //产品原价，同现价保持一致
//                                                                  
//        buyInfo.productCount = 1;  //产品数量
//
//    }else{
//        NSString *str = [NSString stringWithFormat:@"%.2f",productPrice/(100*productCount)];
//        if ([productName isEqual:@"成长基金"]){
//            str =[NSString stringWithFormat:@"%.2f",productPrice/(100)];
//            productCount = 1;
//        }
//          float price = [str floatValue];
//        buyInfo.productName = productName;//产品名称
//        buyInfo.productPrice = price;//productPrice/(100*productCount); //产品现价，价格大等于0.01,支付价格以此为准
//        buyInfo.productOrignalPrice =price;//productPrice/(100*productCount); //产品原价，同现价保持一致
//        
//        buyInfo.productCount =productCount;  //产品数量
//    }
//       buyInfo.payDescription = payDescription;   //服务器分区，不超过20个字符，只允许英文或数字
//    
//    //发起请求并检查返回值。注意！该返回值并不是交易结果！
//    int res = [[NdComPlatform defaultPlatform] NdUniPay:buyInfo];
//    NSLog(@"res %d", res);
}

//异步支付
- (int)UniPayAsyn:(NSString *)cooOrderSerial productId :(NSString *)productId  productName :(NSString *)productName productPrice:(float)productPrice productCount:(int) productCount payDescription:(NSString *)payDescription
{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PayResult:) name:(NSString *)kNdCPBuyResultNotification object:nil];
//    
//    NdBuyInfo *buyInfo = [NdBuyInfo new];
//    buyInfo.cooOrderSerial = cooOrderSerial;
//    buyInfo.productId = productId;  //自定义的产品ID
//    buyInfo.productName = @"gold";  //产品名称
//    buyInfo.productPrice = productPrice; //产品现价，价格大等于0.01,支付价格以此为准
//    buyInfo.productOrignalPrice = productPrice; //产品原价，同现价保持一致
//    buyInfo.productCount = productCount;  //产品数量
//    buyInfo.payDescription = cooOrderSerial;   //服务器分区，不超过20个字符，只允许英文或数字
//    
//    //发起请求并检查返回值。注意！该返回值并不是交易结果！
//    return [[NdComPlatform defaultPlatform] NdUniPayAsyn:buyInfo];
}

//代币充值
- (int)UniPayForCoin:(NSString *)cooOrderSerial needPayCoins:(int)needPayCoins payDescription:(NSString *)payDescription
{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LeavePlatform:) name:(NSString *)kNdCPLeavePlatformNotification object:nil];
//    return [[NdComPlatform defaultPlatform] NdUniPayForCoin:cooOrderSerial needPayCoins:needPayCoins payDescription:cooOrderSerial];
}

//离开平台监听
- (void)LeavePlatform:(NSNotification *)notify
{
//     NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"levelPlatform",@"msg", nil];
//    [self sendMessage:@"PayResultOrderSerialSubmitted" param:dic];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNdCPLeavePlatformNotification object:nil];
}

//会话Session监听
- (void)SessionInvalid:(NSNotification *)notify
{
//     NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"SessionInvalid",@"msg", nil];
//    [self sendMessage:@"SessionInvalid" param:dic];
}
//add by serali 2017-2-9
- (BOOL)joinGroup:(NSString *)groupUin key:(NSString *)key
{
    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external", groupUin,key];
    NSURL *url = [NSURL URLWithString:urlStr];
    if([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
        return YES;
    }
    else return NO;
}


@end
//代码定义区域 C - End


//代码定义区域 B - Begin
#if defined(__cplusplus)
extern "C"{
#endif
    
//    const char* LffsGetDeviceID()
//    {
//        NSString *uid =  @"sdfdsfds";//[[[UIDevice currentDevice]identifierForVendor] UUIDString];
//        
//        NSLog(@"device  id: %@", uid);
//        return MakeStringCopy([[[LsSdkConector sharedInstance] nickName] UTF8String]);//        UIDevice *device = [UIDevice currentDevice];
////        NSString* deviceUID = [NSString alloc] initWithString:[device ];
//    }
    


    
    NSString* ConvertToNSString (const char* string)
    {
        if (string)
            return [NSString stringWithUTF8String: string];
        else
            return [NSString stringWithUTF8String: ""];
    }
    

    int LsFinishDeal(const char *tradeID)
    {
        [[iosPay Share] FinishTheTransaction: ConvertToNSString(tradeID)];
        return 1;
    }
    void LSInitPay()
    {
        NSLog(@"serali init pay....");
        [[LsSdkConector sharedInstance] initPay];
    }
    const char* LsGetDeviceID()
    {
        NSString *uid =  [[[UIDevice currentDevice]identifierForVendor] UUIDString];
        return MakeStringCopy([uid UTF8String]);
    }
    void LsInit(const int appid,const char *appkey,const bool isdebug)
    {
        [[LsSdkConector sharedInstance] Init:appid appkey:ConvertToNSString(appkey) isdebug:isdebug];
    }
    
    void LsLogin()
    {
        [[LsSdkConector sharedInstance] Login];
    }
    
    void LsLoginEx()
    {
        [[LsSdkConector sharedInstance] LoginEx];
    }
    
    void LsShowToolBar(int point)
    {
        
        //[[LsSdkConector sharedInstance] ShowToolBar:NdToolBarAtMiddleLeft];
        
    }
    
    void LsHideToolBar()
    {
        [[LsSdkConector sharedInstance] HideToolBar];
        
    }
    
    void LsPause()
    {
        [[LsSdkConector sharedInstance] ShowPause];
    }
    
    bool LsLogined()
    {
        return [[LsSdkConector sharedInstance] isLogined];
    }
    
    int LsgetCurrentLoginState()
    {
        return [[LsSdkConector sharedInstance] getCurrentLoginState];
    }
    
    
    const char* LsloginUin()
    {
        return MakeStringCopy([[[LsSdkConector sharedInstance] loginUin] UTF8String]);
    }
    
    const char* LssessionId()
    {
        return MakeStringCopy([[[LsSdkConector sharedInstance] sessionId] UTF8String]);
    }
    
    const char* LsnickName()
    {
        return MakeStringCopy([[[LsSdkConector sharedInstance] nickName] UTF8String]);
    }
    
    void LsLogout(int param)
    {
        [[LsSdkConector sharedInstance] Logout:param];
    }
    
    
    void LSUniPay(const char*  cooOrderSerial,const char* productId,const char* productName,float productPrice,int productCount,const char* payDescription)
    {
         [[LsSdkConector sharedInstance] UniPay:ConvertToNSString(cooOrderSerial) productId:ConvertToNSString(productId) productName:ConvertToNSString(productName) productPrice:productPrice productCount:productCount payDescription:ConvertToNSString(payDescription)];
        
    }
    
    int LsUniPayAsyn(const char*  cooOrderSerial,const char* productId,const char* productName,float productPrice,int productCount,const char* payDescription)
    {
        return [[LsSdkConector sharedInstance] UniPayAsyn:ConvertToNSString(cooOrderSerial) productId:ConvertToNSString(productId) productName:ConvertToNSString(productName) productPrice:productPrice productCount:productCount payDescription:ConvertToNSString(payDescription)];
        
    }
    
    
    int LsUniPayForCoin(const char*  cooOrderSerial,int needPayCoins,const char* payDescription)
    {
        return [[LsSdkConector sharedInstance] UniPayForCoin:ConvertToNSString(cooOrderSerial) needPayCoins:needPayCoins payDescription:ConvertToNSString(payDescription)];
        
    }
    
    
    void LsSetUnityReceiver(const char* string)
    {
        //printf_console("set receiver success");
        
        [[LsSdkConector sharedInstance] setUnityMsgReceiver:ConvertToNSString(string)];
    }
    //add by serali 2017-2-9
    bool LsJoinQQGroup(const char* QQNum,const char* key)
    {
        return [[LsSdkConector sharedInstance] joinGroup:[NSString stringWithFormat:@"%s",QQNum] key:[NSString stringWithFormat:@"%s",key]];
    }
    
    
#if defined(__cplusplus)
}
#endif
//代码定义区域 B - End


//代码定义区域 A - Begin
#if defined(__cplusplus)
extern "C"{
#endif
    extern void UnitySendMessage(const char *, const char *, const char *);
    extern NSString* ConvertToNSString (const char* string);
#if defined(__cplusplus)
}
#endif
//代码定义区域 A - End

