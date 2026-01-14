//
//  JPButton.m
//  JHTargetSwitchDemoJP
//
//  Created by Haomissyou on 2026/1/14.
//

#import "JPButton.h"

@implementation JPButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType
{
    JPButton *button = [super buttonWithType:buttonType];
    button.frame = CGRectMake(0, 0, 100, 62);
    [button setTitle:@"JPButton" forState:0];
    return button;
}

@end
