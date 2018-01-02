//
//  UserInfoModel.h
//  LouYu
//
//  Created by barby on 2017/7/20.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseModel.h"

@interface UserInfoModel : BaseModel

/*
 
 userID	string	用户ID，用作推送别名设置
 token	number	用户标识符
 mobile	string	用户手机号码
 thumb	string	用户头像
 typeID	number	用户所属组别ID
 jobNumber	string	用户工号
 roleID	number	用户身份ID
 trueName	string	用户真实姓名
 companyID	number	用户所属公司ID
 parentID	number	0为总公司1为分公司
 companyName	string	用户所属公司名称
 typeName	string	用户所属巡查组别名称
 userRoleInfo	string	用户所属巡查组别及身份名称
 */
@property(nonatomic,copy)NSString *userID;
@property(nonatomic,strong)NSNumber *token;
@property(nonatomic,copy)NSString *mobile;
@property(nonatomic,copy)NSString *thumb;
@property(nonatomic,strong)NSNumber *typeID;
@property(nonatomic,copy)NSString *jobNumber;
@property(nonatomic,copy)NSNumber *roleID;
@property(nonatomic,copy)NSString *truename;
@property(nonatomic,copy)NSNumber *companyID;
@property(nonatomic,copy)NSMutableArray *parentID;
@property(nonatomic,copy)NSString *companyName;
@property(nonatomic,copy)NSString *typeName;
@property(nonatomic,copy)NSString *userRoleInfo;


@end
