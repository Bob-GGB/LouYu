//
//  NewsViewController.m
//  LouYu
//
//  Created by barby on 2017/7/26.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "NewsViewController.h"
#import "NewTableViewCell.h"
#import "indexArticleListModel.h"
#import <MJRefresh.h>
#import "NewsDetailViewController.h"
@interface NewsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *NewsTableView;
@property(nonatomic,strong)NSMutableArray *newsArr;

@property(nonatomic,strong)NSNumber *pageIndex;
@property(nonatomic,assign)NSInteger paindex;
@property(nonatomic,strong)NSNumber *tokenStr;
//服务器返回的数据存到这个字典里
@property(nonatomic,strong)NSMutableDictionary *InfoDictionary;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.paindex=3;
    self.pageIndex=@3;
    [self setLeftBarButtonItemWithImageName:@"btn_back_normal.80.png" andTitle:@"返回"];
    [self.view setBackgroundColor:KRGB(211, 211, 211, 1.0)];
    [self setTitle:self.typeName];
    // [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self getToken];
    [self PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/article/getArticleList"];
    [self setUpRefreshAndLoadMore];
    self.NewsTableView.estimatedRowHeight = 0;
    self.NewsTableView.estimatedSectionHeaderHeight = 0;
    self.NewsTableView.estimatedSectionFooterHeight = 0;
   
}


#pragma -下拉刷新和上拉加载更多
-(void)setUpRefreshAndLoadMore{
    self.NewsTableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.NewsTableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    
}
-(void)refreshData{
    


        NSString *urlString = @"http://louyu.qianchengwl.cn/minapp/article/getArticleList";
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setValue:self.typeIDNum forKey:@"typeID"];
        NSMutableDictionary *pageDict=[[NSMutableDictionary alloc] init];
        [pageDict setValue:@2 forKey:@"index"];
        [pageDict setValue:@10 forKey:@"count"];
        [dictionary setValue:pageDict forKey:@"page"];
      [HttpRequest POST:urlString getToken:self.tokenStr paramentDict:dictionary success:^(id responseObj) {
                  //请求成功返回数据；需要转化成字典（即json格式数据）
                  NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves error:nil];
          if ([dict[@"code"] isEqualToNumber:@(-1001)]) {
              [SVProgressHUD showInfoWithStatus:@"该账号已在其他设备登录，请重新登录"];
              [SVProgressHUD dismissWithDelay:1.0];
              LoginViewController *logInCV=[[LoginViewController alloc] init];
              [self presentViewController:logInCV animated:YES completion:nil];
          }
          //                NSLog(@"dict:%@",dict);
          else{
                  self.InfoDictionary =[NSMutableDictionary dictionaryWithDictionary:dict];
          
                  self.pageIndex=@3;
                  self.paindex=3;
          
                  [self.NewsTableView.mj_footer resetNoMoreData];
          
          
                  //2.清除就数据,添加新数据
                  [self.newsArr removeAllObjects];
          
          
                  //NSLog(@"self.InfoDictionary :%@",self.InfoDictionary);
                  //取到articleList
                  NSArray *arr= self.InfoDictionary[@"content"][@"articleList"];
          
                  for (NSDictionary *obj in arr) {
                      indexArticleListModel *newSModel=[[indexArticleListModel alloc] initWithDict:obj];
                      [self.newsArr addObject:newSModel];
                      
                  }
                  [self.NewsTableView reloadData];
                  //停止刷新
                  [self.NewsTableView.mj_header endRefreshing];
                  [self.view addSubview:self.NewsTableView];
          }
      } failure:^(NSError *error) {
         
                  NSLog(@"Error: %@", error);
                  //停止刷新
                  [self.NewsTableView.mj_header endRefreshing];

      }];
}
-(void)loadMoreData{


        NSString *urlString = @"http://louyu.qianchengwl.cn/minapp/article/getArticleList";
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setValue:self.typeIDNum forKey:@"typeID"];
        NSMutableDictionary *pageDict=[[NSMutableDictionary alloc] init];
        [pageDict setValue:self.pageIndex forKey:@"index"];
        //NSLog(@"self.pageIndex%@",self.pageIndex);
        [pageDict setValue:@10 forKey:@"count"];
        [dictionary setValue:pageDict forKey:@"page"];

    
    [HttpRequest POST:urlString getToken:self.tokenStr paramentDict:dictionary success:^(id responseObj) {
        
                //请求成功返回数据；需要转化成字典（即json格式数据）
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves error:nil];
        if ([dict[@"code"] isEqualToNumber:@(-1001)]) {
            [ClearCache showHUDWithText:@"该账号已在其他设备登录，请重新登录"];
            LoginViewController *logInCV=[[LoginViewController alloc] init];
            [self presentViewController:logInCV animated:YES completion:nil];
        }
        //                NSLog(@"dict:%@",dict);
        else{

                self.InfoDictionary =[NSMutableDictionary dictionaryWithDictionary:dict];
                //NSLog(@"self.InfoDictionary :%@",self.InfoDictionary);
                //取到articleList
                self.paindex++;
                self.pageIndex=[NSNumber numberWithInteger:self.paindex];
                //NSLog(@"---self.pageIndex--%@",self.pageIndex);
                NSArray *arr= self.InfoDictionary[@"content"][@"articleList"];
        
                for (NSDictionary *obj in arr) {
                    self.pageIndex=@3;
                    indexArticleListModel *newSModel=[[indexArticleListModel alloc] initWithDict:obj];
                    [self.newsArr addObject:newSModel];
        
                }
        
                [self.NewsTableView reloadData];
                //停止刷新
                if (arr.count < 60){// 没有数据啦.不能上啦了
                    [self.NewsTableView.mj_footer endRefreshingWithNoMoreData];
                    
                }
                else{
                    // 5. 结束刷新
                    [self.NewsTableView.mj_footer endRefreshing];
                    
                }

        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
                //停止刷新
                [self.NewsTableView.mj_footer endRefreshing];

    }];

    
}




-(void)getToken{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *dic=[defaults dictionaryForKey:@"UserInfoDic"];
    //取到userInfo
    NSDictionary *userDic=dic[@"content"][@"userInfo"];
    self.tokenStr=userDic[@"token"];
    // NSLog(@"self.tokenStr%@",self.tokenStr);
    
}

/**********************上传json到服务器请求数********************************/
-(void)PostDataToSeverWithUrl:(NSString *)Url{
    

        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setValue:self.typeIDNum forKey:@"typeID"];
        NSMutableDictionary *pageDict=[[NSMutableDictionary alloc] init];
        [pageDict setValue:@2 forKey:@"index"];
         [pageDict setValue:@10 forKey:@"count"];
        [dictionary setValue:pageDict forKey:@"page"];
    [HttpRequest POST:Url getToken:self.tokenStr paramentDict:dictionary success:^(id responseObj) {
        
                //请求成功返回数据；需要转化成字典（即json格式数据）
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves error:nil];
        if ([dict[@"code"] isEqualToNumber:@(-1001)]) {
            [ClearCache showHUDWithText:@"该账号已在其他设备登录，请重新登录"];
            LoginViewController *logInCV=[[LoginViewController alloc] init];
            [self presentViewController:logInCV animated:YES completion:nil];
        }
        //                NSLog(@"dict:%@",dict);
        else{
                self.InfoDictionary =[NSMutableDictionary dictionaryWithDictionary:dict];
        
                //NSLog(@"self.InfoDictionary :%@",self.InfoDictionary);
                //取到articleList
                NSArray *arr= self.InfoDictionary[@"content"][@"articleList"];
        
                for (NSDictionary *obj in arr) {
                    indexArticleListModel *newSModel=[[indexArticleListModel alloc] initWithDict:obj];
                    [self.newsArr addObject:newSModel];
                    
                }
                [self.view addSubview:self.NewsTableView];

        
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}


-(UITableView *)NewsTableView{
    if (_NewsTableView ==nil) {
       
        _NewsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-64*Height) style:UITableViewStyleGrouped];
        _NewsTableView.showsVerticalScrollIndicator = NO;
        
        [_NewsTableView setBackgroundColor:[UIColor whiteColor]];
        _NewsTableView.dataSource = self;
        _NewsTableView.delegate = self;
        //_XiaoFangTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        
    }

    return _NewsTableView;
}

-(NSMutableArray *)newsArr{
    if (_newsArr ==nil) {
        _newsArr=[NSMutableArray array];
    }
    return _newsArr;
    
}
#pragma mark - 数据源方法
//设置组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//设置每一组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
        return self.newsArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
        
        static NSString *xinWenListID=@"xinWenListID";
        NewTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:xinWenListID];
        if (cell==nil) {
            cell=[[NewTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:xinWenListID];
        }
        //先取到对象
        indexArticleListModel *model=self.newsArr[indexPath.row];
        [cell bindDataWithModel:model];
        
        return cell;
    
    
}

//返回表头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}
//返回单元格行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
        return 104*Height;
  
}

//反选  点击的时候灰色 返回来的时候 又变回白色
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    indexArticleListModel *model=self.newsArr[indexPath.row];
    NewsDetailViewController *newsDetailCV=[[NewsDetailViewController alloc] init];
    newsDetailCV.articleID=model.articleID;
    newsDetailCV.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:newsDetailCV animated:NO];
    //newsDetailCV.hidesBottomBarWhenPushed=NO;
    
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
