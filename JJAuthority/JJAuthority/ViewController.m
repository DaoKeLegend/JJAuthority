//
//  ViewController.m
//  JJAuthority
//
//  Created by lucy on 2017/11/1.
//  Copyright © 2017年 com.daoKeLegend. All rights reserved.
//

#import "ViewController.h"
#import "JJAuthorityManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    //检查请求通知权限
    [JJAuthorityManager jj_checkNotificationAuthorized:^(BOOL authorized) {
        if (authorized) {
            NSLog(@"已经授权了");
        }
        else {
            [JJAuthorityManager jj_getNotificationAuthorization];
        }
    }];
    
    sleep(3);
    
    //检查相册权限
    JJAuthorizationType type = [JJAuthorityManager jj_checkAlbumAuthorization];
    
    if (type == JJAuthorizationTypeAllow) {
        NSLog(@"相册已经授权");
    }
    else{
        [JJAuthorityManager jj_getAlbumAuthorization:^(BOOL authorized) {
            if (authorized) {
                NSLog(@"相册获取授权成功");
            }
            else{
                NSLog(@"相册获取授权失败");
            }
        }];
    }
}

@end






