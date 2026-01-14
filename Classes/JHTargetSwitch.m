//
//  JHTargetSwitch.m
//  JHTargetSwitch
//
//  Created by Haomissyou on 2026/1/13.
//

#import "JHTargetSwitch.h"

#define TargetName (NSString *)([[NSBundle mainBundle] infoDictionary][(NSString *)kCFBundleNameKey])

NSDictionary *_targetDict;


@implementation JHTargetSwitch

+ (void)configTargets:(NSDictionary *)dict
{
    _targetDict = dict;
}

+ (void)CN:(dispatch_block_t)block
{
    if ([TargetName isEqualToString:_targetDict[JHTargetName_CN]]) {
        if (block) {
            block();
        }
    }
}

+ (void)EN:(dispatch_block_t)block
{
    if ([TargetName isEqualToString:_targetDict[JHTargetName_EN]]) {
        if (block) {
            block();
        }
    }
}

+ (void)JP:(dispatch_block_t)block
{
    if ([TargetName isEqualToString:_targetDict[JHTargetName_JP]]) {
        if (block) {
            block();
        }
    }
}

+ (void)CN:(dispatch_block_t)cnBlock
        EN:(dispatch_block_t)enBlock
{
    [self CN:cnBlock];
    [self EN:enBlock];
}

+ (void)CN:(dispatch_block_t)cnBlock
        EN:(dispatch_block_t)enBlock
        JP:(dispatch_block_t)jpBlock
{
    [self CN:cnBlock];
    [self EN:enBlock];
    [self JP:jpBlock];
}

@end
