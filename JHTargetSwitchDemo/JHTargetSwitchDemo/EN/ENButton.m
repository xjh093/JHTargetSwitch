//
//  ENButton.m
//  JHTargetSwitchDemoEN
//
//  Created by Haomissyou on 2026/1/14.
//

#import "ENButton.h"

@implementation ENButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType
{
    ENButton *button = [super buttonWithType:buttonType];
    button.frame = CGRectMake(0, 0, 100, 62);
    [button setTitle:@"ENButton" forState:0];
    return button;
}

@end
