//
//  EventDetailViewController.m
//  LouYu
//
//  Created by barby on 2017/8/23.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "EventDetailViewController.h"

#import "DetailsTableViewCell.h"
#import "HeadTableViewCell.h"
#import "StatuDetailTableViewCell.h"
#import "InfoDetailTableViewCell.h"
#import "WorkDetailModel.h"
#import "UserMsgModel.h"
#import "PeopleTableViewCell.h"
#import "SendButtonView.h"
@interface EventDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *detailTableView;
@property(nonatomic,strong)NSNumber *tokenStr;
//服务器返回的数据存到这个字典里
@property(nonatomic,strong)NSMutableDictionary *InfoDictionary;
@property(nonatomic,strong)NSMutableArray *detailArr;
@property(nonatomic,strong)NSMutableArray *chesklArr;
@property(nonatomic,strong)PeopleTableViewCell *sendCell;

@end

@implementation EventDetailViewController

-(void)viewWillAppear:(BOOL)animated{

  
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
     self.userID= [defaults valueForKey:@"MuserID"];
    [self getToken];
    
   if ([self.roleID isEqualToNumber:@2]&&[self.statusNum isEqualToNumber:@1]) {
    [self.sendCell.addPersonImageView sd_setImageWithURL:[NSURL URLWithString:[defaults valueForKey:@"MheadImgUrl"]] placeholderImage:[UIImage imageNamed:@"btn_default.png"]];
    self.sendCell.addNameLabel.text=[defaults valueForKey:@"MUserName"];
   }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setUserInteractionEnabled:YES];
    [self setLeftBarButtonItemWithImageName:@"btn_back_normal.80.png" andTitle:@"返回"];
    [self.view setBackgroundColor:KRGB(211, 211, 211, 0.5)];
    [self getToken];
    [self PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/work/getWorkDetail"];
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
    self.roleID=userDic[@"roleID"];
    
}

/**********************上传json到服务器请求数********************************/
-(void)PostDataToSeverWithUrl:(NSString *)Url{
    
//    NSLog(@"self.workIDnum:%@",self.workIDnum);
//
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setValue:self.workIDnum forKey:@"workID"];

    [HttpRequest POST:Url getToken:self.tokenStr paramentDict:dictionary success:^(id responseObj) {
        
                //请求成功返回数据；需要转化成字典（即json格式数据）
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves error:nil];
        
                if ([dict[@"code"] isEqualToNumber:@(-1001)]) {
                    [SVProgressHUD showInfoWithStatus:@"该账号已在其他设备登录，请重新登录"];
                    [SVProgressHUD dismissWithDelay:1.0];
                    LoginViewController *logInCV=[[LoginViewController alloc] init];
                    [self presentViewController:logInCV animated:YES completion:nil];
                }
                else{
                self.InfoDictionary =[NSMutableDictionary dictionaryWithDictionary:dict[@"content"][@"workDetail"]];
        
                //NSLog(@"详细信息：%@",dict);
                self.detailArr=[NSMutableArray array];
                [self.detailArr removeAllObjects];
                WorkDetailModel *detailModel=[[WorkDetailModel alloc] initWithDict:self.InfoDictionary];
                [self.detailArr addObject:detailModel];
        
                self.chesklArr=[NSMutableArray array];
                [self.chesklArr removeAllObjects];
                NSArray *cheskArray=dict[@"content"][@"workDetail"][@"userMsg"];
                for (NSDictionary *obj in cheskArray) {
                    UserMsgModel *model=[[UserMsgModel alloc] initWithDict:obj];
                    [self.chesklArr addObject:model];
        
                    
                }
                    [self.detailTableView removeFromSuperview];
                    [self.view addSubview:self.detailTableView];
                }
                
        
        
    } failure:^(NSError *error) {
        
    }];
}







-(UITableView *)detailTableView{
    if (_detailTableView==nil) {
        
        _detailTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-64*Height) style:UITableViewStylePlain];
        _detailTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        //去除分割线
        _detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //_detailTableView.separatorStyle = UITableViewStyleGrouped;
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
    
    if ([self.roleID isEqualToNumber:@2]&&[self.statusNum isEqualToNumber:@1]) {
        return 5;
    }
    else
    return 4;
}
//设置每一组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==3) {
        return self.chesklArr.count;
    }
    else
        return 1 ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section==0) {
        static NSString *IDheadCell=@"IDheadCell";
        HeadTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:IDheadCell];
        
        if (cell==nil) {
            cell=[[HeadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IDheadCell];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.statusLable setTextColor:[UIColor blackColor]];
        WorkDetailModel *model=self.detailArr[indexPath.row];
        //NSLog(@"----%@",model.name);
        [cell sendDataWithModel:model];
        
        return cell;
    }
    else if(indexPath.section == 1)
    {
        static NSString *InfoDetailID=@"InfoDetailID";
        InfoDetailTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:InfoDetailID];
        // cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell==nil) {
            cell=[[InfoDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:InfoDetailID];
            
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        WorkDetailModel *model=self.detailArr[indexPath.row];
        [cell bindDataWithModel:model];
        return cell;
        
    }
    else if(indexPath.section == 2)
    {
        static NSString *SendPersonID=@"SendPersonID";
        self.sendCell=[tableView dequeueReusableCellWithIdentifier:SendPersonID];
        // cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.sendCell==nil) {
            self.sendCell=[[PeopleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SendPersonID];
            
        }
        else{
            while ([self.sendCell.contentView.subviews lastObject] != nil) {
                [(UIView *)[self.sendCell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        [self.sendCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        
        __weak typeof(self)weakSelf = self;
        
        if ([self.roleID isEqualToNumber:@2]&&[self.statusNum isEqualToNumber:@1]) {
            
            [self.sendCell setSendController:^(UIViewController *controller) {
                
                controller.hidesBottomBarWhenPushed=YES;
                [weakSelf.navigationController pushViewController:controller animated:NO];
                
                
            }];
 
        }
        
        //        WorkDetailModel *model=self.detailArr[indexPath.row];
        //        [cell bindDataWithModel:model];
        return self.sendCell;
        
    }
    
    else if(indexPath.section == 3)
    {
        static NSString *StatuDetailID3333=@"StatuDetailID3333";
        StatuDetailTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:StatuDetailID3333];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        if (cell==nil) {
            cell=[[StatuDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:StatuDetailID3333];
        }
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setBackgroundColor:KRGB(240, 240, 240, 0.5)];
        UserMsgModel *model=self.chesklArr[indexPath.row];
        [cell senderDataWithModel:model];
        
        if (indexPath.row==1) {

            [self.sendCell.PersonImageView sd_setImageWithURL:[NSURL URLWithString:model.headImgUrl]];
            self.sendCell.nameLabel.text =model.userName;
            
        }
        
        if ([self.statusNum isEqualToNumber:@2]) {
        if (indexPath.row==2) {
            
            [self.sendCell.addPersonImageView sd_setImageWithURL:[NSURL URLWithString:model.headImgUrl]];
            self.sendCell.addNameLabel.text=model.userName;
        }
        }
        
        return cell;
        
    }
    
    else if(indexPath.section == 4)
    {
        static NSString *ButtonIDs=@"ButtonIDs";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ButtonIDs];
        // cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell==nil) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ButtonIDs];
            
        }
        else{
            while ([cell.contentView.subviews lastObject] != nil) {
                [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
            UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 100*Height)];
            [view setBackgroundColor:[UIColor whiteColor]];
            [cell addSubview:view];
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(KscreenWidth/2-100*Width,view.frame.size.height/2-15, 200*Width, 30*Height)];
            [button.layer setCornerRadius:10];
            [button.layer setMasksToBounds:YES];
            [button setBackgroundImage:[UIImage imageNamed:@"矩形-5"] forState:UIControlStateNormal];
            [button setTitle:@"发送" forState:UIControlStateNormal];
            [button.titleLabel setTextColor:[UIColor whiteColor]];
            [button addTarget:self action:@selector(sendButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:button];
    
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
        return 170*Height;
    }
    else if (indexPath.section == 2)
    {
        return 115*Height;
    }
    else if (indexPath.section == 3)
    {
        return 85*Height;
    }
    else if (indexPath.section == 4)
    {
        return 100*Height;
    }
    
    else{
        return 0;
    }
}






-(void)sendButtonDidPress:(UIButton *)sender{


   [self PostPersonToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/work/inform"];
    

}





/**********************上传json到服务器请求数********************************/
-(void)PostPersonToSeverWithUrl:(NSString *)Url{
    

        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setValue:self.workIDnum forKey:@"workID"];
        [dictionary setValue:self.userID forKey:@"userID"];
    if (dictionary[@"userID"]==NULL) {
        [ClearCache showHUDWithText:@"请选择要发送的人"];
    }else{
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
                if ([dict[@"code"] isEqualToNumber:@1]) {
                    [self.navigationController popViewControllerAnimated:NO];
                    [ClearCache showHUDWithText:@"发送成功"];
                   
                }
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
        
    }
    
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
