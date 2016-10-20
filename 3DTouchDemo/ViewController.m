//
//  ViewController.m
//  3DTouchDemo
//
//  Created by 宋晓光 on 20/10/2016.
//  Copyright © 2016 Light. All rights reserved.
//

#import "PreviewViewController.h"
#import "ViewController.h"

@interface ViewController () <UIViewControllerPreviewingDelegate>

@property(nonatomic, strong) UIImageView *imageView;

@property(nonatomic, strong) UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.backgroundColor = [UIColor redColor];
  self.title = @"Main";

  self.label = [[UILabel alloc]
      initWithFrame:CGRectMake(self.view.bounds.size.width / 2 - 50, 200, 100,
                               30)];
  self.label.text = @"Label";
  self.label.textColor = [UIColor whiteColor];
  self.label.textAlignment = NSTextAlignmentCenter;
  [self.view addSubview:self.label];

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
}

#pragma mark - UIViewControllerPreviewingDelegate
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

//  pop
- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext
     commitViewController:(UIViewController *)viewControllerToCommit {
  //  log信息
  NSLog(@"pop");
  //  跳转至对应view controller
  [self showViewController:viewControllerToCommit sender:self];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
// http://www.tuicool.com/articles/auIJbiN
