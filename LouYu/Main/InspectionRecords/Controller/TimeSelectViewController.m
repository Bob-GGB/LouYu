//
//  TimeSelectViewController.m
//  LouYu
//
//  Created by barby on 2017/8/8.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "TimeSelectViewController.h"
#import "TimeSelectTableViewCell.h"
#import "HMDatePickView.h"
@interface TimeSelectViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *mainTableView;


@property (copy, nonatomic) NSString *dateStr;
@end

@implementation TimeSelectViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setLeftBarButtonItemWithImageName:@"btn_back_normal.80.png" andTitle:@"返回"];
    [self setTitle:@"巡查记录"];
    // [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self creatTableView];
}



-(void)creatTableView{
    
    self.mainTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-64-44) style:UITableViewStylePlain];
    //去除分割线
     self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mainTableView setBackgroundColor:[UIColor whiteColor]];
    [self.mainTableView setDelegate:self];
    [self.mainTableView setDataSource:self];
    [self.view addSubview:self.mainTableView];
    
}

//设置组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//设置每一组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *timeSelectID1=@"timeSelectID1";
    TimeSelectTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:timeSelectID1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell==nil) {
        cell=[[TimeSelectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:timeSelectID1];
        
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row==0) {
         cell.dateNameLabel.text=@"开始日期";
    }
   else
       cell.dateNameLabel.text=@"结束日期";
    
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *imageView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 30*Height)];
    [imageView setBackgroundColor:[UIColor whiteColor]];
    UIImageView *dateIamgeView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50*Width, 15)];
    [dateIamgeView setImage:[UIImage imageNamed:@"msg_default12.png"]];
    [imageView addSubview:dateIamgeView];
    return imageView;


}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView *buttonView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 49*Height)];
    
    NSArray *arr=@[[UIImage imageNamed:@"quxiao.png"],[UIImage imageNamed:@"queding.png"]];
    
    for (int i=0; i<2; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame: CGRectMake((KscreenWidth/2)*i, 0, KscreenWidth/2, 49*Height)];
        button.tag=i+101;
        [button setImage:arr[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonDidPress:) forControlEvents:UIControlEventTouchUpInside];
        [buttonView addSubview:button];
    }
    return buttonView;

}

//返回单元格行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70*Height;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 30*Height;
    }
else
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 49*Height;
}





-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TimeSelectTableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
        /** 自定义日期选择器 */
        HMDatePickView *datePickVC = [[HMDatePickView alloc] initWithFrame:self.mainTableView.superview.frame];
        //距离当前日期的年份差（设置最大可选日期）
        datePickVC.maxYear = -1;
        //设置最小可选日期(年分差)
        //    _datePickVC.minYear = 10;
        datePickVC.date = [NSDate date];
        //设置字体颜色
    datePickVC.fontColor = KRGB(64, 224, 208, 1.0f);

        //日期回调
        datePickVC.completeBlock = ^(NSString *selectDate) {
            
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            if (indexPath.row==0) {
                cell.dateLabel.text=selectDate;
                [defaults setObject:selectDate forKey:@"KBeganTime"];
            }
            else
                cell.dateLabel.text=selectDate;
             [defaults setObject:selectDate forKey:@"KEndTime"];
            
            [defaults synchronize];
        };

                //配置属性
        [datePickVC configuration];
        
        [self.view addSubview:datePickVC];
    
    
}



-(void)buttonDidPress:(UIButton *)sender{
    if (sender.tag==101) {
         [self.navigationController popViewControllerAnimated:YES];
    }
    else
        [self.navigationController popViewControllerAnimated:YES];


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
