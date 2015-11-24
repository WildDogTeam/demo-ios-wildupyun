//
//  AddMesViewController.m
//  WilddogImg
//
//  Created by IMacLi on 15/11/20.
//  Copyright © 2015年 liwuyang. All rights reserved.
//

#import "AddMesViewController.h"
#import <Wilddog/Wilddog.h>
#import "UpYun.h"
#import "Utils.h"
#import "TestModel.h"
#import "TestService.h"


#define    UPYUN_IMG_DOMAIN @"http://liwimg.b0.upaiyun.com"
#define    WILDDOG_URL     @"https://upyun.wilddogio.com"

typedef void(^IMG_SUCCESS_BLOCK)(id result);
typedef void(^IMG_FAIL_BLOCK)(NSError * error);


@interface AddMesViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UITextView *contentTX;

@property (nonatomic, copy) IMG_SUCCESS_BLOCK   successBlocker;
@property (nonatomic, copy) IMG_FAIL_BLOCK      failBlocker;


@end

@implementation AddMesViewController
{
    Wilddog *_mWilddog;
    TestService *_testService;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _contentTX.layer.backgroundColor = [[UIColor clearColor] CGColor];
    _contentTX.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _contentTX.layer.borderWidth = 1.0;
    _contentTX.layer.cornerRadius = 8.0f;
    [_contentTX.layer setMasksToBounds:YES];

     _mWilddog = [[Wilddog alloc] initWithUrl:@"https://upyun.wilddogio.com"];
    _testService = [[TestService alloc] init];
    

}

- (IBAction)addMessege:(id)sender {
    
    [Utils showProgressHUdWithText:@"正在上传" showInView:self.view];
    
     [self upLoadImg:^(id result) {
         
         [Utils hidenProgressHUdshowInView:self.view];
         
         TestModel *model = [[TestModel alloc] init];
         model.imgUrl = result;
         model.title = self.titleTF.text;
         model.content = self.contentTX.text;
         
         model.timestamp = [[NSDate date] timeIntervalSince1970];
         model.noteID = [NSString stringWithFormat:@"%llu",model.timestamp];
         model.lastUpdate = model.timestamp;
         
         [_testService addNote:model];
         
     } andFail:^(NSError *error) {
         
         NSString *message = [error.userInfo objectForKey:@"message"];
         UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"error" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
         [alert show];
         
     }];

}

-(void)upLoadImg:(IMG_SUCCESS_BLOCK)successBlock andFail:(IMG_FAIL_BLOCK)failBlcok
{

    
    UpYun *uy = [[UpYun alloc] init];
    /**
     *	@brief	根据 UIImage 上传
     */
    NSString *imageName = [self getSaveKey];
    [uy uploadFile:self.imageView.image saveKey:imageName];

    uy.successBlocker = ^(id data)
    {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"上传成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        successBlock([NSString stringWithFormat:@"%@/%@",UPYUN_IMG_DOMAIN, imageName]);

    };
    uy.failBlocker = ^(NSError * error)
    {
        NSString *message = [error.userInfo objectForKey:@"message"];
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"error" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        failBlcok(error);
        
    };

}

-(NSString * )getSaveKey {
    
    /**
     *	@brief	方式1 由开发者生成saveKey
     */
    NSDate *d = [NSDate date];
    return [NSString stringWithFormat:@"/%d/%d/%.0f.jpg",[self getYear:d],[self getMonth:d],[[NSDate date] timeIntervalSince1970]];
    
}

- (int)getYear:(NSDate *) date{
    
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    int year= (int)[comps year];
    return year;
    
}

- (int)getMonth:(NSDate *) date{
    
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitMonth;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    int month = (int)[comps month];
    return month;
    
}


- (IBAction)addPhoto:(id)sender {

    [self hiddenKeyboard];
    
    UIActionSheet *sheet;
    // 判断是否支持相机
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
        
    }
    
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
        
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];
    
    
}
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:
                    // 取消
                    return;
                case 1:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                    
                case 2:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                
                return;
                
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.allowsEditing = YES;
        
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
        
    }
}


#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    /* 此处info 有六个值
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     */
//    image = [self scaleToSize:image size:CGSizeMake(100, 100)];
//    NSData *imageData = UIImageJPEGRepresentation(image, 1);
//    [self.imageView setImage:[UIImage imageWithData:imageData]];
    
    [self.imageView setImage:image];
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}


- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hiddenKeyboard];
    
}

-(void)hiddenKeyboard
{
    for (UIView *view in self.view.subviews) {
        
        if ([view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UITextView class]]) {
            
            [view resignFirstResponder];
            
        }
        
    }
 
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
