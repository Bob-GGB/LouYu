//
//  SettingViewController.m
//  LouYu
//
//  Created by barby on 2017/8/4.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "SettingViewController.h"
#import "UserInfoModel.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import "STPhotoKitController.h"
#import "UIImagePickerController+ST.h"
#import "STConfig.h"

#import "Const.h"
#import "SettingCell.h"
#import "SettingItemModel.h"
#import "SettingSectionModel.h"
#import "HeadView.h"

#import "UserInfoModel.h"

#import "GroupInfoViewController.h"
//组别信息cell和PlaceTableViewCell的结构一样，可以复用这个cell
#import "PlaceTableViewCell.h"
#import "ChangePWViewController.h"
#import "LoginViewController.h"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, STPhotoKitDelegate>
@property (nonatomic,strong) NSArray  *sectionArray; /**< section模型数组*/
@property(nonatomic,strong)UITableView *myTableView;
@property(nonatomic,strong)HeadView *headView;
@property(nonatomic,strong)UIImage *saveImage;
@property(nonatomic,strong)NSString *headImgStr;
@property(nonatomic,strong)NSNumber *tokenStr;
//服务器返回的数据存到这个字典里
@property(nonatomic,strong)NSMutableDictionary *InfoDictionary;
@property(nonatomic,strong)UserInfoModel *userModel;
@property(nonatomic,strong)NSNumber *roleID;
@property(nonatomic,strong)SettingItemModel *item3;


@end

@implementation SettingViewController



//进入程序时从沙盒拿图片 后者去服务端下载
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.myTableView reloadData];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *dic=[defaults dictionaryForKey:@"UserInfoDic"];
    //取到userInfo
    NSDictionary *userDic=dic[@"content"][@"userInfo"];
    
    self.userModel=[[UserInfoModel alloc] initWithDict:userDic];
    [self setupSections];
    NSUserDefaults *defaultss=[NSUserDefaults standardUserDefaults];
    if ([defaultss objectForKey:@"MtypeName"]==nil) {
        self.item3.detailText=self.userModel.typeName;
    }else{
        self.item3.detailText =[defaultss objectForKey:@"MtypeName"];
    }
    //NSLog(@"----%@",self.item3.detailText);
    
    
    
    if ([defaultss valueForKey:@"KHeadImage"]==NULL) {
        
        if (self.saveImage==NULL) {
            [self.headView.headImageView sd_setImageWithURL:[NSURL URLWithString:self.headImgStr]];
        }
       else
        [self.headView.headImageView setImage:self.saveImage];
    }
    else{
        
        UIImage *newImg=[UIImage imageWithData:[defaultss valueForKey:@"KHeadImage"]];
    [self.headView.headImageView setImage:newImg];
    }
    

}


- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self setLeftBarButtonItemWithImageName:@"btn_back_normal.80.png" andTitle:@"返回"];
    self.title=@"个人设置";
    // [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 100)];
    //[imageView setImage:[UIImage imageNamed:@"矩形-5"]];
    self.headView=[[HeadView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 100)];
    [self.headView.backButton setImage:[UIImage imageNamed:@"normal_back.png"]];
    [self.headView setBackgroundColor:[UIColor whiteColor]];
    [self.headView addSubview:self.headView.changeLabel];
    [imageView addSubview:self.headView];
    [imageView setUserInteractionEnabled:YES];
    
    
    
//    NSLog(@"didload");
//    if ([defaultss valueForKey:@"KHeadImage"]==NULL) {
//        [self.headView.headImageView setImage:self.headImage];
//    }
//    else{
    
    //    UIImage *newImg=[UIImage imageWithData:[defaultss valueForKey:@"KHeadImage"]];
        [self.headView.headImageView setImage:self.headImage];
//    }
    
    self.myTableView.tableHeaderView = imageView;
    UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectedHeadViewDidPress)];
    [imageView addGestureRecognizer:tap0];
    
    self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.myTableView];
    
    [self getToken];
    
    //[self.headView.headImageView sd_setImageWithURL:[NSURL URLWithString:self.headImgStr]];
    
     self.item3.detailText =self.userModel.typeName;
    
    
}


-(UITableView *)myTableView{
    if (_myTableView==nil) {
        
        _myTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-64) style:UITableViewStyleGrouped];
        
        //去除分割线
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.backgroundColor = MakeColorWithRGB(234, 234, 234, 1);
        //        [_myTableView setBackgroundColor:[UIColor whiteColor]];
        [_myTableView setDelegate:self];
        [_myTableView setDataSource:self];
    }
    
    
    return _myTableView;
}

#pragma - mark setup
- (void)setupSections
{
    //************************************section1
    //************************************section1
    SettingItemModel *item1 = [[SettingItemModel alloc]init];
    item1.funcName = @"姓名";
    //    item1.executeCode = ^{
    //        NSLog(@"我的余额");
    //        [self showAlert:@"我的余额"];
    //    };
    item1.detailText = self.userModel.truename;
    item1.accessoryType = SettingAccessoryTypeDisclosureIndicator;
    
    SettingItemModel *item2 = [[SettingItemModel alloc]init];
    item2.funcName = @"手机号";
    item2.accessoryType = SettingAccessoryTypeDisclosureIndicator;
    item2.detailText =self.userModel.mobile;
    
    
    //************************************section2
    self.item3 = [[SettingItemModel alloc]init];
    self.item3.funcName = @"组别信息";
   
       //item3.rigthImage=[UIImage imageNamed:@"normal_back.png"];
    self.item3.detailImage=[UIImage imageNamed:@"normal_back.png"];
    self.item3.accessoryType = SettingAccessoryTypeDisclosureIndicator;
    
    __weak typeof(self)weakSlf=self;
        self.item3.executeCode = ^{
            
            GroupInfoViewController *groupCV=[[GroupInfoViewController alloc] init];
            [weakSlf.navigationController pushViewController:groupCV animated:YES];
        };

    SettingItemModel *item4 = [[SettingItemModel alloc]init];
    item4.funcName = @"修改密码";
    item4.detailImage = [UIImage imageNamed:@"normal_back.png"];
    item4.accessoryType = SettingAccessoryTypeDisclosureIndicator;
    
    item4.executeCode = ^{
        
        ChangePWViewController *changeCV=[[ChangePWViewController alloc] init];
        [self.navigationController pushViewController:changeCV animated:NO];
    };
    SettingSectionModel *section1 = [[SettingSectionModel alloc]init];
    section1.sectionHeaderHeight = 10;
    if ([self.roleID isEqualToNumber:@1]) {
      section1.itemArray = @[item1,item2,self.item3,item4];
    }
    else{
    section1.itemArray = @[item1,item2,item4];
    }
    
    SettingItemModel *item5 = [[SettingItemModel alloc]init];
    item5.funcName = @"退出登录";
    item5.accessoryType = SetingAccesssoryTypeCenter;
    
    item5.executeCode = ^{
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"UserInfoDic"];
        [defaults removeObjectForKey:@"KHeadImage"];
        [defaults removeObjectForKey:@"KHeadImageURL"];
        [defaults removeObjectForKey:@"KTypeName"];
        LoginViewController *loginCV=[[LoginViewController alloc] init];
         [self presentViewController:loginCV animated:YES completion:nil];
    };
    
    
    SettingSectionModel *section2 = [[SettingSectionModel alloc]init];
    section2.sectionHeaderHeight = 28;
    section2.itemArray = @[item5];
    
    
    self.sectionArray = @[section1,section2];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SettingSectionModel *sectionModel = self.sectionArray[section];
    return sectionModel.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"setting";
    SettingSectionModel *sectionModel = self.sectionArray[indexPath.section];
    SettingItemModel *itemModel = sectionModel.itemArray[indexPath.row];
    
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[SettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.item = itemModel;

    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SettingSectionModel *sectionModel = self.sectionArray[indexPath.section];
    SettingItemModel *itemModel = sectionModel.itemArray[indexPath.row];
    if (itemModel.executeCode) {
        itemModel.executeCode();
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    SettingSectionModel *sectionModel = [self.sectionArray firstObject];
    CGFloat sectionHeaderHeight = sectionModel.sectionHeaderHeight;
    
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma - mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    SettingSectionModel *sectionModel = self.sectionArray[section];
    return sectionModel.sectionHeaderHeight;
}





#pragma 更换头像按钮
-(void)selectedHeadViewDidPress{
    
    [self editImageSelected];
    
}

#pragma 保存按钮

-(void)rightBarButtonDidPress:(UIButton *)sender{
    
    [self showAlertController:@"确定要保存吗？"];
   

}
#pragma 警告框

- (void) showAlertController:(NSString *)msg{
    
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    //设置按钮
    UIAlertAction *action = [UIAlertAction
                             actionWithTitle:@"确定"
                             style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                 //更新头像
                                 NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
                                 [userDefault removeObjectForKey:@"KHeadImage"];
                                 NSData *imageData=UIImagePNGRepresentation(self.saveImage);
                                 [userDefault setObject:imageData forKey:@"KHeadImage"];
                                 [userDefault synchronize];
                                 
                                 [self UploadImage:self.saveImage];
                                 
                                 self.headView.headImageView.image=self.saveImage;
                                 [self.myTableView reloadData];
                             }];
    
    UIAlertAction *action1 = [UIAlertAction
                              actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                              handler:nil];
    
    [controller addAction:action];
    [controller addAction:action1];
    
    
    [self presentViewController:controller animated:YES completion:nil];
}

               /***********************拍照和访问相册*************************************/
#pragma mark - --- delegate 视图委托 ---

#pragma mark - 1.STPhotoKitDelegate的委托

- (void)photoKitController:(STPhotoKitController *)photoKitController resultImage:(UIImage *)resultImage{
    
    self.headView.headImageView.image=resultImage;
    //NSLog(@"resultImage:%@",resultImage);
    self.saveImage=resultImage;
    [self.myTableView reloadData];
    
    
    [self setrightBarButtonItemWithImageName:nil andTitle:@"保存"];
}

#pragma mark - 2.UIImagePickerController的委托

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *imageOriginal = [info objectForKey:UIImagePickerControllerOriginalImage];
        STPhotoKitController *photoVC = [STPhotoKitController new];
        [photoVC setDelegate:self];
        [photoVC setImageOriginal:imageOriginal];
        [photoVC setSizeClip:CGSizeMake(KscreenWidth-50, KscreenWidth-50)];
         [self presentViewController:photoVC animated:YES completion:nil];
        
        NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
        [userDefault removeObjectForKey:@"KHeadImage"];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - --- event response 事件相应 ---
- (void)editImageSelected
{
    UIAlertController *alertController = [[UIAlertController alloc]init];
    
    UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *controller = [UIImagePickerController imagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
        
        if ([controller isAvailableCamera] && [controller isSupportTakingPhotos]) {
            [controller setDelegate:self];
            
            [self presentViewController:controller animated:YES completion:nil];
            
                    }else {
            NSLog(@"%s %@", __FUNCTION__, @"相机权限受限");
        }
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"从相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *controller = [UIImagePickerController imagePickerControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [controller setDelegate:self];
        if ([controller isAvailablePhotoLibrary]) {
            
           [self presentViewController:controller animated:YES completion:nil];
            
        }    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:action0];
    [alertController addAction:action1];
    [alertController addAction:action2];
    
    [self presentViewController:alertController animated:YES completion:nil];
   }

 /***********************************************************************************************************/


 /****************************************************上传图片相关代码******************************************/

-(void)UploadImage:(UIImage *)images{
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
    NSString *urlStr=@"http://louyu.qianchengwl.cn/minapp/upload/upload";
    
    NSData *data = UIImageJPEGRepresentation(images,0.7);
    NSDateFormatter *dd = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [dd stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
    if (data!=nil) {
        [HttpRequest upload:urlStr parameters:parameters fileData:data name:@"file" fileName:fileName mimeType:@"image/jpg" progress:^(NSProgress *progress) {
            
        } success:^(id responseObj) {
         
            
            
            
            //请求成功返回数据；需要转化成字典（即json格式数据）
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves error:nil];
            //NSLog(@"%@",dict);
            if ([dict[@"code"] isEqualToNumber:@(-1001)]) {
                [SVProgressHUD showInfoWithStatus:@"该账号已在其他设备登录，请重新登录"];
                [SVProgressHUD dismissWithDelay:1.0];
                LoginViewController *logInCV=[[LoginViewController alloc] init];
                [self presentViewController:logInCV animated:YES completion:nil];
            }
            //                NSLog(@"dict:%@",dict);
            else{
            [self.headView.headImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"content"][@"imgUrl"]]];
                NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
                [userDefault removeObjectForKey:@"KHeadImageURL"];
                [userDefault setObject:dict[@"content"][@"imgUrl"] forKey:@"KHeadImageURL"];
                [userDefault synchronize];
            [self.myTableView reloadData];
            
            [self changeHeadImageToSeverWithImageUrl:dict[@"content"][@"imgUrl"]];
            }
        } failure:^(NSError *error) {
            
            NSLog(@"%@",error);
        }];
    }
    


}


-(void)changeHeadImageToSeverWithImageUrl:(NSString *)imageUrl{

    

    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:imageUrl forKey:@"headImgUrl"];
    NSString *url=@"http://louyu.qianchengwl.cn/minapp/user/headImgUrlChange";
  [HttpRequest POST:url getToken:self.tokenStr paramentDict:dictionary success:^(id responseObj) {
      
              //请求成功返回数据；需要转化成字典（即json格式数据）
              NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves error:nil];
      if ([dict[@"code"] isEqualToNumber:@(-1001)]) {
          [SVProgressHUD showInfoWithStatus:@"该账号已在其他设备登录，请重新登录"];
          [SVProgressHUD dismissWithDelay:1.0];
          LoginViewController *logInCV=[[LoginViewController alloc] init];
          [self presentViewController:logInCV animated:YES completion:nil];
      }

      //        NSLog(@"%@",dict);
      
  } failure:^(NSError *error) {
      NSLog(@"%@",error);
  }];
}



-(void)getToken{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *dic=[defaults dictionaryForKey:@"UserInfoDic"];
    //取到userInfo
    NSDictionary *userDic=dic[@"content"][@"userInfo"];
    self.tokenStr=userDic[@"token"];
    self.headImgStr=userDic[@"thumb"];
    self.roleID=userDic[@"roleID"];
    // NSLog(@"self.tokenStr%@",self.tokenStr);
    
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
