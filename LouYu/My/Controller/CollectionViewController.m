//
//  CollectionViewController.m
//  LouYu
//
//  Created by barby on 2017/8/29.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "CollectionViewController.h"
#import "NewsDetailTableViewCell.h"
#import "NewTableViewCell.h"
#import "NoDataView.h"
#import "CollectionListModel.h"
#import "NewsDetailViewController.h"
@interface CollectionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *NewsTableView;
@property(nonatomic,strong)NSMutableArray *newsArr;
@property(nonatomic,strong) NoDataView *nodataView;
@property(nonatomic,strong)NSNumber *tokenStr;
//服务器返回的数据存到这个字典里
@property(nonatomic,strong)NSMutableDictionary *InfoDictionary;

@end

@implementation CollectionViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getToken];
    [self PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/user/getCollectionList"];

}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setLeftBarButtonItemWithImageName:@"btn_back_normal.80.png" andTitle:@"返回"];
//    [self.view setBackgroundColor:KRGB(211, 211, 211, 1.0)];
    [self setTitle:@"收藏"];
    // [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
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
    
    
    [HttpRequest POST:Url getToken:self.tokenStr paramentDict:nil success:^(id responseObj) {
        
        //请求成功返回数据；需要转化成字典（即json格式数据）
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves error:nil];
        
//           NSLog(@"dict:%@",dict);
        if ([dict[@"code"] isEqualToNumber:@(-1001)]) {
            [ClearCache showHUDWithText:@"该账号已在其他设备登录，请重新登录"];
            LoginViewController *logInCV=[[LoginViewController alloc] init];
            [self presentViewController:logInCV animated:YES completion:nil];
        }
        //
        else{
            
            if ([dict[@"code"] isEqualToNumber:@(-3)]) {
                
                [self.NewsTableView removeFromSuperview];
                self.nodataView =[[NoDataView alloc] init];
                
                [self.view addSubview:self.nodataView];
            }
            else{
                
                [self.nodataView removeFromSuperview];
                [self.NewsTableView removeFromSuperview];
            self.InfoDictionary =[NSMutableDictionary dictionaryWithDictionary:dict];
            
    
            NSArray *arr= self.InfoDictionary[@"content"][@"collectionList"];
            
                [self.newsArr removeAllObjects];
            for (NSDictionary *obj in arr) {
                CollectionListModel *newSModel=[[CollectionListModel alloc] initWithDict:obj];
                [self.newsArr addObject:newSModel];
                
            }
            [self.view addSubview:self.NewsTableView];
                [self.NewsTableView reloadData];
            
            }
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
    
    
    
    static NSString *collectionListID=@"collectionListID";
    NewTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:collectionListID];
//     NewTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        cell=[[NewTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:collectionListID];
    }
    
    
//    先取到对象
    CollectionListModel *model=self.newsArr[indexPath.row];
    [cell sendDataWithModel:model];
    
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
    CollectionListModel *model=self.newsArr[indexPath.row];
    NewsDetailViewController *newsDetailCV=[[NewsDetailViewController alloc] init];
    newsDetailCV.articleID=model.articleID;
    newsDetailCV.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:newsDetailCV animated:NO];
   
    
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
