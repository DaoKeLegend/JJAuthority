//
//  JJAuthorityManager.h
//  JJAuthority
//
//  Created by lucy on 2017/11/1.
//  Copyright © 2017年 com.daoKeLegend. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JJAuthorizationType) {
    JJAuthorizationTypeNotDetermined,       //未决定
    JJAuthorizationTypeDenied,              //拒绝
    JJAuthorizationTypeAllow                //允许
};

/**
     权限获取及请求
 */

@interface JJAuthorityManager : NSObject

/**
 检查权限
 */

//检查网络权限
+ (JJAuthorizationType)jj_checkNetworkAuthorization;

//检查相机权限
+ (JJAuthorizationType)jj_checkCameraAuthorization;

//检查相册权限
+ (JJAuthorizationType)jj_checkAlbumAuthorization;

//检查麦克风权限
+ (JJAuthorizationType)jj_checkMicrophoneAuthorization;

//检查定位权限
+ (JJAuthorizationType)jj_checkLocationAuthorization;

//检查通知权限
+ (void)jj_checkNotificationAuthorized:(void (^)(BOOL authorized))completion;


/**
 请求权限
 */

//打开设置授权视图
+ (void)jj_openAuthorizationView;

//获取相机权限
+ (void)jj_getCameraAuthorization:(void (^)(BOOL granted))completion;

//获取相册权限
+ (void)jj_getAlbumAuthorization:(void (^)(BOOL authorized))completion;

//获取麦克风权限
+ (void)jj_getMicrophoneAuthorization:(void (^)(BOOL granted))completion;

//获取通知权限
+ (void)jj_getNotificationAuthorization;

@end
