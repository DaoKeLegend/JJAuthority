//
//  JJAuthorityManager.m
//  JJAuthority
//
//  Created by lucy on 2017/11/1.
//  Copyright © 2017年 com.daoKeLegend. All rights reserved.
//

#import "JJAuthorityManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreTelephony/CTCellularData.h>
#import <Photos/Photos.h>
#import <UserNotifications/UserNotifications.h>


@implementation JJAuthorityManager

//检查网络权限

+ (JJAuthorizationType)jj_checkNetworkAuthorization
{
    CTCellularData *cellularData = [[CTCellularData alloc] init];
    CTCellularDataRestrictedState state = cellularData.restrictedState;
    if (state == kCTCellularDataRestricted) {
        return JJAuthorizationTypeDenied;
    }
    else if (state == kCTCellularDataNotRestricted) {
        return JJAuthorizationTypeAllow;
    }
    else if (state == kCTCellularDataRestrictedStateUnknown) {
        return JJAuthorizationTypeNotDetermined;
    }
    return JJAuthorizationTypeAllow;
}

//检查相机权限

+ (JJAuthorizationType)jj_checkCameraAuthorization
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied){
        return JJAuthorizationTypeDenied;
    }
    else if (authStatus == ALAuthorizationStatusNotDetermined) {
        return JJAuthorizationTypeNotDetermined;
    }
    return JJAuthorizationTypeAllow;
}

//检查相册权限

+ (JJAuthorizationType)jj_checkAlbumAuthorization
{
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    if (authStatus == PHAuthorizationStatusAuthorized) {
        return JJAuthorizationTypeAllow;
    }
    else if (authStatus == PHAuthorizationStatusDenied) {
        return JJAuthorizationTypeDenied;
    }
    else if (authStatus == PHAuthorizationStatusNotDetermined) {
        return JJAuthorizationTypeNotDetermined;
    }
    else if (authStatus == PHAuthorizationStatusRestricted) {
        return JJAuthorizationTypeDenied;
    }
    return JJAuthorizationTypeAllow;
}

//检查麦克风权限

+ (JJAuthorizationType)jj_checkMicrophoneAuthorization
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];//麦克风权限
    if (authStatus == AVAuthorizationStatusAuthorized) {
        return JJAuthorizationTypeAllow;
    }
    else if (authStatus == AVAuthorizationStatusDenied) {
        return JJAuthorizationTypeDenied;
    }
    else if (authStatus == AVAuthorizationStatusNotDetermined) {
        return JJAuthorizationTypeNotDetermined;
    }
    else if (authStatus == AVAuthorizationStatusRestricted) {
        return JJAuthorizationTypeDenied;
    }
    return JJAuthorizationTypeAllow;
}

//检查定位权限

+ (JJAuthorizationType)jj_checkLocationAuthorization
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
        return JJAuthorizationTypeDenied;
    } else if (kCLAuthorizationStatusNotDetermined == status) {
        return JJAuthorizationTypeNotDetermined;
    }
    return JJAuthorizationTypeAllow;
}

//检查通知权限

+ (void)jj_checkNotificationAuthorized:(void (^)(BOOL authorized))completion
{
    if (!completion) {
        return;
    }
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0) {
        [[UNUserNotificationCenter currentNotificationCenter]
         getNotificationSettingsWithCompletionHandler:
         ^(UNNotificationSettings * _Nonnull settings) {
             completion(settings.authorizationStatus == UNAuthorizationStatusAuthorized);
         }];
    }
    else {
        completion([UIApplication sharedApplication].currentUserNotificationSettings.types != UIUserNotificationTypeNone);
    }
}

//打开设置授权视图

+ (void)jj_openAuthorizationView
{
    NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:settingURL]) {
        [[UIApplication sharedApplication] openURL:settingURL];
    }
}

//获取相机权限

+ (void)jj_getCameraAuthorization:(void (^)(BOOL granted))completion
{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (granted){
            NSLog(@"用户同意授权相机");
        }
        else {
            NSLog(@"用户拒绝授权相机");
        }
        if (completion) {
            completion(granted);
        }
    }];
}

//获取相册权限

+ (void)jj_getAlbumAuthorization:(void (^)(BOOL authorized))completion {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            NSLog(@"用户同意授权相册");
        }
        else {
            NSLog(@"用户拒绝授权相册");
        }
        if (completion) {
            completion(status == PHAuthorizationStatusAuthorized);
        }
    }];
}

// 获取麦克风权限

+ (void)jj_getMicrophoneAuthorization:(void (^)(BOOL granted))completion
{
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (granted) {
            NSLog(@"用户同意授权麦克风");
        }
        else{
            NSLog(@"用户拒绝授权麦克风");
        }
        if (completion) {
            completion(granted);
        }
    }];
}

//获取通知权限

+ (void)jj_getNotificationAuthorization
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            NSLog(@"%@",settings);
        }];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

@end




