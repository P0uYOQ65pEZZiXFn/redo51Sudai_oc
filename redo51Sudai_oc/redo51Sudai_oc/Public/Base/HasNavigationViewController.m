//
//  HasNavigationViewController.m
//  redo51Sudai_oc
//
//  Created by ZhongLiangLiang on 17/5/2.
//  Copyright © 2017年 zhongliangliang. All rights reserved.
//

#import "HasNavigationViewController.h"

@interface HasNavigationViewController ()

/** 导航条View */
@property (nonatomic, weak) UIView *navBarView;

@end

@implementation HasNavigationViewController

//导航栏颜色 app内
- (UIView *)navBarView {
    if (!_navBarView) {
        UIView *navBarView = [[UIView alloc] init];
        navBarView.backgroundColor = MainColor;
        navBarView.frame = CGRectMake(0, 0, ZWIN_WIDTH, 64);
        [self.view addSubview:navBarView];
        self.navBarView = navBarView;
    }
    return _navBarView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    
    // Do any additional setup after loading the view.
    if (self.navigationController.viewControllers.count != 1) {
        UIButton *button = [[UIButton alloc]init];
        button.frame = ZRECTMAKE(0, 0, 11, 20);
        [button setImage:[UIImage imageNamed:@"close_order"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(back_action:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    }
    [self.view addSubview:self.navBarView];
    
    NSString *selfClass = NSStringFromClass([self class]);
    NSLog(@"进入%@",selfClass);
}

//返回上一界面
- (void)back_action:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    if (_back_action) {
        _back_action();
    }
}

// MARK: storyBoard之间的跳转
- (UIStoryboard *)getUIStoryBoard:(NSString *)storyBoardName {
    return [UIStoryboard storyboardWithName:storyBoardName bundle:[NSBundle mainBundle]];
}

- (UIViewController *)getUIViewController:(UIStoryboard *)storyBoard controllerIdentifier:(NSString *)controllerIdentifier {
    return [storyBoard instantiateViewControllerWithIdentifier:controllerIdentifier];
}

- (UIViewController *)storyBoardNavigationPush:(NSString *)storyBoardName controllerIdentifier:(NSString *)controllerIdentifier settingBlockPushVC:(void(^)(UIViewController *vc))settingBlockPushVC {
    UIStoryboard *storyBoard = [self getUIStoryBoard:storyBoardName];
    UIViewController *pushViewController = [self getUIViewController:storyBoard controllerIdentifier:controllerIdentifier];
    settingBlockPushVC(pushViewController);
    [self.navigationController pushViewController:pushViewController animated:YES];
    return pushViewController;
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSString *selfClass = NSStringFromClass([self class]);
    NSLog(@"退出%@",selfClass);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //去掉分割线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
