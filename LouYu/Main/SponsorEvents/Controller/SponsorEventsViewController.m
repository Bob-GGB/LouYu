//
//  SponsorEventsViewController.m
//  LouYu
//
//  Created by barby on 2017/8/14.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "SponsorEventsViewController.h"
#import "AddPersonnelTableViewCell.h"
#import "PersonelViewController.h"
#import "PlaceViewController.h"
#import "TypeSViewController.h"
#import "HMDatePickView.h"
@interface SponsorEventsViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate ,UINavigationControllerDelegate>
@property (nonatomic,strong)UITableView *detailTableView;
@property(nonatomic,strong)UILabel *placeLabel;
@property(nonatomic,strong)UITextView *describeTextView;
@property(nonatomic,strong)UITableViewCell *cell;
@property(nonatomic,copy)NSString *placeStr;
@property(nonatomic,copy)NSString *typeStr;
@property(nonatomic,copy)NSString *timeBegianStr;
@property(nonatomic,copy)NSString *timeEndStr;
@property(nonatomic,copy)NSString *headImageUrl;
@property(nonatomic,copy)NSString *textStr;
@property(nonatomic,strong)NSNumber *tokenStr;
@property(nonatomic,strong)NSNumber *typeIDNum;
@property(nonatomic,strong)NSNumber *userIDNum;
@property(nonatomic,strong)NSNumber *placeIDNum;
@end

@implementation SponsorEventsViewController



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    self.placeStr=[defaults valueForKey:@"KplaceName"];
    self.typeStr=[defaults valueForKey:@"KtypeName"];
    self.headImageUrl=[defaults valueForKey:@"KheadImgUrl"];
    self.textStr=[defaults valueForKey:@"Ktext"];;
    [self.detailTableView reloadData];
    
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftBarButtonItemWithImageName:@"btn_back_normal.80.png" andTitle:@"返回"];
    [self.view setBackgroundColor:KRGB(240, 240, 240, 1.0)];
    [self setTitle:@"发起事件"];
    // [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
  
    [self.view addSubview:self.detailTableView];
    
    [self getToken];
}

-(UITableView *)detailTableView{
    if (_detailTableView==nil) {
        
        _detailTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-64*Height) style:UITableViewStylePlain];
        //去除分割线
        _detailTableView.separatorStyle = UITableViewStyleGrouped;
        _detailTableView.showsVerticalScrollIndicator=NO;
         [_detailTableView setBackgroundColor:KRGB(240, 240, 240, 1.0)];
        [_detailTableView setDelegate:self];
        [_detailTableView setDataSource:self];
    }
    
    return _detailTableView;
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
     NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    self.userIDNum=[defaults valueForKey:@"KuserID"];
    self.typeIDNum=[defaults valueForKey:@"KtypeID"];
    self.placeIDNum=[defaults valueForKey:@"KplaceID"];
    //获取当前时间
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:self.typeIDNum forKey:@"typeID"];
    [dictionary setValue:self.placeIDNum forKey:@"placeID"];
    [dictionary setValue:self.userIDNum forKey:@"userID"];
    [dictionary setValue:self.textStr forKey:@"title"];
    [dictionary setValue:self.timeBegianStr forKey:@"begintime"];
    [dictionary setValue:self.timeEndStr forKey:@"endtime"];

    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *DateTime = [formatter stringFromDate:date];
    
    NSMutableDictionary *Alldict=[[NSMutableDictionary alloc] init];
    
    [Alldict setValue: dictionary forKey:@"app"];
    
    [Alldict setValue:self.tokenStr forKey:@"token"];
    [Alldict setValue:DateTime forKey:@"timestamp"];
    
    
    //md5加密
    //    //字符串拼接
    
    // NSString *MD5string=[self ziDianZhuanJson:pageDict];
    NSString *MD5String1=[self ziDianZhuanJson:dictionary];
    
    NSString *MD5string2=[NSString stringWithFormat:@"%@%@",[Alldict objectForKey:@"token"],[Alldict objectForKey:@"timestamp"]];
    NSString *MD5Str=[ MD5string2 stringByAppendingString: MD5String1];
    //NSLog(@"hahaha--%@",MD5Str);
    //MD5加密
    NSString *getStrMD5=[self encryptStringWithMD5:MD5Str];
    [Alldict setValue:getStrMD5  forKey:@"checksum"];
    
    
    
    /****************************************************************************************/
    
    //传入的参数
    
    NSDictionary *parameters =[NSDictionary dictionaryWithObjectsAndKeys:dictionary,@"app",DateTime,@"timestamp",self.tokenStr,@"token",getStrMD5,@"checksum", nil];
    //接口地址
    //NSString *urlString = @"http://louyu.qianchengwl.cn/minapp/work/launchWork";
    NSString *urlString = Url;
    
    [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //请求成功返回数据；需要转化成字典（即json格式数据）
       // NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
       // NSLog(@"%@",dict);
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






#pragma mark - 数据源方法
//设置组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
//设置每一组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 4;
    }
    else return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section==0) {
        static NSString *SponsorID=@"SponsorID";
        self.cell=[tableView dequeueReusableCellWithIdentifier:SponsorID];
        // cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.cell==nil) {
            self.cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SponsorID];
        }
        [self.cell.textLabel setTextColor:[UIColor grayColor]];
        [self.cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        [self.cell.detailTextLabel setTextColor:[UIColor grayColor]];
        [self.cell.detailTextLabel setFont:[UIFont systemFontOfSize:14]];
        self.cell .accessoryType  = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        self.placeLabel =[[UILabel alloc] initWithFrame:CGRectMake(80, 10, KscreenWidth-160, 30)];
        [self.placeLabel setTextAlignment:NSTextAlignmentLeft];
        [self.placeLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [self.placeLabel setTextColor:KRGB(153, 153, 153, 1.0)];
        [self.cell addSubview:self.placeLabel];
        
        if (indexPath.row==0) {
            self.cell.textLabel.text=@"地点";
            self.cell.detailTextLabel.text=self.placeStr;
        }
        if (indexPath.row==1) {
            self.cell.textLabel.text=@"类型";
            self.cell.detailTextLabel.text=self.typeStr;
        }

        if (indexPath.row==2) {
            self.cell.textLabel.text=@"开始时间";
            //cell.detailTextLabel.text=@"安防巡检";
        }

        if (indexPath.row==3) {
            self.cell.textLabel.text=@"结束时间";
            //cell.detailTextLabel.text=@"安防巡检";
        }

        
        //        [cell.detailTextLabel setFrame:CGRectMake(10, 0, KscreenWidth-cell.textLabel.frame.size.width-30, 30)];
        return self.cell;
    }
    else if(indexPath.section == 1)
   {
        static NSString *descripetID=@"descripetID";
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:descripetID];
        // cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell==nil) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:descripetID];
        }
       
       
       self.describeTextView=[[UITextView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 135)];
       
       [self.describeTextView setFont:[UIFont systemFontOfSize:16.0f]];
       [self.describeTextView setBackgroundColor:[UIColor whiteColor]];
       [self.describeTextView setScrollEnabled:YES];
       [self.describeTextView setReturnKeyType:UIReturnKeyDone];
       [self.describeTextView setDelegate:self];
       if (self.textStr==NULL) {
            self.describeTextView.text=@"描述 请输入异常描述";
       }
       else
            self.describeTextView.text=self.textStr;
      
       //self.textStr=self.describeTextView.text;
       [self.describeTextView setKeyboardType:UIKeyboardTypeEmailAddress];
       [self.describeTextView setTextColor:[UIColor blackColor]];
       [cell addSubview:self.describeTextView];
        
        return cell;
        
    }
     else if(indexPath.section == 2)
    {
        static NSString *SendProsenIDs=@"SendProsenIDs";
        AddPersonnelTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:SendProsenIDs];
        // cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell==nil) {
            cell=[[AddPersonnelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SendProsenIDs];
            
            
        }
        [cell.addPersonImageView sd_setImageWithURL:[NSURL URLWithString:self.headImageUrl] placeholderImage:[UIImage imageNamed:@"btn_default.png"]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        __weak typeof(self)weakSelf = self;
        [cell setSendController:^(UIViewController *controller) {
            
            controller.hidesBottomBarWhenPushed=YES;
            [weakSelf.navigationController pushViewController:controller animated:NO];
            //controller.hidesBottomBarWhenPushed=NO;
        }];
        
        return cell;

      }

    else if(indexPath.section ==3)
    {
        static NSString *SendButtonID1=@"SendButtonID1";
        UITableViewCell *sendcell=[tableView dequeueReusableCellWithIdentifier:SendButtonID1];
        // cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (sendcell==nil) {
            sendcell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SendButtonID1];
            
        }
        UIButton *senderButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [senderButton setFrame:CGRectMake(50, 20, KscreenWidth-100, 40)];
        [senderButton setImage:[UIImage imageNamed:@"btn_tijiao.png"] forState:UIControlStateNormal];
        [senderButton addTarget:self action:@selector(senderButton:) forControlEvents:UIControlEventTouchUpInside];
        [sendcell addSubview:senderButton];
        return sendcell;
        
    }
    else
        return nil;
    
}




#pragma mark - 代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return 10;
    }
    else if (section==2){
        return 10;
    }
    else if (section==3){
        return 20;
    }
    else return 0.1f;

}

//返回单元格行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 50*Height;
    }
    else if (indexPath.section == 1)
    {
        return 135*Height;
        
    }
    else if (indexPath.section == 2)
    {
        return 105*Height;
    }
    else if (indexPath.section == 3)
    {
        return 300*Height;
    }
//    else if (indexPath.section == 4)
//    {
//        return 300*Height;
//    }
//    
    
    else{
        return 0;
    }
}

//反选  点击的时候灰色 返回来的时候 又变回白色
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row==0) {
        PlaceViewController *placeCV=[[PlaceViewController alloc] init];
        [placeCV setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:placeCV animated:NO];
    }
    if (indexPath.row==1) {
        if (self.placeStr==NULL) {
            [ClearCache showHUDWithText:@"请选择地点"];
        }
        else{
            
        TypeSViewController *typeCV=[[TypeSViewController alloc] init];
        [typeCV setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:typeCV animated:NO];
        }
    }
    
    if(indexPath.row==2){
        /** 自定义日期选择器 */
        HMDatePickView *datePickVC = [[HMDatePickView alloc] initWithFrame:self.detailTableView.superview.frame];
        //距离当前日期的年份差（设置最大可选日期）
        datePickVC.maxYear = -1;
        //设置最小可选日期(年分差)
        //    _datePickVC.minYear = 10;
        datePickVC.date = [NSDate date];
        //设置字体颜色
        datePickVC.fontColor = KRGB(64, 224, 208, 1.0f);
        
        //日期回调
        datePickVC.completeBlock = ^(NSString *selectDate) {
           

            cell.detailTextLabel.text=selectDate;
            self.timeBegianStr=selectDate;
        };
        
        //配置属性
        [datePickVC configuration];
        
        [self.view addSubview:datePickVC];
    }
    if(indexPath.row==3){
        /** 自定义日期选择器 */
        HMDatePickView *datePickVC = [[HMDatePickView alloc] initWithFrame:self.detailTableView.superview.frame];
        //距离当前日期的年份差（设置最大可选日期）
        datePickVC.maxYear = -1;
        //设置最小可选日期(年分差)
        //    _datePickVC.minYear = 10;
        datePickVC.date = [NSDate date];
        //设置字体颜色
        datePickVC.fontColor = KRGB(64, 224, 208, 1.0f);
        
        //日期回调
        datePickVC.completeBlock = ^(NSString *selectDate) {
            
            
            cell.detailTextLabel.text=selectDate;
            self.timeEndStr=selectDate;
        };
        
        //配置属性
        [datePickVC configuration];
        
        [self.view addSubview:datePickVC];
    }

    
    
}

#pragma --提交按钮
-(void)senderButton:(UIButton *)sender{
    NSLog(@"提交");
    
    
    [self showAlertController:@"确定发送吗？"];
    
   
    
    
    
}


- (void) showAlertController:(NSString *)msg{
    
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    //设置按钮
    UIAlertAction *action = [UIAlertAction
                             actionWithTitle:@"确定"
                             style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                 
                                 
                                  [self PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/work/launchWork"];
                                 
                                 [self.navigationController popViewControllerAnimated:NO];
                                 
                                 NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                                 [defaults removeObjectForKey:@"KplaceName"];
                                 [defaults removeObjectForKey:@"KtypeName"];
                                 [defaults removeObjectForKey:@"KheadImgUrl"];
                                 [defaults removeObjectForKey:@"Ktext"];;
                                 
                             }];
    UIAlertAction *action1 = [UIAlertAction
                              actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                              handler:nil];
    
    [controller addAction:action];
    [controller addAction:action1];
    
    
    [self presentViewController:controller animated:YES completion:nil];
}




#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        textView.text = @"描述 请输入异常描述";
        textView.textColor = [UIColor grayColor];
        
    }
    else
    {
        NSUserDefaults *defaultss=[NSUserDefaults standardUserDefaults];
        [defaultss setObject:textView.text forKey:@"Ktext"];
        [defaultss synchronize];
        [textView resignFirstResponder];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"描述 请输入异常描述"]){
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    [self.describeTextView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([@"\n" isEqualToString:text] == YES)
    {
        
        [textView resignFirstResponder];
        
    }
    
    return YES;
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
