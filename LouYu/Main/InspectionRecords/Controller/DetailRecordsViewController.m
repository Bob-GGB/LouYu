//
//  DetailRecordsViewController.m
//  LouYu
//
//  Created by barby on 2017/8/8.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "DetailRecordsViewController.h"
#import "DetailHeadView.h"
#import "DetailRecordsTableViewCell.h"
#import "OnePartrolListeModel.h"
#import "HeadContentModel.h"
#import "DDetailRecordsViewController.h"
@interface DetailRecordsViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>;

@property(nonatomic,strong)DetailHeadView *headView;
@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)NSNumber *tokenStr;



//服务器返回的数据存到这个字典里
@property(nonatomic,strong)NSMutableDictionary *InfoDictionary;

//信息数组
@property(nonatomic,strong)NSMutableArray *dataArr;

@property(nonatomic,strong)HeadContentModel *headModel;


@end

@implementation DetailRecordsViewController


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationController.delegate = self;
    UIImageView *navigationImageView=[[UIImageView alloc] init];
    [navigationImageView setFrame:CGRectMake(0, 0, KscreenWidth, 64)];
    [navigationImageView setImage:[UIImage imageNamed:@"1.pic_hd"]];
    [self.view addSubview:navigationImageView];
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(KscreenWidth/2-50, 28, 100, 16)];
    titleLabel.text=@"巡查详情";
    [titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [navigationImageView addSubview:titleLabel];
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 20, 80, 40)];
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [backButton setImage:[UIImage imageNamed:@"btn_back_normal.80.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonDidPress) forControlEvents:UIControlEventTouchUpInside];
    [navigationImageView addSubview:backButton];
    [navigationImageView setUserInteractionEnabled:YES];
    
    


    [self getToken];
    
    [self PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/patrol/getOnePatrolList"];
    
    
    

    
}

#pragma mark ========== 导航栏返回按钮点击事件==========
-(void)backButtonDidPress{
   
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)creatHeadView{

    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 64, KscreenWidth, 100)];
    [imageView setImage:[UIImage imageNamed:@"矩形-5"]];
    self.headView=[[DetailHeadView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 100)];
    
    // NSLog(@"____self.headModel.actualNumber:%@",self.headModel.actualNumber);
    self.headView.yiCountLabel.text=[NSString stringWithFormat:@"%@",self.headModel.actualNumber];
    self.headView.yingCountLabel.text=[NSString stringWithFormat:@"%@",self.headModel.totalNumber];
    self.headView.UpdateLabel.text=[NSString stringWithFormat:@"更新于：%@",self.headModel.updateTime];
    [imageView addSubview:self.headView];
    [self.view addSubview:imageView];
   

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
    [dictionary setValue:self.typeIdNum forKey:@"typeID"];
    [dictionary setValue:self.patrolIconStr forKey:@"patrolIcon"];
    [dictionary setValue:self.groupIDNum forKey:@"groupID"];
    [HttpRequest POST:Url getToken:self.tokenStr paramentDict:dictionary success:^(id responseObj) {
        
                //请求成功返回数据；需要转化成字典（即json格式数据）
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dict[@"code"] isEqualToNumber:@(-1001)]) {
            [ClearCache showHUDWithText:@"该账号已在其他设备登录，请重新登录"];
            LoginViewController *logInCV=[[LoginViewController alloc] init];
            [self presentViewController:logInCV animated:YES completion:nil];
            
        }
        else{
               self.InfoDictionary =[NSMutableDictionary dictionaryWithDictionary:dict];
                self.headModel =[[HeadContentModel alloc] initWithDict:self.InfoDictionary[@"content"]];
                //NSLog(@"%@",self.InfoDictionary[@"content"][@"onePatrolList"]);
                    NSArray *arr= self.InfoDictionary[@"content"][@"onePatrolList"];
                    [self.dataArr removeAllObjects];
                    for (NSDictionary *obj in arr) {
                        OnePartrolListeModel *model=[[OnePartrolListeModel alloc] initWithDict:obj];
                        [self.dataArr addObject:model];
                       // NSLog(@"model.status:%@",model.status);
                    }
                    [self.mainTableView removeFromSuperview];
                    [self.headView removeFromSuperview];
                    [self creatHeadView];
                    [self creatTableView];
        
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}













-(void)creatTableView{
    
    self.mainTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 164, KscreenWidth, KscreenHeight-64-100) style:UITableViewStylePlain];
    //去除分割线
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mainTableView setBackgroundColor:[UIColor whiteColor]];
    [self.mainTableView setShowsVerticalScrollIndicator:NO];
    [self.mainTableView setDelegate:self];
    [self.mainTableView setDataSource:self];
    [self.view addSubview:self.mainTableView];
    //[self.mainTableView setScrollEnabled:NO];
    
    
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
    
    static NSString *DetailRecordsID1=@"DetailRecordsID1";
   // DetailRecordsTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:DetailRecordsID1];
    
    DetailRecordsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];//根据indexPath准确地取出一行，而不是从cell重用队列中取出
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell==nil) {
        cell=[[DetailRecordsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DetailRecordsID1];
        
    }
    
      [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
       cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    OnePartrolListeModel *model=self.dataArr[indexPath.row];
    
    cell.titleLabel.text=model.placeName;
    cell.stauteLabel.text=model.statusText;
    NSString *date=[model.addtime substringToIndex:10];
    
    NSString *timestr=[[model.addtime substringFromIndex:11] substringToIndex:5];
    
    cell.addtimeTwoLabel.text=date;
    cell.addtimeLabel.text=timestr;
    if (model.userName!=NULL) {
         cell.nameLabel.text=[NSString stringWithFormat:@"巡检人：%@",model.userName];
    }
    
    
    
    if (indexPath.row==self.dataArr.count-1) {
        [cell.verticalLabelBlow removeFromSuperview];
        
    }
    if (indexPath.row==0) {
        [cell.verticalLabel removeFromSuperview];
    }
    
//    if ([model.status isEqualToNumber:@]) {
//        cell.stauteLabel.textColor=KRGB(252, 58, 81, 1.0);
//    }
    if ([model.status isEqualToNumber:@1]) {
        [cell.stauteLabel setTextColor:KRGB(104, 173, 255, 1.0)];
    }
       NSString *str = @"异常";
    if ([model.status isEqualToNumber:@1]&& [model.statusText rangeOfString:str].location != NSNotFound) {
         cell.stauteLabel.textColor=KRGB(252, 58, 81, 1.0);
    }
    
    
    
    
    
    
    return cell;
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    
//    return imageView;
//    
//    
//}
-(NSMutableArray *)dataArr{
    
    if (_dataArr==nil) {
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}



//返回单元格行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 61*Height;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
        return 0.1f;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //TimeSelectTableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OnePartrolListeModel *model=self.dataArr[indexPath.row];
    
    DDetailRecordsViewController *DDCV=[[DDetailRecordsViewController alloc] init];
    DDCV.partolIDNum=model.patrolID;
    if ([model.status isEqualToNumber:@1]||[model.status isEqualToNumber:@2]||[model.status isEqualToNumber:@3]) {
        [DDCV setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:DDCV animated:NO];
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
