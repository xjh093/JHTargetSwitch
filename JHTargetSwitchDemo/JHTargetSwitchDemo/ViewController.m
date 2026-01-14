//
//  ViewController.m
//  JHTargetSwitchDemo
//
//  Created by Haomissyou on 2026/1/13.
//

#import "ViewController.h"
#import "JHTargetSwitch.h"
#import "Okidoki.h"
#import "OkidokiTool.h"

/// 这几个宏，是在 Okidoki.podspec 里面定义的
/// 其他库，或子组件，区分 Target 时，也需要定义相同的名字的宏

#ifdef TargetCN
    #import "ToolCN.h"
    #import "CNButton.h"
#elif TargetEN
    #import "ToolEN.h"
    #import "ENButton.h"
#elif TargetJP
    #import "ToolJP.h"
    #import "JPButton.h"
#endif

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 100, 62);
    [button addTarget:self action:@selector(buttonAction) forControlEvents:1<<6];
    button.center = self.view.center;
    [self.view addSubview:button];
    
    button.okidoki
        .font([UIFont systemFontOfSize:18])
        .color([UIColor whiteColor]);
    
    // 运行时，区分
    [JHTargetSwitch CN:^{
        [button setTitle:@"国内版" forState:0];
        button.backgroundColor = [UIColor systemOrangeColor];
    } EN:^{
        [button setTitle:@"国际版" forState:0];
        button.backgroundColor = [UIColor systemBlueColor];
    } JP:^{
        [button setTitle:@"日版" forState:0];
        button.backgroundColor = [UIColor systemGreenColor];
    }];
    
#ifdef TargetCN
    CNButton *button1 = [CNButton buttonWithType:UIButtonTypeCustom];
    button1.backgroundColor = [UIColor systemRedColor];
    [self.view addSubview:button1];
    button1.center = CGPointMake(button.center.x, button.center.y + 70);
    
#elif TargetEN
    ENButton *button1 = [ENButton buttonWithType:UIButtonTypeCustom];
    button1.backgroundColor = [UIColor systemBrownColor];
    [self.view addSubview:button1];
    button1.center = CGPointMake(button.center.x, button.center.y + 70);
#elif TargetJP
    JPButton *button1 = [JPButton buttonWithType:UIButtonTypeCustom];
    button1.backgroundColor = [UIColor systemPurpleColor];
    [self.view addSubview:button1];
    button1.center = CGPointMake(button.center.x, button.center.y + 70);
#endif
}

- (void)buttonAction
{
    // 内部有区分 Target
    [OkidokiTool logInfo];
    
    // 运行时，区分
    [JHTargetSwitch CN:^{
        NSLog(@"国内版事件");
        
#ifdef TargetCN
        [ToolCN log];
#endif
        
    } EN:^{
        NSLog(@"国际版事件");
        
#ifdef TargetEN
        [ToolEN log];
#endif
        
    } JP:^{
        NSLog(@"日版事件");
        
#ifdef TargetJP
        [ToolJP log];
#endif
        
    }];
}

@end
