//
//  iosPay.h
//  PayDemo
//
//  Created by admin on 15/6/25.
//  Copyright (c) 2015年 Crittercism. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface iosPay : NSObject<SKPaymentTransactionObserver,SKProductsRequestDelegate>

@property(atomic, retain) NSArray *products;
@property(nonatomic, retain) NSMutableDictionary *deals;
+(id)Share;

-(void)BuyItem:(uint) itemid;
//-(void)ClientInitComplete:(LsSdkConector*)ls;
-(void)FinishTheTransaction:(NSString*) tradeID;
//-(void)CallServer: (SKPaymentTransaction*)transaction;
//-(void)

@end
