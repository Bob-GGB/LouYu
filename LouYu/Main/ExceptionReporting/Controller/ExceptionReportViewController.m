//
//  ExceptionReportViewController.m
//  LouYu
//
//  Created by barby on 2017/8/1.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "ExceptionReportViewController.h"
#import "SecondPartTableViewCell.h"
#import "AddPersonnelTableViewCell.h"
#import "PlaceViewController.h"
#import "AddImageViewTableViewCell.h"


//语音路径
//#define RecordFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"tempRecord.data"]
 //  NSURL * audioUrl  = [NSURL fileURLWithPath:[RecordFile stringByAppendingString:@"yuyin.caf"]];
@interface ExceptionReportViewController ()<UITableViewDelegate,UITableViewDataSource >
@property(nonatomic,strong)UITableViewCell *TableViewcell;
@property (nonatomic,strong)UITableView *detailTableView;
@property(nonatomic,strong)UILabel *placeLabel;

@property(nonatomic,strong)SecondPartTableViewCell *cell;
@property(nonatomic,strong)AddPersonnelTableViewCell *cells;

@property(nonatomic,strong)NSNumber *tokenStr;
//服务器返回的数据存到这个字典里
@property(nonatomic,strong)NSMutableDictionary *InfoDictionary;
@property(nonatomic,strong)NSMutableArray *imageArr;

@end

@implementation ExceptionReportViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *headImgUrl=[defaults valueForKey:@"KheadImgUrl"];
   // NSLog(@"headImgUrl:%@",headImgUrl);

    [self.cells.addPersonImageView sd_setImageWithURL:[NSURL URLWithString:headImgUrl] placeholderImage:[UIImage imageNamed:@"btn_default.png"]];

    NSUserDefaults *defaultss=[NSUserDefaults standardUserDefaults];
    NSString *placeStr=[defaultss valueForKey:@"KplaceName"];
    self.placeLabel.text=placeStr;


}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.imageArr=[NSMutableArray array];
    [self setLeftBarButtonItemWithImageName:@"btn_back_normal.80.png" andTitle:@"返回"];
    [self.view setBackgroundColor:KRGB(211, 211, 211, 1.0)];
    [self setTitle:@"上报"];
    // [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.view addSubview:self.detailTableView];
    [self getToken];
}


-(UITableView *)detailTableView{
    if (_detailTableView==nil) {
        
        _detailTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-64*Height) style:UITableViewStylePlain];
        //去除分割线
        _detailTableView.separatorStyle = UITableViewCellAccessoryNone;
        // [_detailTableView setBackgroundColor:KRGB(211, 211, 211, 1.0)];
        [_detailTableView setDelegate:self];
        [_detailTableView setDataSource:self];
    }
    
    return _detailTableView;
}

#pragma mark - 数据源方法
//设置组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
//设置每一组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
        return 1 ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section==0) {
        static NSString *ID111=@"ID111";
        self.TableViewcell=[tableView dequeueReusableCellWithIdentifier:ID111];
        // cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.TableViewcell==nil) {
            self.TableViewcell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID111];
        }
        self.TableViewcell.textLabel.text=@"地点";
        self.placeLabel =[[UILabel alloc] initWithFrame:CGRectMake(80, 10, KscreenWidth-160, 20)];
        
        [self.placeLabel setTextAlignment:NSTextAlignmentLeft];
        [self.placeLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [self.placeLabel setTextColor:KRGB(153, 153, 153, 1.0)];
        [self.TableViewcell addSubview:self.placeLabel];
        UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.placeLabel.frame)+10, KscreenWidth, 10)];
        [lineView setBackgroundColor:KRGB(235, 235, 235, 1.0f)];
        [self.TableViewcell addSubview:lineView];
//        [cell.detailTextLabel setFrame:CGRectMake(10, 0, KscreenWidth-cell.textLabel.frame.size.width-30, 30)];
        
        
        self.TableViewcell .accessoryType  = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        
        return self.TableViewcell;
    }
    else if(indexPath.section == 1)
    {
        static NSString *SecondPartID=@"SecondPartID";
       self.cell =[tableView dequeueReusableCellWithIdentifier:SecondPartID];
        // cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.cell==nil) {
            self.cell=[[SecondPartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SecondPartID];
        }
                return self.cell;
        
    }
    else if(indexPath.section == 2)
    {
        static NSString *AddImageslID=@"AddImageslID";
        AddImageViewTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:AddImageslID];
        // cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell==nil) {
            cell=[[AddImageViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddImageslID];
            
            
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
         __weak typeof(self)weakSelf = self;
        [cell setSendController:^(UIViewController *controller) {
            
//            controller.hidesBottomBarWhenPushed=YES;
            [weakSelf presentViewController:controller animated:YES completion:nil];
            //controller.hidesBottomBarWhenPushed=NO;
            
            
        }];
        
        return cell;
        
    }

    else if(indexPath.section == 3)
    {
        static NSString *AddPersonnelID=@"AddPersonnelID";
        self.cells=[tableView dequeueReusableCellWithIdentifier:AddPersonnelID];
        // cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.cells==nil) {
            self.cells=[[AddPersonnelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddPersonnelID];
        
        }
        __weak typeof(self)weakSelf = self;
        [self.cells setSendController:^(UIViewController *controller) {
            
            controller.hidesBottomBarWhenPushed=YES;
            [weakSelf.navigationController pushViewController:controller animated:NO];
            //controller.hidesBottomBarWhenPushed=NO;
        }];
        
        return self.cells;
        
    }
    else if(indexPath.section == 4)
    {
        static NSString *SendButtonID=@"SendButtonID";
        UITableViewCell *sendcell=[tableView dequeueReusableCellWithIdentifier:SendButtonID];
        // cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (sendcell==nil) {
            sendcell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SendButtonID];
            
        }
        UIButton *senderButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [senderButton setFrame:CGRectMake(50, 10, KscreenWidth-100, 30)];
        [senderButton setImage:[UIImage imageNamed:@"btn_tijiao.png"] forState:UIControlStateNormal];
        [senderButton addTarget:self action:@selector(senderButton:) forControlEvents:UIControlEventTouchUpInside];
        [sendcell addSubview:senderButton];
        return sendcell;
        
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
        return 50*Height;
    }
    else if (indexPath.section == 1)
    {
            return 168;
        
    }
    else if (indexPath.section == 2)
    {
        return 105*Height;
    }
    else if (indexPath.section == 3)
    {
        return 115*Height;
    }
    else if (indexPath.section == 4)
    {
        return 300*Height;
    }
    
    
    else{
        return 0;
    }
}

//反选  点击的时候灰色 返回来的时候 又变回白色
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        PlaceViewController *placeCV=[[PlaceViewController alloc] init];
        [placeCV setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:placeCV animated:NO];
    }
    
    
}

#pragma --提交按钮
-(void)senderButton:(UIButton *)sender{
    NSLog(@"提交");
    
    [self PostDataToSever];

}
-(void)getToken{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *dic=[defaults dictionaryForKey:@"UserInfoDic"];
    //取到userInfo
    NSDictionary *userDic=dic[@"content"][@"userInfo"];
    self.tokenStr=userDic[@"token"];
    // NSLog(@"self.tokenStr%@",self.tokenStr);
    
}
//转成json字符串
-(NSString *)ziDianZhuanJson:(NSDictionary *)object{
    
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:0 error:&error];
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
#pragma --上传图片到服务器

-(void)PostDataToSever{
    
    /****************************************************************************************/
    
    NSString *tmpstr=@"\"[]\"";
    
    //获取当前时间
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *DateTime = [formatter stringFromDate:date];
    
    NSMutableDictionary *Alldict=[[NSMutableDictionary alloc] init];
    [Alldict setValue:tmpstr forKey:@"app"];
    
    [Alldict setValue:self.tokenStr forKey:@"token"];
    [Alldict setValue:DateTime forKey:@"timestamp"];
    
    
    //md5加密
    //    //字符串拼接
    
    
    NSString *MD5string2=[NSString stringWithFormat:@"%@%@%@",[Alldict objectForKey:@"token"],[Alldict objectForKey:@"timestamp"],[Alldict objectForKey:@"app"]];
    // NSLog(@"hahahah%@",MD5Str);
    //MD5加密
    //NSLog(@"--加密之前：%@",MD5string2);
    NSString *getStrMD5=[self encryptStringWithMD5:MD5string2];
    [Alldict setValue:getStrMD5  forKey:@"checksum"];
    
    
    /****************************************************************************************/
    
    //传入的参数
    
    NSDictionary *parameters =[NSDictionary dictionaryWithObjectsAndKeys:@"[]",@"app",DateTime,@"timestamp",self.tokenStr,@"token",getStrMD5,@"checksum", nil];

    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSArray *ImgArr=[defaults valueForKey:@"KImagesArr"];
    NSString *urlStr=@"http://louyu.qianchengwl.cn/minapp/upload/upload";
    
    if (ImgArr) {
        for (NSData *obj in ImgArr) {
            
            [ HttpRequest upload:urlStr parameters:parameters fileData:obj name:@"file" fileName:@"hh.jpg" mimeType:@"image/jpg" progress:^(NSProgress *progress) {
                
            } success:^(id responseObj) {
                
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
                
                //NSLog(@"self.InfoDictionary :%@",self.InfoDictionary[@"content"][@"imgUrl"]);
                [self.imageArr addObject:self.InfoDictionary[@"content"][@"imgUrl"]];
                NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                [defaults setObject:self.imageArr forKey:@"KimageArray"];
                [defaults synchronize];
                }
                //NSLog(@"KimageArray：%@",self.imageArr);
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
            }];
            
        }
        
    }
    
    //语音路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject];
    NSString *mp3FilePath = [path stringByAppendingPathComponent:@"record.mp3"];
    NSURL * audioUrl=[NSURL fileURLWithPath:mp3FilePath];
    NSData *voiceData=[NSData dataWithContentsOfURL:audioUrl];
    [HttpRequest upload:urlStr parameters:parameters fileData:voiceData name:@"file" fileName:@"voice.mp3" mimeType:@"application/octet-stream" progress:nil success:^(id responseObj) {
        //请求成功返回数据；需要转化成字典（即json格式数据）
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"dict:%@",dict);
        if ([dict[@"code"] isEqualToNumber:@(-1001)]) {
            [ClearCache showHUDWithText:@"该账号已在其他设备登录，请重新登录"];
            LoginViewController *logInCV=[[LoginViewController alloc] init];
            [self presentViewController:logInCV animated:YES completion:nil];
        }
        //                NSLog(@"dict:%@",dict);
        else{
        
            
            [ClearCache showHUDAndView:self.navigationController.view completionBlock:^{
                if ([self.InfoDictionary[@"code"] isEqualToNumber:@1]) {
                    [SVProgressHUD showSuccessWithStatus:@"语音上传成功"];
                    [SVProgressHUD dismissWithDelay:0.5];
                    [SVProgressHUD showSuccessWithStatus:@"语音上传成功"];
                    [SVProgressHUD dismissWithDelay:0.5];
                    [self.navigationController popViewControllerAnimated:YES]; 
                }
            }];
       
           }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            NSUserDefaults *defaults1=[NSUserDefaults standardUserDefaults];
            NSNumber  *userIdNum=[defaults1 valueForKey:@"KuserID"];
            NSNumber  *placeIdNum=[defaults1 valueForKey:@"KplaceID"];
            NSArray  *imagesarray=[defaults1 valueForKey:@"KimageArray"];
            // NSLog(@"image：%@",imagesarray);
            if (imagesarray.count !=0) {
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:imagesarray options:0 error:nil];
                
                NSString *imageStr=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                //去掉字符串中的空格
                imageStr = [imageStr stringByReplacingOccurrencesOfString: @"\n" withString: @""];
                imageStr = [imageStr stringByReplacingOccurrencesOfString: @"\\" withString: @""];
                //去除转义字符“\”
                /*-------------------------------------------------------------------*/
                NSMutableString *imageString = [NSMutableString stringWithString:imageStr];
                NSString *character1 = nil;
                for (int i = 0; i < imageString.length; i ++) {
                    character1 = [imageString substringWithRange:NSMakeRange(i, 1)];
                    if ([character1 isEqualToString:@"\\"])
                        [imageString deleteCharactersInRange:NSMakeRange(i, 1)];
                }

            }
            else{
                [ClearCache showHUDWithText:@"你有图片或相关信息未填写"];
            }
                       /*-------------------------------------------------------------------*/
            
            
            //            imageStr = [imageStr stringByReplacingOccurrencesOfString: @"‘" withString: @""];
            //            imageStr = [imageStr stringByReplacingOccurrencesOfString: @"’" withString: @""];
            
            
            //获取当前时间
            NSDate *date = [NSDate date];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            
            [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
            NSString *DateTime = [formatter stringFromDate:date];
            
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
//            if (placeIdNum !=NULL&&self.cell.suggestText.text !=NULL&&dict[@"content"][@"imgUrl"] !=NULL&&imagesarray.count!=0&&userIdNum !=NULL) {
//                
//            }
            [dictionary setValue:placeIdNum forKey:@"placeID"];
            [dictionary setValue:self.cell.suggestText.text forKey:@"textDescription"];
            [dictionary setValue:dict[@"content"][@"imgUrl"] forKey:@"voiceDescription"];
            [dictionary setValue:@20.000000 forKey:@"longitude"];
            [dictionary setValue:@20.000000 forKey:@"latitude"];
            [dictionary setValue:imagesarray forKey:@"photoList"];
            [dictionary setValue:userIdNum forKey:@"checkUserID"];
            NSMutableDictionary *Alldict=[[NSMutableDictionary alloc] init];
            [Alldict setValue:dictionary forKey:@"app"];
            
            [Alldict setValue:self.tokenStr forKey:@"token"];
            [Alldict setValue:DateTime forKey:@"timestamp"];
            
            //md5加密
            //    //字符串拼接
            
            NSString *MD5String1=[self ziDianZhuanJson:dictionary];
            
            //去除转义字符“\”
            /*-------------------------------------------------------------------*/
            NSMutableString *responseString = [NSMutableString stringWithString:MD5String1];
            NSString *character = nil;
            for (int i = 0; i < responseString.length; i ++) {
                character = [responseString substringWithRange:NSMakeRange(i, 1)];
                if ([character isEqualToString:@"\'"]||[character isEqualToString:@"\\"])
                    [responseString deleteCharactersInRange:NSMakeRange(i, 1)];
            }
            /*-------------------------------------------------------------------*/
            NSString *MD5string2=[NSString stringWithFormat:@"%@%@",[Alldict objectForKey:@"token"],[Alldict objectForKey:@"timestamp"]];
            NSString *MD5Str=[ MD5string2 stringByAppendingString: responseString];
            //            NSLog(@"加密之前：%@",MD5Str);
            //MD5加密
            NSString *getStrMD5=[self encryptStringWithMD5:MD5Str];
            [Alldict setValue:getStrMD5  forKey:@"checksum"];
            /****************************************************************************************/
            
                       //传入的参数
            NSDictionary *parameters =[NSDictionary dictionaryWithObjectsAndKeys:dictionary,@"app",DateTime,@"timestamp",self.tokenStr,@"token",getStrMD5,@"checksum", nil];
            //NSLog(@"parameters:%@",parameters);
            NSString *urlString=@"http://louyu.qianchengwl.cn/minapp/patrol/submitPatrol";
            
           

            [HttpRequest POST:urlString parameters:parameters success:^(id responseObj) {
                
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves error:nil];
                if ([dict[@"code"] isEqualToNumber:@(-1001)]) {
                    [SVProgressHUD showInfoWithStatus:@"该账号已在其他设备登录，请重新登录"];
                    [SVProgressHUD dismissWithDelay:1.0];
                    LoginViewController *logInCV=[[LoginViewController alloc] init];
                    [self presentViewController:logInCV animated:YES completion:nil];
                }
                //                NSLog(@"dict:%@",dict);
                else{
                if ([dict[@"code"] isEqualToNumber:@1]) {
                    [SVProgressHUD showSuccessWithStatus:@"上报成功"];
                    [SVProgressHUD dismissWithDelay:0.5];
                    
                }
                    }
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
            }];
        });
        
        
        
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
   
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
