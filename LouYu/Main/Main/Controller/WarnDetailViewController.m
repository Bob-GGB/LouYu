//
//  WarnDetailViewController.m
//  LouYu
//
//  Created by barby on 2017/8/21.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "WarnDetailViewController.h"
#import "DetailsTableViewCell.h"
#import "HeadTableViewCell.h"
#import "StatuDetailTableViewCell.h"
#import "DetailModel.h"
#import "CheskMsgModel.h"
#import "ButtonTableViewCell.h"
#import "SendButtonView.h"
@interface WarnDetailViewController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *detailTableView;
@property(nonatomic,strong)NSNumber *tokenStr;
//服务器返回的数据存到这个字典里
@property(nonatomic,strong)NSMutableDictionary *InfoDictionary;
@property(nonatomic,strong)NSMutableArray *detailArr;
@property(nonatomic,strong)NSMutableArray *chesklArr;
@property(nonatomic,strong)CheskMsgModel *model;
@property(nonatomic,strong)NSNumber *roleIDNum;
@end

@implementation WarnDetailViewController



//-(void)viewWillAppear:(BOOL)animated{
//    
//    [self getToken];
//    [self PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/warn/getWarnDetail"];
//    [self.detailTableView reloadData];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftBarButtonItemWithImageName:@"btn_back_normal.80.png" andTitle:@"返回"];
    [self.view setBackgroundColor:KRGB(211, 211, 211, 0.5)];
    [self getToken];
    [self PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/warn/getWarnDetail"];
    self.detailTableView.estimatedRowHeight = 0;
    self.detailTableView.estimatedSectionHeaderHeight = 0;
    self.detailTableView.estimatedSectionFooterHeight = 0;
    
}




-(void)getToken{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *dic=[defaults dictionaryForKey:@"UserInfoDic"];
    //取到userInfo
    NSDictionary *userDic=dic[@"content"][@"userInfo"];
    self.tokenStr=userDic[@"token"];
    self.roleIDNum=userDic[@"roleID"];
}

/**********************上传json到服务器请求数********************************/
-(void)PostDataToSeverWithUrl:(NSString *)Url{
    
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setValue:self.warnIDStr forKey:@"warnID"];

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

                self.InfoDictionary =[NSMutableDictionary dictionaryWithDictionary:dict[@"content"][@"warnDetail"]];
        
                //NSLog(@"详细信息：%@",dict);
                self.detailArr=[NSMutableArray array];
                [self.detailArr removeAllObjects];
                DetailModel *detailModel=[[DetailModel alloc] initWithDict:self.InfoDictionary];
                [self.detailArr addObject:detailModel];
        
                self.chesklArr=[NSMutableArray array];
                [self.chesklArr removeAllObjects];
                NSArray *cheskArray=dict[@"content"][@"warnDetail"][@"cheskMsg"];
                for (NSDictionary *obj in cheskArray) {
                    self.model=[[CheskMsgModel alloc] initWithDict:obj];
                    [self.chesklArr addObject:self.model];
                }
            [self.detailTableView removeFromSuperview];
            [self.view addSubview:self.detailTableView];
        }
    } failure:^(NSError *error) {
        
    }];
}






-(UITableView *)detailTableView{
    if (_detailTableView==nil) {
        
        _detailTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-64*Height) style:UITableViewStyleGrouped];
        //去除分割线
          _detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_detailTableView setBackgroundColor:[UIColor whiteColor]];
        [_detailTableView setDelegate:self];
        [_detailTableView setDataSource:self];
    }
    
    return _detailTableView;
}

#pragma mark - 数据源方法
//设置组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
//设置每一组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==2) {
        return self.chesklArr.count;
    }
    else
        return 1 ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section==0) {
        static NSString *HeadID11=@"HeadID11";
        HeadTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:HeadID11];
        
        if (cell==nil) {
            cell=[[HeadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HeadID11];
        }
        DetailModel *model=self.detailArr[indexPath.row];
        //NSLog(@"----%@",model.name);
        [cell bindDataWithModel:model];
        
        return cell;
    }
    else if(indexPath.section == 1)
    {
        static NSString *DetailsID22=@"DetailsID22";
        DetailsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:DetailsID22];
        // cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell==nil) {
            cell=[[DetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DetailsID22];
            
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        DetailModel *model=self.detailArr[indexPath.row];
        [cell bindDataWithModel:model];
        return cell;
        
    }
    else if(indexPath.section == 2)
    {
        static NSString *StatuDetailID33=@"StatuDetailID33";
        StatuDetailTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:StatuDetailID33];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setAccessoryType:UITableViewCellAccessoryNone];

        if (cell==nil) {
            cell=[[StatuDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:StatuDetailID33];
            
        }
        [cell setBackgroundColor:KRGB(240, 240, 240, 1.0)];
        CheskMsgModel *model=self.chesklArr[indexPath.row];
        [cell bindDataWithModel:model];
        
        return cell;
        
    }
    
    else
        return nil;
    
}

#pragma mark - 代理方法


//返回单元格行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 70*Height;
    }
    else if (indexPath.section == 1)
    {
        return 300*Height;
    }
    else
        return 90*Height;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    [tableView.tableFooterView setBackgroundColor:[UIColor whiteColor]];

    if (section==2) {
//        NSLog(@"self.RoleID:%@",self.roleIDNum);
        ButtonTableViewCell *buttonView=[[ButtonTableViewCell alloc]initWithWarnID:self.warnIDStr RoleId:self.roleIDNum];
        [buttonView setFrame:CGRectMake(0,0, KscreenWidth, 100)];
        buttonView.noteStr=_model.note;
        __weak typeof(self)weakSelf = self;
        [buttonView setSendController:^(UIViewController *controller) {
            [weakSelf.navigationController pushViewController:controller animated:NO];
        }];
        
        SendButtonView *sendView=[[SendButtonView alloc] initWithWarnID:self.warnIDStr RoleId:self.roleIDNum];
        [sendView setFrame:CGRectMake(0, 20, KscreenWidth, 60)];
      
        [sendView setSendController:^(UIViewController *controller) {
            [weakSelf.navigationController pushViewController:controller animated:NO];
        }];

        
        if ([self.roleIDNum isEqualToNumber:@2]) {
            
               return buttonView;
                
            }
        else
            return nil;
   
    }
     return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==2) {
        
        if ([self.roleIDNum isEqualToNumber:@2]) {
                            return 100*Height;
            
        }
        else if ([self.roleIDNum isEqualToNumber:@3]){
            
        
                
                return 100;
                
            }
        
        else if ([self.roleIDNum isEqualToNumber:@1]){
            
            
                
                return 60;
                
               }
    
    else return 0.1f;
    }
    return 0.1f;
}

//反选  点击的时候灰色 返回来的时候 又变回白色
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)leftBarButtonDidPress:(UIButton *)sender{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
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
