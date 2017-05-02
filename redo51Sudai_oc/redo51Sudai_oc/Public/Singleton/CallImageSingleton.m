//
//  CallImageSingleton.m
//  redo51Sudai_oc
//
//  Created by ZhongLiangLiang on 17/5/2.
//  Copyright © 2017年 zhongliangliang. All rights reserved.
//

#import "CallImageSingleton.h"

static CallImageSingleton *share = nil;

@implementation CallImageSingleton

// !!!: √ 单例
+ (CallImageSingleton *)shareInstance {
    //如果对象为空
    if(!share) {
        //创建对象
        share = [[CallImageSingleton alloc] init];
    }
    //返回当前对象
    return share;
}

// !!!: √ 调用照相机和相片
- (void)showCallImage:(UIViewController *)vc delegate:(id<CallImageDelegate>) aDelegate {
    share.delegate = aDelegate;
    dispatch_queue_t myQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(myQueue, ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //拍照
            [self readImageFromCamera:vc];
        }];
        UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //从相册中读取
            [self readImageFromAlbum:vc];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:cameraAction];
        [alertController addAction:albumAction];
        [alertController addAction:cancelAction];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
        });
    });
}

// !!!: √ 从相册中读取
- (void)readImageFromAlbum:(UIViewController *)vc {
    //创建对象
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    //（选择类型）表示仅仅从相册中选取照片
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //指定代理,因此我们要实现UIImagePickerControllerDelegate, UINavigationControllerDelegate协议
    imagePicker.delegate = self;
    //设置在相册选完照片后,是否跳到编辑模式进行图片剪裁。(允许用户编辑)
    imagePicker.allowsEditing = YES;
    //调用系统相片时有短暂停顿(解决)
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    //显示相册
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:imagePicker animated:YES completion:nil];
}

// !!!: √ 从相机拍摄中读取
- (void)readImageFromCamera:(UIViewController *)vc {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES; //允许用户编辑
        //调用系统相片时有短暂停顿(解决)
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:imagePicker animated:YES completion:nil];
    }
    else {
        //弹出窗口响应点击事件
        dispatch_queue_t myQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(myQueue, ^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告" message:@"未检测到摄像头" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alertController addAction:sure];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
            });
        });
    }
}

// !!!: √ 修改完相片出发事件 (选取完图片触发事件) UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    /**
     *  图片协议回调
     */
    if (self.delegate && [self.delegate respondsToSelector:@selector(callBackImage:)]) {
        [self.delegate callBackImage:image];
    }
}

@end
