//
//  ViewController.m
//  CHTNavigationBarDemo
//
//  Created by cht on 2017/2/16.
//  Copyright © 2017年 cht. All rights reserved.
//

#import "ViewController.h"

#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    //隐藏UINavigationBar下方的直线
    [self findHairlineImageViewUnder:self.navigationController.navigationBar].hidden = YES;
    
    //改变UINavigationBar的颜色
    [self cht_getBackView:self.navigationController.navigationBar color:[UIColor orangeColor]];

}

- (void)cht_getBackView:(UIView *)view color:(UIColor *)color{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if (SYSTEM_VERSION < 10) {
        
        // <iOS10
        if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
            
            view.backgroundColor = color;
        }else if ([view isKindOfClass:NSClassFromString(@"_UIBackdropView")]){
            
            //将_UINavigationBarBackground上面的遮罩层隐藏
            view.hidden = YES;
        }
        for (UIView *subView in view.subviews) {
            
            [self cht_getBackView:subView color:color];
        }
    }

#ifdef __IPHONE_10_0
    else{
        // >=iOS10
        if ([view isKindOfClass:NSClassFromString(@"_UIBarBackground")] ||
            [view isKindOfClass:NSClassFromString(@"UIVisualEffectView")]) {
            view.backgroundColor = color;
            
            if ([color isEqual:[UIColor clearColor]]) {
                
                view.hidden = YES;
            }
        }
        for (UIView *subView in view.subviews) {
            
            [self cht_getBackView:subView color:color];
        }
        self.navigationController.navigationBar.barTintColor = color;
    }
#endif
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
