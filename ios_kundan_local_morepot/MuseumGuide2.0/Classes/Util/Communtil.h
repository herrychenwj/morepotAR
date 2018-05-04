//
//  Communtil.h
//  PresentStyle
//
//  Created by Mr.Huang on 2017/2/24.
//  Copyright © 2017年 Mr.Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UShareUI/UShareUI.h>


@interface Communtil : NSObject

+ (UIImage *)imageFromlocalpath:(NSString *)path;

+(NSString*)DataTOjsonString:(id)object;
+(NSString*)getCurrentDate;
/**
 手势验证

 @return 是否可行
 */
+ (BOOL)swapCheck;

/**
 通过颜色创建图片

 @param color 颜色
 @return UIImage
 */
+ (UIImage*)createImageWithColor:(UIColor*) color;

+ (CGFloat)yy_cellHeight:(NSAttributedString *)text
                   openSwitch:(BOOL)isOpen
                     maxWidth:(CGFloat)maxWidth
               maxCellHeight:(CGFloat)maxCellHeight;


/**
 NSTimeInterval 转换字符串

 @param time 时间戳
 @return 字符串 00:00
 */
+ (NSString *)stringWithTime:(NSTimeInterval)time;



/**
 软件版本号

 @return 版本号
 */
+ (NSString *)app_versionNumber;

/**
 获取设备ID

 @return 获取deviceID
 */
+ (NSString *)app_deviceId;

/**
 获取设备语言 (除了英语的，其他语言全是中文)

 @return en 或 cn
 */
+ (NSString *)app_language;

/**
 系统版本号

 @return 版本号
 */
+ (NSString *)app_systemVersion;

/**
 网络链接状态

 @return wifi 或 4G
 */
+ (NSString *)app_networkType;

/**
 读取本地json 文件

 @param filePath 文件完整路径
 @return 文件内容
 */
+ (id)readlocalJsonFile:(NSString *)filePath;


/**
 文件MD5

 @param path 文件路径
 @return 文件MD5值
 */
+ (NSString *)file_md5:(NSString *)path;


/**
 检测字符串是否为空（包括null,nil,空格字符串）

 */
+ (BOOL)isBlankString:(NSString *)string;

/**
 验证字符串是否是数字
 
 @param string 字符串
 @return 是否是数字
 */
+ (BOOL)isPureInt:(NSString*)string;


///**
//  播放页面显示声音
// */
//+ (void)playDisplaySound;

/**
 播放按钮点击事件
 */
+ (void)playClickSound;



/**
 播放扫描到AR时的声音
 */
+ (void)playExhitbitSound;



/**
 是否登录

 @return 登录状态
 */
+ (BOOL)isLogin;

/**
 accesstoken
 */
+ (NSString *)token;


/**
 验证邮箱

 */
+ (BOOL)validateEmail:(NSString *)email;


/**
 是否是wifi
 
 */
+ (BOOL )isWifi;



/**
 判断本地是否有资源包或者资源包是否一致
 */
+ (BOOL)localARResourceReady:(NSString *)museum_id savePath:(NSString *)savePath md5:(NSString *)md5Str;



/**
 App是否第一次启动

 @return <#return value description#>
 */
+ (BOOL)app_firstlunching;

/**
 第一次启动后播放欢迎视频

 @return <#return value description#>
 */
+ (BOOL)app_welcome;


/**
 计算蓝牙距离

 @param rssi iBeacon信号强度
 @return 距离
 */
+ (float)calcDistByRSSI:(NSInteger)rssi;

+ (NSString *)iphoneType;

/**
 获取音频时长

 @param audioUrl 音频URL
 @return 时长
 */
+ (NSTimeInterval)durationWithAudio:(NSString *)audioUrl;


/**
 判断是否需要更新(版本中不能出现两位数,后两位最大为9)

 @param version 服务器版本
 @return 是否需要更新
 */
+ (BOOL)needToUpdateCheck:(NSString *)version;


/**
 判断是否第一次AR扫描
 */
+ (BOOL)hasARScan;

+ (NSString *)cleanString:(NSString *)searchStr;

+ (BOOL)isNum:(NSString *)checkedNumString;


@end
