//
//  AddImageViewTableViewCell.m
//  LouYu
//
//  Created by barby on 2017/8/3.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "AddImageViewTableViewCell.h"


#import <MobileCoreServices/MobileCoreServices.h>
#import "STPhotoKitController.h"
#import "UIImagePickerController+ST.h"
#import "STConfig.h"

typedef NS_ENUM(NSInteger, PhotoType)
{
    PhotoTypeIcon,
    PhotoTypeRectangle,
    PhotoTypeRectangle1
};

@interface AddImageViewTableViewCell ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, STPhotoKitDelegate>
@property (nonatomic, assign) PhotoType type;

@end

@implementation AddImageViewTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageDaraArr=[NSMutableArray array];
        self.imageIcon =[[UIImageView alloc] initWithFrame:CGRectMake(20, 5, (KscreenWidth-80)/3, 80)];
        
        [self.imageIcon sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"btn_tianjiazhaopian.png"]];
        [self addSubview:self.imageIcon];
         [self.imageIcon setUserInteractionEnabled:YES];
        
        self.imageRectangle =[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageIcon.frame)+20, self.imageIcon.frame.origin.y, self.imageIcon.frame.size.width, self.imageIcon.frame.size.height)];
        
        [self.imageRectangle sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"btn_tianjiazhaopian.png"]];
        [self addSubview:self.imageRectangle];
        [self.imageRectangle setUserInteractionEnabled:YES];
        
        
        self.imageRectangle1 =[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageRectangle.frame)+20, self.imageIcon.frame.origin.y, self.imageIcon.frame.size.width, self.imageIcon.frame.size.height)];
        
        [self.imageRectangle1 sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"btn_tianjiazhaopian.png"]];
        [self addSubview:self.imageRectangle1];
         [self.imageRectangle1 setUserInteractionEnabled:YES];
        
        UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.imageIcon.frame)+10, KscreenWidth, 10)];
        [lineView setBackgroundColor:KRGB(235, 235, 235, 1.0f)];
        [self addSubview:lineView];

        UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectedIcon)];
        [self.imageIcon addGestureRecognizer:tap0];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectedRectangle)];
        [self.imageRectangle addGestureRecognizer:tap1];
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectedRectangle1)];
        [self.imageRectangle1 addGestureRecognizer:tap2];
        
    }
    return self;
}


- (void)selectedIcon
{
    self.type = PhotoTypeIcon;
    [self editImageSelected];
}

- (void)selectedRectangle{
    self.type = PhotoTypeRectangle;
    [self editImageSelected];
}

- (void)selectedRectangle1{
    self.type = PhotoTypeRectangle1;
    [self editImageSelected];
}
#pragma mark - --- delegate 视图委托 ---

#pragma mark - 1.STPhotoKitDelegate的委托

- (void)photoKitController:(STPhotoKitController *)photoKitController resultImage:(UIImage *)resultImage
{
    
    NSData *imageData=UIImagePNGRepresentation(resultImage);
    switch (self.type) {
        case PhotoTypeIcon:
            self.imageIcon.image = resultImage;
            [self.imageDaraArr addObject:imageData];
            break;
        case PhotoTypeRectangle:
            self.imageRectangle.image = resultImage;
            
        //NSData *imageData1=UIImagePNGRepresentation(resultImage);
            [self.imageDaraArr addObject:imageData];
            break;
        case PhotoTypeRectangle1:
            self.imageRectangle1.image = resultImage;
           // NSData *imageData2=UIImagePNGRepresentation(resultImage);
            [self.imageDaraArr addObject:imageData];
            break;
        default:
            break;
    }
    
    //NSLog(@"%@",self.imageDaraArr);
    //数据持久化
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:self.imageDaraArr forKey:@"KImagesArr"];
    //同步到本地
    [defaults synchronize];
    
}

#pragma mark - 2.UIImagePickerController的委托

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *imageOriginal = [info objectForKey:UIImagePickerControllerOriginalImage];
        STPhotoKitController *photoVC = [STPhotoKitController new];
        [photoVC setDelegate:self];
        [photoVC setImageOriginal:imageOriginal];

        switch (self.type) {
            case PhotoTypeIcon:
                [photoVC setSizeClip:CGSizeMake(KscreenWidth-50,KscreenWidth-50)];
                break;
            case PhotoTypeRectangle:
                [photoVC setSizeClip:CGSizeMake(KscreenWidth-50,KscreenWidth-50)];
                break;
            case PhotoTypeRectangle1:
                [photoVC setSizeClip:CGSizeMake(KscreenWidth-50,KscreenWidth-50)];
                break;
            default:
                break;
        }
        if (self.sendController) {
            self.sendController(photoVC);
        }
        
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
            
            
            if (self.sendController) {
                self.sendController(controller);
            }
        }else {
            NSLog(@"%s %@", __FUNCTION__, @"相机权限受限");
        }
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"从相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *controller = [UIImagePickerController imagePickerControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [controller setDelegate:self];
        if ([controller isAvailablePhotoLibrary]) {
            
            if (self.sendController) {
                self.sendController(controller);
            }
            
        }    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:action0];
    [alertController addAction:action1];
    [alertController addAction:action2];
    
    if (self.sendController) {
        self.sendController(alertController);
    }
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
