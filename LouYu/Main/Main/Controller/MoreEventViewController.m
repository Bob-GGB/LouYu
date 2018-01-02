//
//  MoreEventViewController.m
//  LouYu
//
//  Created by mc on 2017/9/23.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "MoreEventViewController.h"
#import "ZFJSegmentedControl.h"
#import "DaiwoShenPiTableViewCell.h"
#import "WorkListModel.h"
#import "DetailViewController.h"
#import "EventsDetailViewController.h"

@interface MoreEventViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)ZFJSegmentedControl *zvc;

@property(nonatomic,strong)UIScrollView *mainScrollView;
@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)NSNumber *tokenStr;
//服务器返回的数据存到这个字典里
@property(nonatomic,strong)NSMutableDictionary *InfoDictionary;
@property(nonatomic,strong)NSMutableArray *dataArr;

@property(nonatomic,strong)NoDataView *nodataView;
@end

@implementation MoreEventViewController

//-(void)viewWillAppear:(BOOL)animated{
//    [self getToken];
//    [self PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/work/getUndealTemporaryWorkList"];
//    [self.mainTableView reloadData];
//
//}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setLeftBarButtonItemWithImageName:@"btn_back_normal.80.png" andTitle:@"返回"];
    [self.view setBackgroundColor:KRGB(240, 240, 240, 1.0)];
    // [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self setHeadButtonView];
    [self getToken];
    [self PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/work/getUndealTemporaryWorkList"];
}


-(void)setHeadButtonView{
    
    NSArray *titleArr = @[@"未处理",@"已处理"];
    self.zvc = [[ZFJSegmentedControl alloc]initwithTitleArr:titleArr iconArr:nil SCType:SCType_Underline];
    self.zvc.frame = CGRectMake(0, 35,200, 40);
    self.zvc.selectBtnSpace = 10;//设置按钮间的间距
    //self.zvc.selectBtnWID =50;//设置按钮的宽度 不设就是均分
    self.zvc.SCType_Underline_HEI = 2;//设置底部横线的高度
    self.zvc.backgroundColor=[UIColor clearColor];
    self.zvc.selectTitleColor =[UIColor whiteColor];
    self.zvc.titleFont = [UIFont systemFontOfSize:15.0f];
    self.zvc.titleColor=[UIColor whiteColor];
    __weak typeof(self)weakSelf=self;
    self.zvc.selectType = ^(NSInteger selectIndex,NSString *selectIndexTitle){
        //NSLog(@"之前selectIndex:%ld",selectIndex);
        //[weakSelf.mainTableView removeFromSuperview];
        if (selectIndex==0) {
            

            [weakSelf PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/work/getUndealTemporaryWorkList"];
        }
        if (selectIndex==1) {
          
            [weakSelf PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/work/getTemporaryWorkList"];
        }
        
    };
    self.navigationItem.titleView=self.zvc;
    
    
    
    
}




-(void)getToken{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *dic=[defaults dictionaryForKey:@"UserInfoDic"];
    //取到userInfo
    NSDictionary *userDic=dic[@"content"][@"userInfo"];
    self.tokenStr=userDic[@"token"];
    
}

/**********************上传json到服务器请求数********************************/
-(void)PostDataToSeverWithUrl:(NSString *)Url{
    [self.nodataView removeFromSuperview];
    [self.mainTableView removeFromSuperview];
    [HttpRequest POST:Url getToken:self.tokenStr paramentDict:nil success:^(id responseObj) {
        
                //请求成功返回数据；需要转化成字典（即json格式数据）
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves error:nil];
        
                //        NSLog(@"%@",dict);
                self.InfoDictionary =[NSMutableDictionary dictionaryWithDictionary:dict];
                if ([dict[@"code"] isEqualToNumber:@(-3)]) {
        
                    [self.mainTableView removeFromSuperview];
                    self.nodataView =[[NoDataView alloc] init];
        
                    [self.view addSubview:self.nodataView];
                }
                else{
        
                    [self.nodataView removeFromSuperview];
                    [self.mainTableView removeFromSuperview];
                    //取到warnList
                    NSArray *arr= self.InfoDictionary[@"content"][@"workList"];
                    [self.dataArr removeAllObjects];
                    for (NSDictionary *obj in arr) {
                        WorkListModel *Model=[[WorkListModel alloc] initWithDict:obj];
                        [self.dataArr addObject:Model];
                        //  NSLog(@"%@",Model.statusText);
                    }
                    [self.view addSubview:self.mainTableView];
                    [self.mainTableView reloadData];
        
                }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}













-(UITableView *)mainTableView{
    
    if (_mainTableView==nil) {
        _mainTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-64*Height) style:UITableViewStylePlain];
        //去除分割线
        _mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.showsVerticalScrollIndicator=NO;
        [_mainTableView setBackgroundColor:KRGB(220, 220, 220, 0.5)];
        [_mainTableView setDelegate:self];
        [_mainTableView setDataSource:self];
        
    }
    return _mainTableView;
}


-(NSMutableArray *)dataArr{
    if (_dataArr==nil) {
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}


//设置组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//设置每一组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ShenPiIDss=@"ShenPiIDss";
    DaiwoShenPiTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:ShenPiIDss];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell==nil) {
        cell=[[DaiwoShenPiTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ShenPiIDss];
        
    }
    
    // [cell setBackgroundColor:[UIColor greenColor]];
    WorkListModel *model=self.dataArr[indexPath.row];
    [cell senderDataWithModel:model];
    
    
    return cell;
}
//返回单元格行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120*Height;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EventsDetailViewController *controller=[[EventsDetailViewController alloc] init];
    WorkListModel *model=self.dataArr[indexPath.row];
    controller.workIDnum=model.workID;
    //controller.RoleID=self.roleIDNum;
    //    NSLog(@"---selectIndex:%ld",controller.selectIndex);
    [self.navigationController pushViewController:controller animated:NO];
    
    
    
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
