//
//  SingleSelectView.m
//  Exam
//
//  Created by barby on 2017/8/7.
//  Copyright © 2017年 barby. All rights reserved.//

#import "SingleSelectView.h"

#import "MyExamTableViewCell.h"

#import "MyExamHeaderView.h"

#import "QuestionListModel.h"
#import "SelectModel.h"
#define defaultTag 1990

@interface SingleSelectView ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) MyExamHeaderView *myExamHeaderView;

@property (strong, nonatomic) UITableView      *tableView;

@property (strong, nonatomic) NSIndexPath      *currentSelectIndex;
@property(nonatomic,strong)NSNumber *tokenStr;
@property(nonatomic,strong)SelectModel  *model;
@property(nonatomic,strong)NSMutableArray *questionArr;
@property(nonatomic,strong)NSMutableArray *chooseArr;

@property(nonatomic,strong)NSNumber *typeIDNum;
@property(nonatomic,copy)NSString *typeNameStr;
@property(nonatomic,strong)NSNumber *optionId;

@property(nonatomic,strong)NSNumber *questionId;

@property (nonatomic, assign) NSInteger btnTag;//默认选中的Tag


//@property (nonatomic, assign) NSInteger btnTag;//默认选中的Tag

@end

@implementation SingleSelectView

- (instancetype)initWithTypeId:(NSNumber *)typeID {
    
    self = [super init];
    if (self) {
        self.typeIDNum=typeID;
        [self getToken];
        [self PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/test/getQuestionListByTypeID"];
        
       // [self initData];
    }
    return self;
}


-(NSMutableArray *)questionArr{
    if (!_questionArr) {
        _questionArr=[NSMutableArray array];
    }
    return _questionArr;
    
}

-(NSMutableArray *)chooseArr{
    if (!_chooseArr) {
        _chooseArr=[NSMutableArray array];
    }
    return _chooseArr;
}

- (void)initView {

    [self addSubview:self.tableView];
    _tableView.tableHeaderView = self.myExamHeaderView;
    //_tableView.tableFooterView = self.myExamFooterView;
}
- (void)initData {
    
     int i=0;
    QuestionListModel *Quemodel=self.questionArr[i];
     i++;
   // NSLog(@"-------Quemodel.questionID%@",Quemodel.questionID);
    self.questionId=Quemodel.questionID;
    _myExamHeaderView.subjectLabel.text=Quemodel.questionName;
   

}


- (void)setSeleIndexStr:(NSString *)seleIndexStr {

    _seleIndexStr = seleIndexStr;
}

- (void)setSeleIndexPath:(NSIndexPath *)seleIndexPath {

    _seleIndexPath = seleIndexPath;
    _currentSelectIndex = _seleIndexPath;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *string   = @"UITableViewCell";
    
    MyExamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    
    if (!cell) {
        
        cell = [[MyExamTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        SelectModel *selectModel=self.chooseArr[indexPath.row];
     cell.textNameLabel.text=selectModel.option;
     cell.selectedBtn.tag=[selectModel.optionID integerValue];
   // NSLog(@"%@,%@",selectModel.optionID,selectModel.option);
    
    switch (indexPath.row) {
            
            
        case 0:
            [cell.selectedBtn setTitle:@"A" forState:UIControlStateNormal];
            break;
        case 1:
            [cell.selectedBtn setTitle:@"B" forState:UIControlStateNormal];
            
            //cell.selectedBtn.tag = 2;
            break;
        case 2:
            [cell.selectedBtn setTitle:@"C" forState:UIControlStateNormal];
           // cell.selectedBtn.tag = 4;
            break;
        case 3:
            [cell.selectedBtn setTitle:@"D" forState:UIControlStateNormal];
           // cell.selectedBtn.tag = 8;
            break;
            
        default:
            break;
    }
    
    
    //cell.selectedBtn.tag = defaultTag+indexPath.row;
    
    if (cell.selectedBtn.tag == self.btnTag) {
        cell.isSelect = YES;
         [cell.selectedBtn.layer setBorderColor:KRGB(104, 173, 255,1.0).CGColor];
         [cell.selectedBtn setTitleColor:KRGB(104, 173, 255,1.0) forState:UIControlStateSelected ];
        [cell.selectedBtn setBackgroundColor:KRGB(20, 124, 255,1.0)];
        
    }else{
        cell.isSelect = NO;
        [cell.selectedBtn.layer setBorderColor:KRGB(153, 153, 153,1.0).CGColor];
         [cell.selectedBtn setTitleColor:KRGB(153, 153, 153,1.0) forState:UIControlStateNormal ];
         [cell.selectedBtn setBackgroundColor:[UIColor clearColor]];
    }
    __weak MyExamTableViewCell *weakCell = cell;
    [cell setQhxSelectBlock:^(BOOL choice,NSInteger btnTag){
        if (choice) {
            [weakCell.selectedBtn.layer setBorderColor:KRGB(104, 173, 255,1.0).CGColor];
            [weakCell.selectedBtn setTitleColor:KRGB(104, 173, 255,1.0) forState:UIControlStateSelected ];
             [weakCell.selectedBtn setBackgroundColor:KRGB(20, 124, 255,1.0)];
            self.btnTag = btnTag;
            self.model=self.chooseArr[indexPath.row];
            weakCell.selectedBtn.tag=[self.model.optionID integerValue];
                      // NSLog(@"我选的是：%@",self.model.optionID);
            //
            if (self.SingleSelectBlock) {
               // NSLog(@"cell.selectedBtn.tag:%ld,%@",weakCell.selectedBtn.tag,self.questionId);
                self.SingleSelectBlock(indexPath, weakCell.selectedBtn.tag,self.questionId);
            }
            
            [self.tableView reloadData];
        }
        else{
            //选中一个之后，再次点击，是未选中状态，图片仍然设置为选中的图片，记录下tag，刷新tableView，这个else 也可以注释不用，tag只记录选中的就可以
            [weakCell.selectedBtn.layer setBorderColor:KRGB(104, 173, 255,1.0).CGColor];
             [weakCell.selectedBtn setTitleColor:KRGB(104, 173, 255,1.0) forState:UIControlStateSelected ];
            [weakCell.selectedBtn setBackgroundColor:KRGB(20, 124, 255,1.0)];
            
            self.btnTag = btnTag;
            [self.tableView reloadData];
            // NSLog(@"#####%ld",(long)btnTag);
        }
    }];

    
    
    
//    if (cell.selectedBtn.tag == [selectModel.optionID integerValue])
//        cell.selectedBtn.selected = YES;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view         = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50*Height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    if (_currentSelectIndex != nil && _currentSelectIndex != indexPath) {
//        
//        MyExamTableViewCell  *cell = [tableView cellForRowAtIndexPath:_currentSelectIndex];
//        cell.selectedBtn.selected  = NO;
//         cell.selectedBtn.layer.borderColor  = ZmjColor(153, 153, 153).CGColor;
//    }
//    
//    MyExamTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    [cell.selectedBtn.layer setBorderColor:KRGB(104, 173, 255,1.0).CGColor];
//    cell.selectedBtn.selected = !cell.selectedBtn.selected;
//
//    _currentSelectIndex = indexPath;
//    if (self.SingleSelectBlock) {
//       NSLog(@"cell.selectedBtn.tag:%ld,%@",cell.selectedBtn.tag,self.questionId);
//        self.SingleSelectBlock(indexPath, cell.selectedBtn.tag,self.questionId);
//         }
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64)style:UITableViewStyleGrouped];
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate        = self;
        _tableView.dataSource      = self;
    }
    return _tableView;
}

- (MyExamHeaderView *)myExamHeaderView {
    if (!_myExamHeaderView) {
        _myExamHeaderView = [[MyExamHeaderView alloc]init];
    }
    return _myExamHeaderView;
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


        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setValue:self.typeIDNum forKey:@"typeID"];

   [HttpRequest POST:Url getToken:self.tokenStr paramentDict:dictionary success:^(id responseObj) {
       
               //请求成功返回数据；需要转化成字典（即json格式数据）
               NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves error:nil];
       
               //self.InfoDictionary =[NSMutableDictionary dictionaryWithDictionary:dict[@"content"][@"questionList"]];
     
       
               for (NSDictionary *obj in dict[@"content"][@"questionList"]) {
                    QuestionListModel *models=[[QuestionListModel alloc] initWithDict:obj];
                   [self.questionArr addObject:models];
                   //NSLog(@"%@,%@",models.questionID,models.questionName);
                   for (NSDictionary *obj in models.select) {
                       SelectModel *Model  =[[SelectModel alloc] initWithDict:obj];
                       [self.chooseArr addObject:Model];
                      // NSLog(@"%@,%@",Model.optionID,Model.option);
                   }
       
               }
               
               [self initView];
               [self initData];
       
   } failure:^(NSError *error) {
       NSLog(@"%@",error);
   }];

}














/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
