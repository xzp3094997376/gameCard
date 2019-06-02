//
//  LsSdkConector.h
//  Unity-iPhone
//
//  Created by Abigale on 15-5-5.
//
//
#import <Foundation/Foundation.h>
#ifndef Unity_iPhone_LsSdkConector_h
#define Unity_iPhone_LsSdkConector_h

@interface LsSdkConector : NSObject
@property (nonatomic, retain)   NSString*   unityMsgReceiver;
@property (nonatomic, retain)   NSString*   lastLoginedUin;

+ (id)sharedInstance;
@end

#endif
