# CHTNavigationBarDemo
UINavigationBar 显示、隐藏、改变颜色、去掉底部的直线

![](https://github.com/ChanRoy/CHTNavigationBarDemo/blob/master/CHTNavigationBarDemo.gif)

## 简介
*UINavigationBar 显示、隐藏、改变颜色、去掉底部的直线效果*

*效果如上图*

## 前言
**UINavigationBar**大家都不陌生，关于**UINavigationBar**的显示跟隐藏可通过以下API实现：

```
- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated; 
```
设置颜色可通过以下设置以下属性实现：

```
@property(nullable, nonatomic,strong) UIColor *barTintColor 
```
但是当我想实现**UINavigationBar**的颜色透明度随着**UITableView**的滚动而改变时，发现以上API并不能满足要求。经过一番测试，找出了以下解决方法。

## 实现过程
- 我们先观察下**UINavigationBar**的视图层级关系：

- 先解决**UINavigationBar**下方的直线：

由上图可以看出，不管iOS几，直线都是一个**UIImageView**。我们通过递归方法找到它，将它隐藏即可。

获取直线的方法如下：

```
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
```
找到后将其隐藏即可：

```
//隐藏UINavigationBar下方的直线
[self findHairlineImageViewUnder:self.navigationController.navigationBar].hidden = YES;
```
- **iOS10**以下**UINavigationBar**修改颜色的解决方案：

通过递归方法找到背景图层**_UINavigationBarBackground**并修改颜色，找到背景图层上遮盖层**_UIBackdropView**并将其隐藏。

具体代码如下：

```
- (void)cht_getBackView:(UIView *)view color:(UIColor *)color{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
        
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
   
```
- **iOS10**以上**UINavigationBar**修改颜色的解决方案：

iOS10的情况比较复杂。单纯的隐藏遮盖层**UIVisualEffectView**并不能解决问题，需要修改遮盖层的颜色。另外相同的系统在iPhone的不同型号上也会出现差异。这里我只给出最后的解决方案。

具体代码如下：

```
- (void)cht_getBackView:(UIView *)view color:(UIColor *)color{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
	if ([view isKindOfClass:NSClassFromString(@"_UIBarBackground")] ||
	            [view isKindOfClass:NSClassFromString(@"UIVisualEffectView")]) {
	            
	            
	    CGFloat alpha;
	    [color getWhite:nil alpha:&alpha];
	    view.backgroundColor = color;
	    //UIVisualEffectView 的颜色alpha值需要这样设置，过大的alpha(例如0.9)将不会有透明效果
	    if ([view isKindOfClass:NSClassFromString(@"UIVisualEffectView")]) {
	        
	        ((UIVisualEffectView *)view).alpha = alpha;
	        
	    }
	    //color为透明颜色(alpha == 0)则隐藏遮盖层
	    view.hidden = alpha == 0 ? YES : NO;
	}
	for (UIView *subView in view.subviews) {
	    
	    [self cht_getBackView:subView color:color];
	}
	self.navigationController.navigationBar.barTintColor = color;
}
```
完整的代码请参考仓库中的DEMO。

## TODO
有更好的方案欢迎issue进行交流。