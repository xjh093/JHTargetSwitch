//
//  JHTargetSwitch.h
//  JHTargetSwitch
//
//  Created by Haomissyou on 2026/1/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString * JHTargetNameString NS_STRING_ENUM;

/// 国内版本
static JHTargetNameString const JHTargetName_CN = @"JHTargetName_CN";
/// 国际版本
static JHTargetNameString const JHTargetName_EN = @"JHTargetName_EN";
/// 日本版本
static JHTargetNameString const JHTargetName_JP = @"JHTargetName_JP";
/// 添加更多……


@interface JHTargetSwitch : NSObject

/// 
+ (void)configTargets:(NSDictionary<JHTargetNameString, NSString *> *)dict;

/// 国内版本
+ (void)CN:(dispatch_block_t)block;
/// 国际版本
+ (void)EN:(dispatch_block_t)block;
/// 日本版本
+ (void)JP:(dispatch_block_t)block;


+ (void)CN:(dispatch_block_t)cnBlock
        EN:(dispatch_block_t)enBlock;

+ (void)CN:(dispatch_block_t)cnBlock
        EN:(dispatch_block_t)enBlock
        JP:(dispatch_block_t)jpBlock;

@end

NS_ASSUME_NONNULL_END
