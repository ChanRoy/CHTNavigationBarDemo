//
//  ViewController.m
//  CHTNavigationBarDemo
//
//  Created by cht on 2017/2/16.
//  Copyright © 2017年 cht. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
//
//    [self cht_getBackView:self.navigationController.navigationBar color:[UIColor orangeColor]];
    
    [self getBackView:self.navigationController.navigationBar Color:[UIColor orangeColor]];
    
}

- (void)cht_getBackView:(UIView *)view color:(UIColor *)color{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if ([view isKindOfClass:NSClassFromString(@"_UIBarBackground")] ||
        [view isKindOfClass:NSClassFromString(@"UINavigationBar")]) {
    
        view.backgroundColor = color;
    }else{
        
        view.hidden = YES;
    }
    for (UIView *subView in view.subviews) {
        
        [self getBackView:subView Color:color];
    }
}

- (void)getBackView:(UIView *)View Color:(UIColor *)color{
#if 1
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //||[View isKindOfClass:NSClassFromString(@"_UIBarBackground")]
    //[View isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]
    if ([View isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")] || [View isKindOfClass:NSClassFromString(@"_UIBarBackground")] ) {
        //背景颜色设置
        [UIView animateWithDuration:0.35 animations:^{
            
            View.backgroundColor = color;
            View.alpha = 1.0;
            [UIView commitAnimations];
        }];
    }else if ([View isKindOfClass:NSClassFromString(@"_UIBackdropView")]){
        
        //将_UINavigationBarBackground上面的遮罩层隐藏
        View.hidden = YES;
    }
#if 1
    //iOS10 navigationbar 有点不一样，先这样设置
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10) {
        
        if ([View isKindOfClass:NSClassFromString(@"UIVisualEffectView")]){
            
            View.backgroundColor = color;
            
            if ([color isEqual:[UIColor clearColor]]) {
                View.hidden = YES;
            }
            
        }
    }
#endif
    
    for (UIView *view in View.subviews) {
        [UIView animateWithDuration:0 animations:^{
            [self getBackView:view Color:color];       //递归遍历NavBar视图
            [UIView commitAnimations];
        }];
        
    }
#endif
    //iOS10有点坑爹，先这样设置
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 10){
        
        [self.navigationController.navigationBar setBarTintColor:color];
    }
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
