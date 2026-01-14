//
//  CNButton.m
//  JHTargetSwitchDemo
//
//  Created by Haomissyou on 2026/1/14.
//

#import "CNButton.h"

@implementation CNButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType
{
    CNButton *button = [super buttonWithType:buttonType];
    button.frame = CGRectMake(0, 0, 100, 62);
    [button setTitle:@"CNButton" forState:0];
    return button;
}

@end
