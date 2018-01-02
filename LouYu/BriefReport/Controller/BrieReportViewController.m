//
//  BrieReportViewController.m
//  LouYu
//
//  Created by barby on 2017/7/14.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BrieReportViewController.h"
#import "BriePeportTableViewCell.h"
#import "ValuePickerView.h"
#import "ReportListModel.h"
#import "NoDataView.h"
#import "BrieReportDetailViewController.h"
@interface BrieReportViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *listTableView;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)NSNumber *tokenStr;
@property(nonatomic,strong)UILabel *showLable;
@property(nonatomic,strong)UIButton *selectButton;
@property (nonatomic, strong) ValuePickerView *pickerView;
@property(nonatomic,strong)NoDataView *nodataView;
@property(nonatomic,strong)NSNumber *tyId;
@property(nonatomic,strong)NSNumber *roleID;

//服务器返回的数据存到这个字典里
@property(nonatomic,strong)NSMutableDictionary *InfoDictionary;
@end

@implementation BrieReportViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self getToken];
    [self PostDataToSeverWithTypeId:_tyId];
}

- (void)viewDidLoad {
    [super viewDidLoad];
     [self.navigationItem setTitle:@"简报通知"];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:15],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.pickerView = [[ValuePickerView alloc]init];
    [self.view addSubview:[self setUpAllView]];
    [self getToken];
     _tyId=@1;
    [self PostDataToSeverWithTypeId:_tyId];
    
    self.listTableView.estimatedRowHeight = 0;
    self.listTableView.estimatedSectionHeaderHeight = 0;
    self.listTableView.estimatedSectionFooterHeight = 0;
    }



-(UIView *)setUpAllView{
    UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 35*Height)];
    [backView setBackgroundColor:[UIColor whiteColor]];

    self.showLable =[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100*Width, 35*Height)];
    [self.showLable setFont:[UIFont systemFontOfSize:16.0]];
    [self.showLable setTextColor:KRGB(96, 151, 232, 1.0)];
    //[self.showLable setBackgroundColor:[UIColor redColor]];
    [self.showLable setText:@"日报"];
    [backView addSubview:self.showLable];
    
    self.selectButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectButton setFrame:CGRectMake(KscreenWidth-75*Width, 5, 75*Width, 30*Height)];
    [self.selectButton setTitleColor:KRGB(134, 136, 148, 1.0) forState:UIControlStateNormal];
    [self.selectButton setTitle:@"筛选" forState:UIControlStateNormal];
    //[self.selectButton setBackgroundColor:[UIColor greenColor]];
    [self.selectButton.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [self.selectButton addTarget:self action:@selector(selectButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    //[self.selectButton setImage:[UIImage imageNamed:@"btn_normal.60.png"] forState:UIControlStateNormal];
    //    [self.selectButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 50)];
    //    [self.selectButton setImageEdgeInsets:UIEdgeInsetsMake(0, 50, 0, 0)];
    [backView addSubview:self.selectButton];
    
    
    
    return backView;
    
}

-(void)selectButtonDidPress:(UIButton *)sender{
    
    //NSLog(@"我是筛选按钮");
    [sender addTarget:self action:@selector(percentvaluechanggeEvent) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)percentvaluechanggeEvent {
    
    self.pickerView.dataSource = @[@"日报", @"周报", @"月报", @"季报"];
    self.pickerView.pickerTitle = @"请选择";
    
    __weak typeof(self) weakSelf = self;
    
    self.pickerView.valueDidSelect = ^(NSString *value){
        NSArray * stateArr = [value componentsSeparatedByString:@"/"];
        weakSelf.showLable.text= stateArr[0];
        //NSLog(@"weakSelf.showLable.text:%@",weakSelf.showLable.text);
       
        if ([weakSelf.showLable.text isEqualToString:@"日报"]) {
            weakSelf.tyId=@1;
            [weakSelf.listTableView removeFromSuperview];
            [weakSelf PostDataToSeverWithTypeId:weakSelf.tyId];
        }
        if ([weakSelf.showLable.text isEqualToString:@"周报"]) {
            weakSelf.tyId=@2;
            [weakSelf.listTableView removeFromSuperview];
            [weakSelf PostDataToSeverWithTypeId:weakSelf.tyId];
        }
        if ([weakSelf.showLable.text isEqualToString:@"月报"]) {
            weakSelf.tyId=@3;
            [weakSelf.listTableView removeFromSuperview];
            [weakSelf PostDataToSeverWithTypeId:weakSelf.tyId];
        }
        if ([weakSelf.showLable.text isEqualToString:@"季报"]) {
            weakSelf.tyId=@4;
            [weakSelf.listTableView removeFromSuperview];
            [weakSelf PostDataToSeverWithTypeId:weakSelf.tyId];
        }
        
        
        
    };
    //默认选择状态
    self.pickerView.defaultStr =[NSString stringWithFormat:@"%@/%ld",self.showLable.text,(long)[self.tyId integerValue]];
   // NSLog(@"-%@,-%@",self.showLable.text,self.tyId);
    [self.pickerView show];
    
}

-(void)getToken{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *dic=[defaults dictionaryForKey:@"UserInfoDic"];
    //取到userInfo
    NSDictionary *userDic=dic[@"content"][@"userInfo"];
    self.tokenStr=userDic[@"token"];
    self.roleID=userDic[@"roleID"];
}

/**********************上传json到服务器请求数********************************/
-(void)PostDataToSeverWithTypeId:(NSNumber *)typeId{
    
   
    
        NSString *urlString = @"http://louyu.qianchengwl.cn/minapp/report/getReportList";

    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:typeId forKey:@"typeID"];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    if ([self.roleID isEqualToNumber:@3] &&[defaults valueForKey:@"KcompanyID"]!=NULL) {
        [dictionary setObject:[defaults valueForKey:@"KcompanyID"] forKey:@"companyID"];
    }
    
    [HttpRequest POST:urlString getToken:self.tokenStr paramentDict:dictionary success:^(id responseObj) {
        
        //请求成功返回数据；需要转化成字典（即json格式数据）
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves error:nil];
//         NSLog(@"dict:%@",dict);
        if ([dict[@"code"] isEqualToNumber:@(-1001)]) {
            [ClearCache showHUDWithText:@"该账号已在其他设备登录，请重新登录"];
            LoginViewController *logInCV=[[LoginViewController alloc] init];
            [self presentViewController:logInCV animated:YES completion:nil];
        }
        
        else{
         
            if ([dict[@"code"] isEqualToNumber:@(-3)]) {
                
                [self.listTableView removeFromSuperview];
                self.nodataView =[[NoDataView alloc] init];
                
                [self.view addSubview:self.nodataView];
            }
            else{
                [self.nodataView removeFromSuperview];
                [self.listTableView removeFromSuperview];
                
        self.InfoDictionary =[NSMutableDictionary dictionaryWithDictionary:dict];
        //NSLog(@"self.InfoDictionary :%@",self.InfoDictionary );
        //取到articleList
        NSArray *arr= self.InfoDictionary[@"content"][@"reportList"];
        //2.清除就数据,添加新数据
        [self.dataArr removeAllObjects];
        for (NSDictionary *obj in arr) {
            ReportListModel *model=[[ReportListModel alloc] initWithDict:obj];
            [self.dataArr addObject:model];
            //NSLog(@"model.detail:%@",model.detail);
            
        }
        [self.listTableView reloadData];
        [self.view addSubview:self.listTableView];
                
            }
         
         }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}








-(UITableView *)listTableView{
    if (_listTableView ==nil) {
        
        _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,35*Height, KscreenWidth, KscreenHeight-64*Height) style:UITableViewStyleGrouped];
        _listTableView.showsVerticalScrollIndicator = NO;
        
        [_listTableView setBackgroundColor:KRGB(245, 245, 245, 1.0)];
        _listTableView.dataSource = self;
        _listTableView.delegate = self;
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
    }
    
    return _listTableView;
}


-(NSMutableArray *)dataArr{
    if (_dataArr ==nil) {
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
    
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
    
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    static NSString *BrieListID=@"BrieListID";
    BriePeportTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:BrieListID];
    if (cell==nil) {
        cell=[[BriePeportTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BrieListID];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:KRGB(250, 250, 250, 1.0)];
    ReportListModel *model=self.dataArr[indexPath.row];
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
    
    return 170*Height;
    
}
//反选  点击的时候灰色 返回来的时候 又变回白色
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ReportListModel *model=self.dataArr[indexPath.row];
    BrieReportDetailViewController *DetailCV=[[BrieReportDetailViewController alloc] init];
    DetailCV.ReportID=model.reportID;
    DetailCV.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:DetailCV animated:NO];
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
