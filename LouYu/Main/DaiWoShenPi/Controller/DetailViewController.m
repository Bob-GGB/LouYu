//
//  DetailViewController.m
//  LouYu
//
//  Created by barby on 2017/7/24.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailsTableViewCell.h"
#import "HeadTableViewCell.h"
#import "StatuDetailTableViewCell.h"
#import "DetailModel.h"
#import "CheskMsgModel.h"
#import "ButtonTableViewCell.h"
#import "SendButtonView.h"

@interface DetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *detailTableView;
@property(nonatomic,strong)NSNumber *tokenStr;
//服务器返回的数据存到这个字典里
@property(nonatomic,strong)NSMutableDictionary *InfoDictionary;
@property(nonatomic,strong)NSMutableArray *detailArr;
@property(nonatomic,strong)NSMutableArray *chesklArr;
@property(nonatomic,strong)CheskMsgModel *model;
//@property(nonatomic,strong)NSNumber *roleIDNum;
@end

@implementation DetailViewController





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
    self.RoleID=userDic[@"roleID"];
    
}

/**********************上传json到服务器请求数********************************/
-(void)PostDataToSeverWithUrl:(NSString *)Url{
    
    
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
//        NSLog(@"self.warnIDStr:%@",self.warnIDStr);
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
        
                [self.detailArr removeAllObjects];
                    DetailModel *detailModel=[[DetailModel alloc] initWithDict:self.InfoDictionary];
                    [self.detailArr addObject:detailModel];
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
        NSLog(@"%@",error);
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

-(NSMutableArray *)chesklArr{
    if (_chesklArr==nil) {
        _chesklArr=[NSMutableArray array];
    }
    return _chesklArr;
}


-(NSMutableArray *)detailArr{
    if (_detailArr==nil) {
        _detailArr=[NSMutableArray array];
    }
    return _detailArr;

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
        static NSString *ID11=@"ID11";
        HeadTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:ID11];
      
        if (cell==nil) {
            cell=[[HeadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID11];
        }
        DetailModel *model=self.detailArr[indexPath.row];
        //NSLog(@"----%@",model.name);
        [cell bindDataWithModel:model];
        
        return cell;
    }
    else if(indexPath.section == 1)
    {
        static NSString *ID22=@"ID22";
        DetailsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID22];
       // cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell==nil) {
            cell=[[DetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID22];
            
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        DetailModel *model=self.detailArr[indexPath.row];
        [cell bindDataWithModel:model];
        return cell;
        
    }
    else if(indexPath.section == 2)
    {
        static NSString *ID33=@"ID33";
        StatuDetailTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID33];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        
    
        if (cell==nil) {
            cell=[[StatuDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID33];
            
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
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
        ButtonTableViewCell *buttonView=[[ButtonTableViewCell alloc]initWithWarnID:self.warnIDStr RoleId:self.RoleID];
        [buttonView setFrame:CGRectMake(0,0, KscreenWidth, 100*Height)];
        buttonView.noteStr=_model.note;
        __weak typeof(self)weakSelf = self;
        [buttonView setSendController:^(UIViewController *controller) {
            [weakSelf.navigationController pushViewController:controller animated:NO];
        }];
        SendButtonView *sendView=[[SendButtonView alloc]initWithWarnID:self.warnIDStr RoleId:self.RoleID];
        [sendView setFrame:CGRectMake(0, 20*Height, KscreenWidth, 60*Height)];
        [sendView setSendController:^(UIViewController *controller) {
            [weakSelf.navigationController pushViewController:controller animated:NO];
        }];
        if ([self.RoleID isEqualToNumber:@2]) {//负责人
            if (self.selectIndex==0||self.selectIndex==2) {
                [buttonView removeFromSuperview];
            }
            else if (self.selectIndex==3){
                return sendView;
            }
            else
                
                
                return buttonView;
            
        }
        else if ([self.RoleID isEqualToNumber:@3]){//总负责人
            if (self.selectIndex==0||self.selectIndex==2) {
                [buttonView removeFromSuperview];
            }
            else
                return buttonView;
        }
        
        else if ([self.RoleID isEqualToNumber:@1]){//巡检人
            if (self.selectIndex==0) {
                return sendView;
            }
            else{
                [sendView removeFromSuperview];
                return nil;
            }
                    }
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==2) {
        
    if ([self.RoleID isEqualToNumber:@2]) {
        if (self.selectIndex==0||self.selectIndex==2) {
            
            return 0.1f;
            
        }
       else
            return 100*Height;
        
    }
    else if ([self.RoleID isEqualToNumber:@3]){
        
        if (self.selectIndex==1) {
            
            return 100;
            
        }
        else
            return 0.1f;
    }
        
    else if ([self.RoleID isEqualToNumber:@1]){
       
        if (self.selectIndex==0) {
            
            return 60;
            
        }
        else
            return 0.1f;
    }

    else return 0.1f;
    }
    
else return 0.1f;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
