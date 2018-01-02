//
//  SettingItemModel.h
//  xiu8iOS
//
//  Created by barby on 2017/8/3.
//  Copyright © 2017年 barby. All rights reserved.//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, SettingAccessoryType) {
    SettingAccessoryTypeNone,                   // don't show any accessory view
    SettingAccessoryTypeDisclosureIndicator,    // the same with system DisclosureIndicator
    SettingAccessoryTypeSwitch,                 //  swithch
    SetingAccesssoryTypeCenter,
};



@interface SettingItemModel : NSObject
@property (nonatomic,copy) NSString  *funcName;     /**<      功能名称*/
@property (nonatomic,strong) UIImage *img;          /**< 功能图片  */
@property (nonatomic,copy) NSString *detailText;    /**< 更多信息-提示文字  */
@property (nonatomic,strong) UIImage *detailImage;  /**< 更多信息-提示图片  */
@property (nonatomic,strong)UIImage *rigthImage;

@property (nonatomic,assign) SettingAccessoryType  accessoryType;    /**< accessory */
@property (nonatomic,copy) void (^executeCode)(void); /**<      点击item要执行的代码*/
@property (nonatomic,copy) void (^switchValueChanged)(BOOL isOn); /**<  SettingAccessoryTypeSwitch下开关变化 */

@end
