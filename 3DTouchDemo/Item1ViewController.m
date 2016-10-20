//
//  Item1ViewController.m
//  3DTouchDemo
//
//  Created by 宋晓光 on 20/10/2016.
//  Copyright © 2016 Light. All rights reserved.
//

#import "Item1ViewController.h"

#define CellID @"CellID"

@interface Item1ViewController () <UITableViewDelegate, UITableViewDataSource,
                                   UIViewControllerPreviewingDelegate>

@property(nonatomic, strong) UITableView *tableView;

@end

@implementation Item1ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.backgroundColor = [UIColor greenColor];
  self.title = @"Item1";

  self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                style:UITableViewStylePlain];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:CellID];
  [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return 20;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];

  cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];

  //  添加3D Touch peek 、pop
  if (self.traitCollection.forceTouchCapability ==
      UIForceTouchCapabilityAvailable) {
    [self registerForPreviewingWithDelegate:self sourceView:cell];
  } else {
    NSLog(@"您的设备不支持3D Touch");
  }

  return cell;
}

- (UIViewController *)previewingContext:
                          (id<UIViewControllerPreviewing>)previewingContext
              viewControllerForLocation:(CGPoint)location {

  NSLog(@"peek");
  NSLog(@"point %@", NSStringFromCGPoint(location));
  NSLog(@"rect %@", NSStringFromCGRect(previewingContext.sourceRect));

  UIViewController *previewVC = [[UIViewController alloc] init];

  // 加个白色背景
  UIView *bgView = [[UIView alloc] initWithFrame:previewVC.view.bounds];
  bgView.backgroundColor = [UIColor whiteColor];
  bgView.layer.cornerRadius = 10;
  bgView.clipsToBounds = YES;
  [previewVC.view addSubview:bgView];

  // 加个lable
  UILabel *lable = [[UILabel alloc] initWithFrame:bgView.bounds];
  lable.textAlignment = NSTextAlignmentCenter;
  lable.text = @"有种再按重一点...";
  [bgView addSubview:lable];

  return previewVC;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext
     commitViewController:(UIViewController *)viewControllerToCommit {
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
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
