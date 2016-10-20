//
//  PreviewViewController.m
//  3DTouchDemo
//
//  Created by 宋晓光 on 20/10/2016.
//  Copyright © 2016 Light. All rights reserved.
//

#import "PreviewViewController.h"

@interface PreviewViewController ()

@property(nonatomic, strong) UIImageView *imageView;

@end

@implementation PreviewViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.backgroundColor = [UIColor yellowColor];

  self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
  self.imageView.image = self.image;
  [self.view addSubview:self.imageView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

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

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  NSArray *arrayTouch = [touches allObjects];
  UITouch *touch = (UITouch *)[arrayTouch lastObject];
  NSLog(@"force = %f", touch.force);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
