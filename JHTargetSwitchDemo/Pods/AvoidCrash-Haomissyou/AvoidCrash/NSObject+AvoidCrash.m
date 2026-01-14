//
//  NSObject+AvoidCrash.m
//  https://github.com/chenfanfang/AvoidCrash
//
//  Created by mac on 16/10/11.
//  Copyright © 2016年 chenfanfang. All rights reserved.
//

#import "NSObject+AvoidCrash.h"
#import "AvoidCrash.h"
#import "AvoidCrashStubProxy.h"

// 持久化存储的Key
static NSString *const kPersistedProtectedClassesKey = @"AvoidCrash_PersistedClasses";

@implementation NSObject (AvoidCrash)


+ (void)avoidCrashExchangeMethodIfDealWithNoneSel:(BOOL)ifDealWithNoneSel {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //setValue:forKey:
        [AvoidCrash exchangeInstanceMethod:[self class] method1Sel:@selector(setValue:forKey:) method2Sel:@selector(avoidCrashSetValue:forKey:)];
        
        //setValue:forKeyPath:
        [AvoidCrash exchangeInstanceMethod:[self class] method1Sel:@selector(setValue:forKeyPath:) method2Sel:@selector(avoidCrashSetValue:forKeyPath:)];
        
        //setValue:forUndefinedKey:
        [AvoidCrash exchangeInstanceMethod:[self class] method1Sel:@selector(setValue:forUndefinedKey:) method2Sel:@selector(avoidCrashSetValue:forUndefinedKey:)];
        
        //setValuesForKeysWithDictionary:
        [AvoidCrash exchangeInstanceMethod:[self class] method1Sel:@selector(setValuesForKeysWithDictionary:) method2Sel:@selector(avoidCrashSetValuesForKeysWithDictionary:)];
        
        
        //unrecognized selector sent to instance
        if (ifDealWithNoneSel) {
            [AvoidCrash exchangeInstanceMethod:[self class] method1Sel:@selector(methodSignatureForSelector:) method2Sel:@selector(avoidCrashMethodSignatureForSelector:)];
            [AvoidCrash exchangeInstanceMethod:[self class] method1Sel:@selector(forwardInvocation:) method2Sel:@selector(avoidCrashForwardInvocation:)];
        }
        
        //
        _protectedClasses = [NSMutableSet set];
        [self loadPersistedProtectedClasses];
    });
}


//=================================================================
//              unrecognized selector sent to instance
//=================================================================
#pragma mark - unrecognized selector sent to instance


static NSMutableArray *noneSelClassStrings;
static NSMutableArray *noneSelClassStringPrefixs;
static NSMutableSet *_protectedClasses;  // 保护的类集合

+ (void)setupNoneSelClassStringsArr:(NSArray<NSString *> *)classStrings {
    
    if (noneSelClassStrings) {
        
        NSString *warningMsg = [NSString stringWithFormat:@"\n\n%@\n\n[AvoidCrash setupNoneSelClassStringsArr:];\n调用一此即可，多次调用会自动忽略后面的调用\n\n%@\n\n",AvoidCrashSeparatorWithFlag,AvoidCrashSeparator];
        AvoidCrashLog(@"%@",warningMsg);
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        noneSelClassStrings = [NSMutableArray array];
        for (NSString *className in classStrings) {
            if ([className hasPrefix:@"UI"] == NO &&
                [className isEqualToString:NSStringFromClass([NSObject class])] == NO) {
                [noneSelClassStrings addObject:className];
                
            } else {
                NSString *warningMsg = [NSString stringWithFormat:@"\n\n%@\n\n[AvoidCrash setupNoneSelClassStringsArr:];\n会忽略UI开头的类和NSObject类(请使用NSObject的子类)\n\n%@\n\n",AvoidCrashSeparatorWithFlag,AvoidCrashSeparator];
                AvoidCrashLog(@"%@",warningMsg);
            }
        }
    });
}

/**
 *  初始化一个需要防止”unrecognized selector sent to instance”的崩溃的类名前缀的数组
 */
+ (void)setupNoneSelClassStringPrefixsArr:(NSArray<NSString *> *)classStringPrefixs {
    if (noneSelClassStringPrefixs) {
        
        NSString *warningMsg = [NSString stringWithFormat:@"\n\n%@\n\n[AvoidCrash setupNoneSelClassStringPrefixsArr:];\n调用一此即可，多次调用会自动忽略后面的调用\n\n%@\n\n",AvoidCrashSeparatorWithFlag,AvoidCrashSeparator];
        AvoidCrashLog(@"%@",warningMsg);
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        noneSelClassStringPrefixs = [NSMutableArray array];
        for (NSString *classNamePrefix in classStringPrefixs) {
            if ([classNamePrefix hasPrefix:@"UI"] == NO &&
                [classNamePrefix hasPrefix:@"NS"] == NO) {
                [noneSelClassStringPrefixs addObject:classNamePrefix];
                
            } else {
                NSString *warningMsg = [NSString stringWithFormat:@"\n\n%@\n\n[AvoidCrash setupNoneSelClassStringsArr:];\n会忽略UI开头的类和NS开头的类\n若需要对NS开头的类防止”unrecognized selector sent to instance”(比如NSArray),请使用setupNoneSelClassStringsArr:\n\n%@\n\n",AvoidCrashSeparatorWithFlag,AvoidCrashSeparator];
                AvoidCrashLog(@"%@",warningMsg);
            }
        }
    });
}

#pragma mark --- 从异常信息中提取并注册需要防护的类
+ (void)registerProtectedClassFromException:(NSException *)exception
{
    // -[ClassA methodA]: unrecognized selector sent to instance 0x60000000c4f0
    NSString *reason = exception.reason;
    if (![reason containsString:@"unrecognized selector sent to"]) return;
    
    // 匹配两种格式：
    // 1. 实例方法: -[ClassName selector]
    // 2. 类方法:   +[ClassName selector]
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\+\\-]\\[(\\w+)\\s" options:0 error:nil];
    NSTextCheckingResult *match = [regex firstMatchInString:reason options:0 range:NSMakeRange(0, reason.length)];
    
    if (match && match.numberOfRanges >= 2) {
        NSString *className = [reason substringWithRange:[match rangeAtIndex:1]];
        Class cls = NSClassFromString(className);
        
        if (cls) {
            [self addProtectedClass:cls];
            NSLog(@"AvoidCrash 从崩溃信息注册防护类: %@ (%@)", className, [reason containsString:@"+["] ? @"类方法" : @"实例方法");
        }
    }
}

+ (void)addProtectedClass:(Class)aClass {
    if (_protectedClasses && aClass) {
        // 防止重复添加
        if (![_protectedClasses containsObject:aClass]) {
            [_protectedClasses addObject:aClass];
            [self persistProtectedClasses]; // 添加后立即持久化
            NSLog(@"AvoidCrash 添加并持久化防护类: %@", NSStringFromClass(aClass));
        }
    }
}

#pragma mark --- 持久化相关方法
+ (void)persistProtectedClasses {
    NSArray *classNames = [_protectedClasses.allObjects valueForKey:@"description"];
    [[NSUserDefaults standardUserDefaults] setObject:classNames forKey:kPersistedProtectedClassesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)loadPersistedProtectedClasses {
    NSArray *classNames = [[NSUserDefaults standardUserDefaults] objectForKey:kPersistedProtectedClassesKey];
    
    [classNames enumerateObjectsUsingBlock:^(NSString *className, NSUInteger idx, BOOL *stop) {
        Class cls = NSClassFromString(className);
        if (cls) {
            [_protectedClasses addObject:cls];
        }
    }];
    
    if (classNames.count > 0) {
        NSLog(@"%@", [NSString stringWithFormat:@"AvoidCrash 加载持久化防护类: %@", classNames]);
    }
}

+ (void)resetPersistedProtectedClasses {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPersistedProtectedClassesKey];
    [_protectedClasses removeAllObjects];
    NSLog(@"AvoidCrash 已清空持久化防护类");
}

- (NSMethodSignature *)avoidCrashMethodSignatureForSelector:(SEL)aSelector {
    
    NSMethodSignature *ms = [self avoidCrashMethodSignatureForSelector:aSelector];
    
    BOOL flag = NO;
    
    if (ms == nil) {
        if ([_protectedClasses containsObject:[self class]]) {
            ms = [AvoidCrashStubProxy instanceMethodSignatureForSelector:@selector(proxyMethod)];
            flag = YES;
        }
    }
    
    if (ms == nil) {
        for (NSString *classStr in noneSelClassStrings) {
            if ([self isKindOfClass:NSClassFromString(classStr)]) {
                ms = [AvoidCrashStubProxy instanceMethodSignatureForSelector:@selector(proxyMethod)];
                flag = YES;
                break;
            }
        }
    }
    
    if (flag == NO) {
        NSString *selfClass = NSStringFromClass([self class]);
        for (NSString *classStrPrefix in noneSelClassStringPrefixs) {
            if ([selfClass hasPrefix:classStrPrefix]) {
                ms = [AvoidCrashStubProxy instanceMethodSignatureForSelector:@selector(proxyMethod)];
            }
        }
    }
    return ms;
}

- (void)avoidCrashForwardInvocation:(NSInvocation *)anInvocation {
    
    @try {
        [self avoidCrashForwardInvocation:anInvocation];
        
    } @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultIgnore;
        [AvoidCrash noteErrorWithException:exception defaultToDo:defaultToDo];
        
    } @finally {
        
    }
    
}


//=================================================================
//                         setValue:forKey:
//=================================================================
#pragma mark - setValue:forKey:

- (void)avoidCrashSetValue:(id)value forKey:(NSString *)key {
    @try {
        [self avoidCrashSetValue:value forKey:key];
    }
    @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultIgnore;
        [AvoidCrash noteErrorWithException:exception defaultToDo:defaultToDo];
    }
    @finally {
        
    }
}


//=================================================================
//                     setValue:forKeyPath:
//=================================================================
#pragma mark - setValue:forKeyPath:

- (void)avoidCrashSetValue:(id)value forKeyPath:(NSString *)keyPath {
    @try {
        [self avoidCrashSetValue:value forKeyPath:keyPath];
    }
    @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultIgnore;
        [AvoidCrash noteErrorWithException:exception defaultToDo:defaultToDo];
    }
    @finally {
        
    }
}



//=================================================================
//                     setValue:forUndefinedKey:
//=================================================================
#pragma mark - setValue:forUndefinedKey:

- (void)avoidCrashSetValue:(id)value forUndefinedKey:(NSString *)key {
    @try {
        [self avoidCrashSetValue:value forUndefinedKey:key];
    }
    @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultIgnore;
        [AvoidCrash noteErrorWithException:exception defaultToDo:defaultToDo];
    }
    @finally {
        
    }
}


//=================================================================
//                  setValuesForKeysWithDictionary:
//=================================================================
#pragma mark - setValuesForKeysWithDictionary:

- (void)avoidCrashSetValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues {
    @try {
        [self avoidCrashSetValuesForKeysWithDictionary:keyedValues];
    }
    @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultIgnore;
        [AvoidCrash noteErrorWithException:exception defaultToDo:defaultToDo];
    }
    @finally {
        
    }
}



@end
