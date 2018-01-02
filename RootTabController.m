//
//  RootTabController.m
//  LouYu
//
//  Created by barby on 2017/7/14.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "RootTabController.h"

#import "TransitionAnimation.h"
#import "TransitionController.h"

#import "MainViewController.h"
#import "MyViewController.h"
#import "BrieReportViewController.h"
@interface RootTabController ()<UITabBarControllerDelegate>
@property(nonatomic, strong)UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation RootTabController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self deleteSubViewData];
    self.delegate = self;
    self.selectedIndex = 0;
   // [self.view addGestureRecognizer:self.panGestureRecognizer];
    

    [self.view setBackgroundColor:[UIColor whiteColor]];
    //创建主页控制器
    MainViewController *manCV=[[MainViewController alloc] init];
    UINavigationController *mainNV=[[UINavigationController alloc] initWithRootViewController:manCV];
    
    //设置导航栏背景图片
    mainNV.navigationBar.translucent=YES;
    [mainNV.navigationBar setBackgroundImage:[UIImage imageNamed:@"1.pic_hd"] forBarMetrics:0];
    [self addSubViewController:mainNV andTitle:@"返回" andNormalImage:@"btn_firse_normal.52.png" andSelectedImage:@"btn_firse_selected.52.png"];
    //创建简报控制器
    UINavigationController *BrieReportNV=[[UINavigationController alloc] initWithRootViewController:[[BrieReportViewController alloc] init]];
    //设置导航栏背景图片
    BrieReportNV.navigationBar.translucent=YES;

    [BrieReportNV.navigationBar setBackgroundImage:[UIImage imageNamed:@"1.pic_hd"] forBarMetrics:0];
    [self addSubViewController:BrieReportNV andTitle:@"返回" andNormalImage:@"btn_jianbao_normal.52.png" andSelectedImage:@"btn_jianbao_selected.52.png"];
    //创建我的控制器
    UINavigationController *MyNV=[[UINavigationController alloc] initWithRootViewController:[[MyViewController alloc] init]];
    //设置导航栏背景图片
    MyNV.navigationBar.translucent=YES;
    //[MyNV.navigationBar setBackgroundImage:[UIImage imageNamed:@"1.pic_hd"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"1.pic_hd"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [self addSubViewController:MyNV andTitle:@"返回" andNormalImage:@"btn_wode_normal.52.png" andSelectedImage:@"btn_wode_selected.52.png"];

    
}
//添加tabbar
-(void)addSubViewController:(UINavigationController *)BarController andTitle:(NSString *)titile andNormalImage:(NSString *)image andSelectedImage:(NSString *)selectImage{
    
    //设置标题
   // [BarController.tabBarItem setTitle:titile];
    //设置没有选择是的图片
    [BarController.tabBarItem setImage:[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    //设置选择时的图片
    [BarController.tabBarItem setSelectedImage:[[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    //更改文字的颜色(被选择时)
    //[BarController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:KRGB(254, 65, 181, 1.0)} forState:UIControlStateSelected];
    //[BarController.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} forState:UIControlStateNormal];
    BarController.tabBarItem.imageInsets=UIEdgeInsetsMake(6, 0, -6, 0);
    
    [self addChildViewController:BarController];
}



////滑动手势实现：
//- (UIPanGestureRecognizer *)panGestureRecognizer{
//    if (_panGestureRecognizer == nil){
//        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
//    }
//    return _panGestureRecognizer;
//}
//
//- (void)panGestureRecognizer:(UIPanGestureRecognizer *)pan{
//    if (self.transitionCoordinator) {
//        return;
//    }
//    
//    if (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged){
//        [self beginInteractiveTransitionIfPossible:pan];
//    }
//}
//
//- (void)beginInteractiveTransitionIfPossible:(UIPanGestureRecognizer *)sender{
//    CGPoint translation = [sender translationInView:self.view];
//    if (translation.x > 0.f && self.selectedIndex > 0) {
//        self.selectedIndex --;
//    }
//    else if (translation.x <= 0.f && self.selectedIndex + 1 < self.viewControllers.count) {
//        self.selectedIndex ++;
//    }
//    else {
//        if (!CGPointEqualToPoint(translation, CGPointZero)) {
//            sender.enabled = NO;
//            sender.enabled = YES;
//        }
//    }
//    
//    [self.transitionCoordinator animateAlongsideTransitionInView:self.view animation:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
//        
//    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
//        if ([context isCancelled] && sender.state == UIGestureRecognizerStateChanged){
//            [self beginInteractiveTransitionIfPossible:sender];
//        }
//    }];
//}
//
//- (id<UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController animationControllerForTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
//    // 打开注释 可以屏蔽点击item时的动画效果
//    //    if (self.panGestureRecognizer.state == UIGestureRecognizerStateBegan || self.panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
//    NSArray *viewControllers = tabBarController.viewControllers;
//    if ([viewControllers indexOfObject:toVC] > [viewControllers indexOfObject:fromVC]) {
//        return [[TransitionAnimation alloc] initWithTargetEdge:UIRectEdgeLeft];
//    }
//    else {
//        return [[TransitionAnimation alloc] initWithTargetEdge:UIRectEdgeRight];
//    }
//    //    }
//    //    else{
//    //        return nil;
//    //    }
//}
//
//- (id<UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
//    if (self.panGestureRecognizer.state == UIGestureRecognizerStateBegan || self.panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
//        return [[TransitionController alloc] initWithGestureRecognizer:self.panGestureRecognizer];
//    }
//    else {
//        return nil;
//    }
//}

-(void)deleteSubViewData{

    //创建NSUserDefaults的对象 - 单例对象
    NSUserDefaults *defaults1=[NSUserDefaults standardUserDefaults];
    //先删除
    [defaults1 removeObjectForKey:@"KUserName"];
    [defaults1 removeObjectForKey:@"KuserID"];
    [defaults1 removeObjectForKey:@"KheadImgUrl"];
    [defaults1 removeObjectForKey:@"KplaceName"];
    [defaults1 removeObjectForKey:@"KplaceID"];
    [defaults1  removeObjectForKey:@"KImagesArr"];
    [defaults1  removeObjectForKey:@"KimageArray"];
    [defaults1  removeObjectForKey:@"Kvoice"];
    [defaults1 removeObjectForKey:@"MtypeName"];
    [defaults1  removeObjectForKey:@"MtypeID"];
//    [defaults1  removeObjectForKey:@"Knumber"];
     [defaults1  removeObjectForKey:@"KtypeName"];
    [defaults1  removeObjectForKey:@"KtypeID"];
    [defaults1  removeObjectForKey:@"Ktext"];
    [defaults1 removeObjectForKey:@"MUserName"];
    [defaults1 removeObjectForKey:@"MuserID"];
    [defaults1 removeObjectForKey:@"MheadImgUrl"];
    [defaults1 removeObjectForKey:@"KBeganTime"];
    [defaults1 removeObjectForKey:@"KEndTime"];
    [defaults1 removeObjectForKey:@"KuserRoleInfo"];
    

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
