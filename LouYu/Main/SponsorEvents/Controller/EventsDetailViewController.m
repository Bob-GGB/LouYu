//
//  EventsDetailViewController.m
//  LouYu
//
//  Created by barby on 2017/8/15.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "EventsDetailViewController.h"
#import "DetailsTableViewCell.h"
#import "HeadTableViewCell.h"
#import "StatuDetailTableViewCell.h"
#import "InfoDetailTableViewCell.h"
#import "WorkDetailModel.h"
#import "UserMsgModel.h"
#import "SendPersonTableViewCell.h"
@interface EventsDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *detailTableView;
@property(nonatomic,strong)NSNumber *tokenStr;
//服务器返回的数据存到这个字典里
@property(nonatomic,strong)NSMutableDictionary *InfoDictionary;
@property(nonatomic,strong)NSMutableArray *detailArr;
@property(nonatomic,strong)NSMutableArray *chesklArr;
@property(nonatomic,strong)SendPersonTableViewCell *sendCell;
@end

@implementation EventsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftBarButtonItemWithImageName:@"btn_back_normal.80.png" andTitle:@"返回"];
    [self.view setBackgroundColor:KRGB(211, 211, 211, 0.5)];
    [self getToken];
    [self PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/work/getWorkDetail"];
    
    
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
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer  = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept" ];
    [manager.requestSerializer setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type" ];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",@"text/html", @"text/plain",nil];
    
    
    /****************************************************************************************/
    
    //获取当前时间
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *DateTime = [formatter stringFromDate:date];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:self.workIDnum forKey:@"workID"];
    NSMutableDictionary *Alldict=[[NSMutableDictionary alloc] init];
    [Alldict setValue:dictionary forKey:@"app"];
    
    [Alldict setValue:self.tokenStr forKey:@"token"];
    [Alldict setValue:DateTime forKey:@"timestamp"];
    
    
    //md5加密
    //    //字符串拼接
    
    NSString *MD5String1=[self ziDianZhuanJson:dictionary];
    
    NSString *MD5string2=[NSString stringWithFormat:@"%@%@",[Alldict objectForKey:@"token"],[Alldict objectForKey:@"timestamp"]];
    NSString *MD5Str=[ MD5string2 stringByAppendingString: MD5String1];
     //NSLog(@"hahahah:%@",MD5Str);
    //MD5加密
    NSString *getStrMD5=[self encryptStringWithMD5:MD5Str];
    [Alldict setValue:getStrMD5  forKey:@"checksum"];
    
    
    
    
    /****************************************************************************************/
    
    //传入的参数
    
    NSDictionary *parameters =[NSDictionary dictionaryWithObjectsAndKeys:dictionary,@"app",DateTime,@"timestamp",self.tokenStr,@"token",getStrMD5,@"checksum", nil];
    
    // @{@"app":@"[]",@"timestamp":DateTime,@"token":userModel.token,@"checksum":getStrMD5};
    
    //讲字典类型转换成json格式的数据，然后讲这个json字符串作为字典参数的value传到服务器
    // NSLog(@"----%@----",self.tokenStr);
    
    //接口地址
    //NSString *urlString = @"http://louyu.qianchengwl.cn/minapp/warn/getHadSubmitWarnList";
    NSString *urlString = Url;
    
    [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        //请求成功返回数据；需要转化成字典（即json格式数据）
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
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
            [self.detailTableView removeFromSuperview];
            [self.view addSubview:self.detailTableView];
            
        }
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        
        
        
    }];
    
    
}


//转成json字符串
-(NSString *)ziDianZhuanJson:(NSDictionary *)object{
    
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    if (! jsonData) {
        NSLog(@"________Got an error________: %@", error);
    }
    else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    
    //去掉字符串中的空格
    jsonString = [jsonString stringByReplacingOccurrencesOfString: @" " withString: @""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString: @"\n" withString: @""];
    
    return jsonString;
}

//MD5加密
-(NSString *)encryptStringWithMD5:(NSString *)inputStr{
    const char *newStr = [inputStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(newStr,(unsigned int)strlen(newStr),result);
    NSMutableString *outStr = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for(int i = 0;i<CC_MD5_DIGEST_LENGTH;i++){
        [outStr appendFormat:@"%02x",result[i]];//注意：这边如果是x则输出32位小写加密字符串，如果是X则输出32位大写字符串
    }
    return outStr;
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
        static NSString *IDhead=@"IDhead";
        HeadTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:IDhead];
        
        if (cell==nil) {
            cell=[[HeadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IDhead];
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
        static NSString *InfoDetail=@"InfoDetail";
        InfoDetailTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:InfoDetail];
        // cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell==nil) {
            cell=[[InfoDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:InfoDetail];
            
        }
         [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        WorkDetailModel *model=self.detailArr[indexPath.row];
        [cell bindDataWithModel:model];
        return cell;
        
    }
    else if(indexPath.section == 2)
    {
        static NSString *SendPerson=@"SendPerson";
         self.sendCell=[tableView dequeueReusableCellWithIdentifier:SendPerson];
        // cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.sendCell==nil) {
            self.sendCell=[[SendPersonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SendPerson];
            
        }
         [self.sendCell setSelectionStyle:UITableViewCellSelectionStyleNone];

        
        __weak typeof(self)weakSelf = self;
        [self.sendCell setSendController:^(UIViewController *controller) {
            
            //            controller.hidesBottomBarWhenPushed=YES;
            [weakSelf presentViewController:controller animated:YES completion:nil];
            
            
        }];

//        WorkDetailModel *model=self.detailArr[indexPath.row];
//        [cell bindDataWithModel:model];
        return self.sendCell;
        
    }
    
    else if(indexPath.section == 3)
    {
        static NSString *ID3333=@"ID3333";
        StatuDetailTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID3333];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        if (cell==nil) {
            cell=[[StatuDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID3333];
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
        if (indexPath.row==2) {
            
            [self.sendCell.addPersonImageView sd_setImageWithURL:[NSURL URLWithString:model.headImgUrl]];
            self.sendCell.addNameLabel.text=model.userName;
        }
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
    
    
    else{
        return 0;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
