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
    
    [self findHairlineImageViewUnder:self.navigationController.navigationBar].hidden = YES;
    
    [self getBackView:self.navigationController.navigationBar Color:[UIColor clearColor]];
    
}

- (void)cht_getBackView:(UIView *)view color:(UIColor *)color{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000 )
    //iOS10⬆️
    
    if ([view isKindOfClass:NSClassFromString(@"_UIBarBackground")] || [view isKindOfClass:NSClassFromString(@"UIVisualEffectView")]) {
        view.backgroundColor = color;
        
        if ([color isEqual:[UIColor clearColor]]) {
            
            view.hidden = YES;
        }
    }
    
    for (UIView *subView in view.subviews) {
        
        [self cht_getBackView:subView color:color];
    }
    self.navigationController.navigationBar.barTintColor = color;
    
#else
    
    //iOS10⬇️
    if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
        
        view.backgroundColor = color;
    }else if ([view isKindOfClass:NSClassFromString(@"_UIBackdropView")]){
        
        //将_UINavigationBarBackground上面的遮罩层隐藏
        view.hidden = YES;
    }
    for (UIView *subView in view.subviews) {
        
        [self cht_getBackView:subView color:color];
    }
    
#endif
}

- (void)getBackView:(UIView *)View Color:(UIColor *)color{
#if 1
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //||[View isKindOfClass:NSClassFromString(@"_UIBarBackground")]
    //[View isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]
    if ([View isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")] || [View isKindOfClass:NSClassFromString(@"_UIBarBackground")] ) {
        //背景颜色设置
            
        View.backgroundColor = color;

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
        
        [self getBackView:view Color:color];       //递归遍历NavBar视图
        
    }
#endif
    //iOS10有点坑爹，先这样设置
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 10){
        
        [self.navigationController.navigationBar setBarTintColor:color];
    }
    
}

//递归寻找UINavigationBar下方的直线
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
