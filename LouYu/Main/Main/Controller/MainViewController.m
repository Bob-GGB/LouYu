//
//  MainViewController.m
//  LouYu
//
//  Created by barby on 2017/7/14.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "MainViewController.h"
#import "HeadButtonsView.h"
#import "XunJianTableViewCell.h"
#import "NewTableViewCell.h"
#import <AFNetworking.h>
#import "UserInfoModel.h"
#import "indexWarnModel.h"
#import "indexWorkModel.h"
#import "indexArticleListModel.h"
#import "indexArticleTypeListModel.h"
#import "NewsDetailViewController.h"
//#import "DetailViewController.h"
#import "RegistrationViewController.h"
#import "EventDetailViewController.h"
#import "WarnDetailViewController.h"
#import "EventsDetailViewController.h"
#import "CompanyListViewController.h"
#import "EventTableViewCell.h"
#import <JPUSHService.h>
@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
/*
 创建TableView
 */
@property(nonatomic,strong)UITableView *MainTableView;
//新闻数组
@property(nonatomic,strong)NSMutableArray *newsDataArry;
//工作的信息数组
@property(nonatomic,strong)NSMutableArray *workArry;
@property(nonatomic,strong)NSMutableArray *warnArry;
//用户信息数组
//@property(nonatomic,strong)NSMutableArray *userInfoArr;
//服务器返回的数据存到这个字典里
@property(nonatomic,strong)NSMutableDictionary *InfoDictionary;
@property(nonatomic,strong)NSNumber *tokenStr;

@property(nonatomic,strong)UserInfoModel *userModel;
@property(nonatomic,strong)NSNumber *roleID;
@property(nonatomic,copy)NSString *companyStr;
@property (nonatomic,strong) NSNumber *parentID;

@end

@implementation MainViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *dic=[defaults dictionaryForKey:@"UserInfoDic"];
    //取到userInfo
    NSDictionary *userDic=dic[@"content"][@"userInfo"];
    self.roleID=userDic[@"roleID"];
    self.parentID=userDic[@"parentID"];
    self.userModel=[[UserInfoModel alloc] initWithDict:userDic];
    
    //设置右侧显示
    NSUserDefaults *defaultss=[NSUserDefaults standardUserDefaults];
    if ([defaultss objectForKey:@"MtypeName"]==nil) {
        [self setrightBarButtonItemWithImageName:nil andTitle:self.userModel.userRoleInfo];
    }else{
        [self setrightBarButtonItemWithImageName:nil andTitle:[defaultss objectForKey:@"KuserRoleInfo"]];
    }
    NSMutableArray *userArr=[NSMutableArray array];
    
    [userArr addObject:self.userModel];
    
    //NSLog(@"token:%@",self.userModel.token);
    self.tokenStr=self.userModel.token;
    
    
//    [ClearCache showHUDAndView:self.navigationController.view completionBlock:^{
    
        [self PostDataToSever];
//    }];
    
    
    [self sizeToLabelWidth];
   
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
   
    [ClearCache showHUDAndView:self.navigationController.view completionBlock:^{
       
            [self PostDataToSever];
    }];
 //[self.navigationItem setTitle:self.userModel.companyName];
    //[self.navigationController.navigationBar setTitleTextAttributes:
//     @{NSFontAttributeName:[UIFont systemFontOfSize:15],
//       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
   
   
    
    
}
/**
   *  自动计算label的宽度  前提 ：高度固定
   */

#pragma mark -自定义导航栏titleView
 - (void)sizeToLabelWidth
 {
         UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
         label.textColor = [UIColor whiteColor];
         label.font = [UIFont systemFontOfSize:15];
         label.textColor=[UIColor whiteColor];
     label.textAlignment = NSTextAlignmentCenter;
     
      NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
     if ([defaults valueForKey:@"KcompanyName"]==NULL) {
        self.companyStr =self.userModel.companyName;
     }
     else{
         self.companyStr=[defaults valueForKey:@"KcompanyName"];
     }
     
         NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
         attrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    
         CGSize size =  [self.companyStr boundingRectWithSize:CGSizeMake(MAXFLOAT,label.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
         label.frame = CGRectMake(100, 100, size.width,40);
         label.text = self.companyStr;
     self.navigationItem.titleView=label;
     
     if ([self.roleID isEqualToNumber:@3]&&[self.parentID isEqualToNumber:@0]) {
         UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(companyDidPress:)];
         [self.navigationItem.titleView addGestureRecognizer:tap0];
         [self.navigationItem.titleView setUserInteractionEnabled:YES];
     }

     
     }


-(void)companyDidPress:(UITapGestureRecognizer *)sender{
    CompanyListViewController *companyCV=[[CompanyListViewController alloc] init];
    [companyCV setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:companyCV animated:NO];
    
}

/**********************上传json到服务器请求数********************************/

-(void)PostDataToSever{
NSString *urlString = @"http://louyu.qianchengwl.cn/minapp/index/getIndex";
[HttpRequest POST:urlString getToken:self.tokenStr paramentDict:nil success:^(id responseObj) {
            //请求成功返回数据；需要转化成字典（即json格式数据）
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves error:nil];
    
    if ([dict[@"code"] isEqualToNumber:@(-1001)]) {
       
        [ClearCache showHUDWithText:@"该账号已在其他设备登录，请重新登录"];
        LoginViewController *logInCV=[[LoginViewController alloc] init];
        [self presentViewController:logInCV animated:YES completion:nil];
    }

    else{
        
            self.InfoDictionary =[NSMutableDictionary dictionaryWithDictionary:dict];
            //取到Warn
            NSArray *arr= self.InfoDictionary[@"content"][@"warn"];
    
           // NSLog(@"arr----:%@",arr);
    
        [self.warnArry removeAllObjects];
    
            for (NSDictionary *obj in arr) {
                indexWarnModel *warnModel=[[indexWarnModel alloc] initWithDict:obj];
                [self.warnArry addObject:warnModel];
    
//                NSLog(@"warnModel:%@",warnModel.title);
            }
        
            //取到Work
            NSArray *arr1= self.InfoDictionary[@"content"][@"work"];
           [self.workArry removeAllObjects];
            for (NSDictionary *obj in arr1) {
                indexWorkModel *WorkModel=[[indexWorkModel alloc] initWithDict:obj];
                [self.workArry addObject:WorkModel];
               
//            NSLog(@"WorkModel:%@",WorkModel.title);
            }
       
    
            //取到articleList
            NSArray *ArticleArr= self.InfoDictionary[@"content"][@"articleList"];
    
            //NSLog(@"ArticleArr:%@",ArticleArr);
    
            self.newsDataArry=[NSMutableArray array];
            for (NSDictionary *obj in ArticleArr) {
                indexArticleListModel *ArticleListModel=[[indexArticleListModel alloc] initWithDict:obj];
                [self.newsDataArry addObject:ArticleListModel];
    
                //NSLog(@"ArticleListModel:%@",ArticleListModel.title);
            }
           [self.MainTableView removeFromSuperview];
           [self.view addSubview:self.MainTableView];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.MainTableView reloadData];
        });
        
    }
    
} failure:^(NSError *error) {
    
     NSLog(@"Error: %@", error);
    
}];

}


/************************************************************************/



#pragma -懒加载创建tableView
-(UITableView *)MainTableView{
    if (_MainTableView==nil) {
        _MainTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth,( KscreenHeight-64-49)*Height) style:UITableViewStylePlain];
       
        //去除分割线
       // _MainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_MainTableView setBackgroundColor:[UIColor whiteColor]];
        [_MainTableView setDelegate:self];
        [_MainTableView setDataSource:self];
        
       
       // [self PostDataToSever];

    }
    
    return _MainTableView;
}

-(NSMutableArray *)workArry{
    if (_workArry==nil) {
        _workArry=[NSMutableArray array];
    }
    return _workArry;
}


//设置组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

//设置每一组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        
        if (self.workArry.count>1) {
            return 1;
        }
        else
        return self.workArry.count;
    }
    else if (section==1){
        return self.warnArry.count;
    }
    else
       
    return self.newsDataArry.count;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self)weakSelf = self;
    if (indexPath.section==0) {
        static NSString *IDEvent=@"IDEvent";
        EventTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:IDEvent];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell==nil) {
            cell=[[EventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IDEvent];
            
        }
        //去除横线
        //tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [cell.lineView removeFromSuperview];
        indexWorkModel *model=self.workArry[indexPath.row];
        [cell DataWithModel:model];
        [cell setSendController:^(UIViewController *controller) {
            [controller setHidesBottomBarWhenPushed:YES];
            [weakSelf.navigationController pushViewController:controller animated:NO];
        }];
       
        return cell;
    }

   else if (indexPath.section==1) {
        static NSString *ID1=@"ID1";
        XunJianTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:ID1];
       
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell==nil) {
            cell=[[XunJianTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID1];
          
        }
        //去除横线
        //tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
       [cell.lineView removeFromSuperview];
        indexWarnModel *model=self.warnArry[indexPath.row];
        [cell bindDataWithModel:model];
       cell.roleIDnum=self.roleID;
       
       [cell setSendController:^(UIViewController *controller) {
           [controller setHidesBottomBarWhenPushed:YES];
           [weakSelf.navigationController pushViewController:controller animated:NO];
       }];
       
        return cell;
    }
    else if (indexPath.section==2)
    {
        static NSString *ID2=@"ID2";
        NewTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID2];
        if (cell==nil) {
            cell=[[NewTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID2];
        }
        //先取到对象

        indexArticleListModel *model=self.newsDataArry[indexPath.row];
        [cell bindDataWithModel:model];
    
        return cell;
    
    }
    return nil;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //设置间隔高度
    if (section==0) {
        return 180*Height;
    }
    else if (section==2) {
        return 35*Height;
    }
    else if (section==1) {
        return 0.1f;
    }
    else
        return 0.1f;
    }

//返回单元格行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 160*Height;
    
    }
    else if(indexPath.section==1){
    
        return 160*Height;
    }
    else if(indexPath.section==2)
    {
        return 104*Height;
    }
    else
      return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        
               //将用户身份的ID传到HeadButtonsView中去改变按钮功能
        HeadButtonsView *imageView=[[HeadButtonsView alloc] initWithRoleID:self.userModel.roleID];
        [imageView setFrame:CGRectMake(0, 0, KscreenWidth, 180*Height)];
        //每个cell之间的间隔
        UIView *BlowLineView=[[UIView alloc] initWithFrame:CGRectMake(0, imageView.frame.size.height-10, KscreenWidth, 10)];
        [BlowLineView setBackgroundColor:KRGB(240, 240, 240, 1.0)];
        [imageView addSubview:BlowLineView];

        __weak typeof(self)weakSelf = self;
        [imageView setSendController:^(UIViewController *controller) {
            
           // [weakSelf presentViewController:controller animated:YES completion:nil];
            [controller setHidesBottomBarWhenPushed:YES];
            [weakSelf.navigationController pushViewController:controller animated:NO];
        }];
        
        [tableView addSubview:imageView];
        
        return imageView;
    }
    else if (section == 2)
    {
        
        UIView *HeadImageView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 35*Height)];
        UIView *BlowLineView=[[UIView alloc] initWithFrame:CGRectMake(0, HeadImageView.frame.size.height-1, KscreenWidth,1)];
        [BlowLineView setBackgroundColor:KRGB(230, 230, 230, 1.0)];
        [HeadImageView addSubview:BlowLineView];

        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(10*Width, 14*Height, 60*Width, 15*Height)];
        [imageView setImage:[UIImage imageNamed:@"redianxinwen.png"]];
        [HeadImageView addSubview:imageView];
        
        return HeadImageView ;
    }
    else
        return nil;

}


//反选  点击的时候灰色 返回来的时候 又变回白色
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==0) {
        
        indexWorkModel *model=self.workArry[indexPath.row];
        if ([self.roleID isEqualToNumber:@1]||[self.roleID isEqualToNumber:@3]) {
            EventsDetailViewController *EVSCV=[[EventsDetailViewController alloc] init];
            EVSCV.workIDnum=model.workID;
            [EVSCV setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:EVSCV animated:NO];
        }
        
        else{
        
        EventDetailViewController *DetailViewCV=[[EventDetailViewController alloc] init];
        
        DetailViewCV.workIDnum=model.workID;
        DetailViewCV.statusNum=model.status;
        [DetailViewCV setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:DetailViewCV animated:NO];
        }
    }
    
    if (indexPath.section==1) {
        indexWarnModel *model=self.warnArry[indexPath.row];
        WarnDetailViewController *DetailViewCV=[[WarnDetailViewController alloc] init];
        DetailViewCV.warnIDStr=model.warnID;
//        NSLog(@"model.warnID:%@",model.warnID);
        [DetailViewCV setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:DetailViewCV animated:NO];
    }
    
    if (indexPath.section==2) {
        indexArticleListModel *model=self.newsDataArry[indexPath.row];
        NewsDetailViewController *NewsDetailViewCV=[[NewsDetailViewController alloc] init];
        NewsDetailViewCV.articleID=model.articleID;
        [NewsDetailViewCV setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:NewsDetailViewCV animated:NO];
    }
    
    
    
    
    
}
#pragma --设置cell的分割线
-(void)viewDidLayoutSubviews {
    
    if ([self.MainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.MainTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.MainTableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.MainTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}




- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat sectionHeaderHeight =170 ;
    
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        
    } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
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
