//
//  OkidokiTool.m
//  Pods
//
//  Created by Haomissyou on 2026/1/14.
//

#import "OkidokiTool.h"

@implementation OkidokiTool

+ (void)logInfo
{
#ifdef TargetCN
    NSLog(@"OkidokiTool logInfo CN");
#elif TargetEN
    NSLog(@"OkidokiTool logInfo EN");
#elif TargetJP
    NSLog(@"OkidokiTool logInfo JP");
#endif
}

@end
