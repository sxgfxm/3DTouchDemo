# 3DTouchDemo
3D Touch Demo
## 3D Touch简介

3D Touch是智能手机领域最先进技术之一，目前只有Apple在iPhone上构建了相对良好的生态，并在最新推出的iOS 10中进一步优化了用户体验，Android系统和手机厂商还未提供较为成熟的支持。 本文主要介绍3D Touch相关技术的基本实现方法，包括：

1、Home Screen Quick Actions，主屏幕快捷访问；

2、Peek and Pop，预览和进入；

3、3D Touch Force，3D touch压力值运用。

## Home Screen Quick Action

### 显示效果

在主屏幕按下应用图标，会弹出设定好的快捷访问入口。本文采用纯代码创建，也可以通过设置Info.plist实现。

### 代码实现

首先，在**AppDelegate.m**的`application:didFinishLaunchingWithOptions:`方法中添加**UIApplicationShortcutItems**。

```objective-c
- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Override point for customization after application launch.
  //  主界面入口
  ViewController *vc = [[ViewController alloc] init];
  self.mainNav = [[UINavigationController alloc] initWithRootViewController:vc];
  self.window.rootViewController = self.mainNav;

  //  创建快捷访问Items
  UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon
      iconWithType:UIApplicationShortcutIconTypeTask];
  UIApplicationShortcutItem *item1 =
      [[UIApplicationShortcutItem alloc] initWithType:@"item1"
                                       localizedTitle:@"item1"
                                    localizedSubtitle:@"1"
                                                 icon:icon1
                                             userInfo:nil];
  UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon
      iconWithType:UIApplicationShortcutIconTypeMail];
  UIApplicationShortcutItem *item2 =
      [[UIApplicationShortcutItem alloc] initWithType:@"item2"
                                       localizedTitle:@"item2"
                                    localizedSubtitle:@"2"
                                                 icon:icon2
                                             userInfo:nil];
  //  添加快捷访问Items
  application.shortcutItems = @[ item1, item2 ];
  return YES;
}
```

然后，在**AppDelegate.m**中添加如下方法，用于响应快捷访问事件。

```objective-c
- (void)application:(UIApplication *)application
    performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem
               completionHandler:(void (^)(BOOL))completionHandler {
  //  响应Item对应的操作，跳转至对应controller
  if ([shortcutItem.type isEqualToString:@"item1"]) {
    Item1ViewController *vc = [[Item1ViewController alloc] init];
    [self.mainNav pushViewController:vc animated:YES];
  }
  if ([shortcutItem.type isEqualToString:@"item2"]) {
    Item2ViewController *vc = [[Item2ViewController alloc] init];
    [self.mainNav pushViewController:vc animated:YES];
  }
}
```

运行效果： 

 ![step1](http://ofj92itlz.bkt.clouddn.com/3DTouch:step1.jpeg)

## Peek and Pop

3D Touch按压力度可以分为两级，一级力度触发**peek**，二级力度触发**pop**。

**peek**相当于**预览**与按压view相关的**view controller**。**pop**相当于**跳转**至对应的**view controller**。

### 为view添加3D Touch响应

本文以UIImageView为例，实现图片的预览效果。

```objective-c
  //  创建ImageView
  self.imageView = [[UIImageView alloc]
      initWithFrame:CGRectMake(self.view.bounds.size.width / 2 - 50, 300, 100,
                               100)];
  self.imageView.image = [UIImage imageNamed:@"junxi3.jpeg"];
  //  非常重要
  self.imageView.userInteractionEnabled = YES;
  [self.view addSubview:self.imageView];
  //  添加3D Touch 响应
  if (self.traitCollection.forceTouchCapability ==
      UIForceTouchCapabilityAvailable) {
    [self registerForPreviewingWithDelegate:self sourceView:self.imageView];
  } else {
    NSLog(@"您的设备不支持3D Touch");
  }
```

通过**UIViewController**的 `registerForPreviewingWithDelegate:sourceView:`方法添加3D Touch响应。需要遵守**UIViewControllerPreviewingDelegate**协议，并实现分别对应**peek**和**pop**的代理方法。

注意，添加3D Touch响应的view，一定要使**userInteractionEnabled = YES**，否则无法响应。

### peek相关代理方法实现

实现代理方法`previewingContext:viewControllerForLocation:`，在该代理方法中创建并返回待预览的**view controller**。

```objective-c
//  peek
- (UIViewController *)previewingContext:
                          (id<UIViewControllerPreviewing>)previewingContext
              viewControllerForLocation:(CGPoint)location {
  //  log信息
  NSLog(@"peek");
  NSLog(@"point %@", NSStringFromCGPoint(location));
  NSLog(@"rect %@", NSStringFromCGRect(previewingContext.sourceRect));
  //  创建待预览view controller
  PreviewViewController *previewVC = [[PreviewViewController alloc] init];
  //  设置大小
  previewVC.preferredContentSize = CGSizeMake(0.0f, 0.0f);
  //  设置内容
  previewVC.image = self.imageView.image;
  //  设置高亮显示区域，其他区域会模糊显示
  previewingContext.sourceRect = self.imageView.frame;
  //  返回待预览view controller
  return previewVC;
}
```

其中，previewingContext.sourceRect用于设置高亮区域，location为点击手势在view中的位置，preferredContentSize用于设置预览区域大小，为0时系统会设为最佳显示大小。

运行效果：

![step2](http://ofj92itlz.bkt.clouddn.com/3DTouch:step2.jpeg)      ![step3](http://ofj92itlz.bkt.clouddn.com/3DTouch:step3.jpeg) 

### 在PreviewViewController中添加预览状态快捷选项

在**peek**状态下，向上滑动，即可弹出快捷选项。

```objective-c
- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
  // setup a list of preview actions
  UIPreviewAction *action1 = [UIPreviewAction
      actionWithTitle:@"Aciton1"
                style:UIPreviewActionStyleDefault
              handler:^(UIPreviewAction *_Nonnull action,
                        UIViewController *_Nonnull previewViewController) {
                NSLog(@"Aciton1");
              }];

  UIPreviewAction *action2 = [UIPreviewAction
      actionWithTitle:@"Aciton2"
                style:UIPreviewActionStyleDefault
              handler:^(UIPreviewAction *_Nonnull action,
                        UIViewController *_Nonnull previewViewController) {
                NSLog(@"Aciton2");
              }];

  UIPreviewAction *action3 = [UIPreviewAction
      actionWithTitle:@"Aciton3"
                style:UIPreviewActionStyleDefault
              handler:^(UIPreviewAction *_Nonnull action,
                        UIViewController *_Nonnull previewViewController) {
                NSLog(@"Aciton3");
              }];

  NSArray *actions = @[ action1, action2, action3 ];
  return actions;
}
```

运行效果：

 ![step4](http://ofj92itlz.bkt.clouddn.com/3DTouch:step5.jpeg)

### pop相关代理方法

实现代理方法`previewingContext:commitViewController:`，在该代理方法中跳转。

```objective-c
//  pop
- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext
     commitViewController:(UIViewController *)viewControllerToCommit {
  //  log信息
  NSLog(@"pop");
  //  跳转至对应view controller
  [self showViewController:viewControllerToCommit sender:self];
}
```

运行效果：

 ![step5](http://ofj92itlz.bkt.clouddn.com/3DTouch:step4.jpeg)

## 3D Touch Force简单运用

在`touchesMoved:withEvent:`方法中，获取touch对象，可以根据force属性值做相应操作。

```objective-c
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  NSArray *arrayTouch = [touches allObjects];
  UITouch *touch = (UITouch *)[arrayTouch lastObject];
  NSLog(@"force = %f", touch.force);
}
```

## 参考资料

[Adopting 3D Touch on iPhone](https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/Adopting3DTouchOniPhone/#//apple_ref/doc/uid/TP40016543-CH1-SW1)

[iOS9新特性 3DTouch 开发教程全解](http://www.tuicool.com/articles/auIJbiN)

### Github源码

[3DTouchDemo](https://github.com/sxgfxm/3DTouchDemo)
