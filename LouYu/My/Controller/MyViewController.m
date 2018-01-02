//
//  MyViewController.m
//  LouYu
//
//  Created by barby on 2017/7/14.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "MyViewController.h"

#import "SettingCell.h"
#import "SettingItemModel.h"
#import "SettingSectionModel.h"
#import "SettingViewController.h"
#import "Const.h"
#import "HeadView.h"
#import "UserInfoModel.h"
#import "ContentModel.h"
#import "MBProgressHUD.h"
#import "CollectionViewController.h"
#import "RelateToMeViewController.h"
@interface MyViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>
/*
 创建TableView
 */
@property(nonatomic,strong)UITableView *myTableView;

@property (nonatomic,strong) NSArray  *sectionArray; /**< section模型数组*/

@property(nonatomic,strong)UserInfoModel *userModel;
@property(nonatomic,strong)HeadView *headView;

@property(nonatomic,strong)NSNumber *tokenStr;
@property(nonatomic,strong)NSString *headImgStr;
@property(nonatomic,strong)ContentModel *contentModel;

@property(nonatomic,strong)UIImage *headImage;
@property (nonatomic,assign) float oldY;
@end

@implementation MyViewController

//进入程序时从沙盒拿图片 后者去服务端下载
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self getToken];
    
    NSUserDefaults *defaultss=[NSUserDefaults standardUserDefaults];
    if ([defaultss valueForKey:@"KHeadImage"]==NULL) {
        
        if ([defaultss valueForKey:@"KHeadImageURL"]!=NULL) {
            
          [self.headView.headImageView sd_setImageWithURL:[NSURL URLWithString:[defaultss valueForKey:@"KHeadImageURL"]]];
        }
        else{
        [self.headView.headImageView sd_setImageWithURL:[NSURL URLWithString:self.headImgStr]];
        self.headImage=NULL;
        self.headImage=self.headView.headImageView.image;
        }
    }
    else{
        
        UIImage *newImg=[UIImage imageWithData:[defaultss valueForKey:@"KHeadImage"]];
        self.headImage=newImg;
        [self.headView.headImageView setImage:newImg];
    }

   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航控制器的代理为self
     [AtuoFillScreenUtils autoLayoutFillScreen:self.view];
    self.navigationController.delegate = self;
     self.view.backgroundColor =[UIColor blackColor];
    
    UIImageView *navigationImageView=[[UIImageView alloc] init];
    [navigationImageView setFrame:CGRectMake(0, 0, KscreenWidth, 64)];
    [navigationImageView setImage:[UIImage imageNamed:@"1.pic_hd"]];
    [self.view addSubview:navigationImageView];
    
    
    

    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *dic=[defaults dictionaryForKey:@"UserInfoDic"];
    //取到userInfo
    NSDictionary *userDic=dic[@"content"][@"userInfo"];
    
    self.userModel=[[UserInfoModel alloc] initWithDict:userDic];
    
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(navigationImageView.frame), KscreenWidth, 100*Height)];
    [imageView setImage:[UIImage imageNamed:@"1.pic_hd"]];
    self.headView=[[HeadView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 100*Height)];
    [self.headView addSubview:self.headView.phoneLabel];
     [self.headView addSubview:self.headView.nameLabel];
    
    //[self.headView.headImageView sd_setImageWithURL:[NSURL URLWithString:self.userModel.thumb]];
    self.headView.nameLabel.text=self.userModel.truename;
    self.headView.phoneLabel.text=self.userModel.mobile;

    [imageView addSubview:self.headView];
    [imageView setUserInteractionEnabled:YES];
     self.myTableView.tableHeaderView = imageView;
    UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectedHeadViewDidPress)];
    [imageView addGestureRecognizer:tap0];
    
    [self getToken];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        [self PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/user/getUserWarn"];
   
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myTableView reloadData];
        });
        
    });
    
   
    
    self.myTableView.estimatedRowHeight = 0;
    self.myTableView.estimatedSectionHeaderHeight = 0;
    self.myTableView.estimatedSectionFooterHeight = 0;
    
}

-(UITableView *)myTableView{
    if (_myTableView==nil) {
        
        _myTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, KscreenWidth, KscreenHeight-80) style:UITableViewStyleGrouped];

        //去除分割线
         _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.showsVerticalScrollIndicator=NO;
         _myTableView.backgroundColor = MakeColorWithRGB(234, 234, 234, 1);
//        [_myTableView setBackgroundColor:[UIColor whiteColor]];
        [_myTableView setDelegate:self];
        [_myTableView setDataSource:self];
//        [self.myTableView setScrollEnabled:NO];
            }

    
    return _myTableView;
}

- (void)setupSections
{
    
    //************************************section1
    SettingItemModel *item1 = [[SettingItemModel alloc]init];
    item1.funcName = @"今日上报异常";
    item1.img = [UIImage imageNamed:@"icon_leijiyichang.png"];
    item1.detailText =[NSString stringWithFormat:@"%@",self.contentModel.warnAmount];
    item1.accessoryType = SettingAccessoryTypeDisclosureIndicator;
    
    
    SettingItemModel *item2 = [[SettingItemModel alloc]init];
    item2.funcName = @"今日处理异常";
    item2.img = [UIImage imageNamed:@"icon_chuli.png"];
    item2.detailText = [NSString stringWithFormat:@"%@",self.contentModel.dealAmount];
    item2.accessoryType = SettingAccessoryTypeDisclosureIndicator;
    
    
    SettingSectionModel *section1 = [[SettingSectionModel alloc]init];
    section1.sectionHeaderHeight = 20*Height;
    section1.itemArray = @[item1,item2];
    
    SettingItemModel *item3 = [[SettingItemModel alloc]init];
    item3.funcName = @"累计上报异常";
    item3.img = [UIImage imageNamed:@"icon_leijiyichang.png"];
    item3.detailText = [NSString stringWithFormat:@"%@",self.contentModel.allWarnAmount];
    item3.accessoryType = SettingAccessoryTypeDisclosureIndicator;
    
    SettingItemModel *item4 = [[SettingItemModel alloc]init];
    item4.funcName = @"累计处理异常";
    item4.img = [UIImage imageNamed:@"icon_leijichuli.png"];
    item4.detailText = [NSString stringWithFormat:@"%@",self.contentModel.dealAllAmount];
    item4.accessoryType = SettingAccessoryTypeDisclosureIndicator;
    SettingSectionModel *section2 = [[SettingSectionModel alloc]init];
    section2.sectionHeaderHeight = 5*Height;
    section2.itemArray = @[item3,item4];
    
    
    SettingItemModel *item5 = [[SettingItemModel alloc]init];
    item5.funcName = @"清空缓存";
    item5.img = [UIImage imageNamed:@"icon_huancun.png"];
    item5.accessoryType = SettingAccessoryTypeDisclosureIndicator;
    item5.executeCode = ^{
        SDImageCache * tmpCache = [SDImageCache sharedImageCache];
        
        NSUInteger imageSize = [tmpCache getSize];
        
        [tmpCache clearDiskOnCompletion:^{
            
            [ClearCache showHUDWithText:[NSString stringWithFormat:@"已经成功清理%.2fMB缓存",imageSize/1024.0/1024.0]];
            
        }];

    };
    
//    SettingItemModel *item6 = [[SettingItemModel alloc]init];
//    item6.funcName = @"检查更新";
//    item6.detailText=@"当前版本1.0";
//    item6.img = [UIImage imageNamed:@"icon_gengxin.png"];
//    item6.executeCode = ^{
//        [ClearCache showHUDWithText:@"当前版本为最新版本"];
//    };
//    item6.accessoryType = SettingAccessoryTypeDisclosureIndicator;
    
    SettingItemModel *item7 = [[SettingItemModel alloc]init];
    item7.funcName = @"收藏";
    item7.img = [UIImage imageNamed:@"icon_shoucang.png"];
    item7.accessoryType = SettingAccessoryTypeDisclosureIndicator;
    item7.executeCode = ^{
        CollectionViewController *collectionCV=[[CollectionViewController alloc] init];
        [collectionCV setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:collectionCV animated:NO];
    };

    SettingItemModel *item8 = [[SettingItemModel alloc]init];
    item8.funcName = @"与我相关";
    item8.img = [UIImage imageNamed:@"icon_shoucang.png"];
    item8.accessoryType = SettingAccessoryTypeDisclosureIndicator;
    item8.executeCode = ^{
        RelateToMeViewController *relateCV=[[RelateToMeViewController alloc] init];
        [relateCV setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:relateCV animated:NO];
    };
//    SettingItemModel *item9 = [[SettingItemModel alloc]init];
//    item9.funcName = @"关于";
//    item9.img = [UIImage imageNamed:@"icon_guanyu.png"];
//    item9.accessoryType = SettingAccessoryTypeDisclosureIndicator;
    
    SettingSectionModel *section3 = [[SettingSectionModel alloc]init];
    section3.sectionHeaderHeight = 5*Height;
    section3.itemArray = @[item5,item7,item8];
    
    self.sectionArray = @[section1,section2,section3];
}




-(void)getToken{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *dic=[defaults dictionaryForKey:@"UserInfoDic"];
    //取到userInfo
    NSDictionary *userDic=dic[@"content"][@"userInfo"];
    self.tokenStr=userDic[@"token"];
    self.headImgStr=userDic[@"thumb"];
    // NSLog(@"self.tokenStr%@",self.tokenStr);
    
}

/**********************上传json到服务器请求数********************************/

-(void)PostDataToSeverWithUrl:(NSString *)Url{
    
    
    [HttpRequest POST:Url getToken:self.tokenStr paramentDict:nil success:^(id responseObj) {
        
                //请求成功返回数据；需要转化成字典（即json格式数据）
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves error:nil];
                //NSLog(@"self.InfoDictionary :%@",dict);
        if ([dict[@"code"] isEqualToNumber:@(-1001)]) {
            [ClearCache showHUDWithText:@"该账号已在其他设备登录，请重新登录"];
            LoginViewController *logInCV=[[LoginViewController alloc] init];
            [self presentViewController:logInCV animated:YES completion:nil];
        }
        //                NSLog(@"dict:%@",dict);
        else{
                //取到articleList
              self.contentModel=[[ContentModel alloc] initWithDict:dict[@"content"]];
            [self setupSections];
            [self.view addSubview:self.myTableView];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}










#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    SettingSectionModel *sectionModel = self.sectionArray[section];
    return sectionModel.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"setting";
    SettingSectionModel *sectionModel = self.sectionArray[indexPath.section];
    SettingItemModel *itemModel = sectionModel.itemArray[indexPath.row];
    
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[SettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (indexPath.section==2) {
        cell.selectionStyle=UITableViewCellSelectionStyleDefault;
    }
    else{
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    cell.item = itemModel;
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    SettingSectionModel *sectionModel = self.sectionArray[section];
    return sectionModel.sectionHeaderHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (KscreenHeight==736) {
        return 40*Height;
    }
    return 43*Height;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SettingSectionModel *sectionModel = self.sectionArray[indexPath.section];
    SettingItemModel *itemModel = sectionModel.itemArray[indexPath.row];
    if (itemModel.executeCode) {
        itemModel.executeCode();
    }
    
    
    
}


-(void)selectedHeadViewDidPress{
    SettingViewController *setingCV=[[SettingViewController alloc] init];
    setingCV.headImage=self.headImage;
    [setingCV setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:setingCV animated:NO];

}


//uitableview处理section的不悬浮，禁止section停留的方法，主要是这段代码
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    SettingSectionModel *sectionModel = [self.sectionArray firstObject];
    CGFloat sectionHeaderHeight = sectionModel.sectionHeaderHeight;
    
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
#pragma mark ========== 允许上拉，不允许下拉==========
    CGPoint offset = self.myTableView.contentOffset;
    if (offset.y <= 0) {
        offset.y = 0;
    }
    self.myTableView.contentOffset = offset;
    if (self.myTableView.contentOffset.y <= 0) {
        self.myTableView.bounces = NO;

    }
    else
        if (self.myTableView.contentOffset.y >= 0){
            self.myTableView.bounces = YES;
            
            
        }
    

}



- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
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
