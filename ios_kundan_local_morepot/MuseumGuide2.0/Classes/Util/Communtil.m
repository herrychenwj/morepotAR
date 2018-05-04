//
//  Communtil.m
//  PresentStyle
//
//  Created by Mr.Huang on 2017/2/24.
//  Copyright © 2017年 Mr.Huang. All rights reserved.
//

#import "Communtil.h"
#import <UIKit/UIKit.h>
#import "YYLabel.h"
#import "YYText.h"
#import "YYTextAttribute.h"
#import "YYTextContainerView.h"
#import <Reachability/Reachability.h>
#import <CommonCrypto/CommonDigest.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AFNetworking/AFNetworking.h>
#import <sys/utsname.h>
#import <AVFoundation/AVFoundation.h>
#import <SDWebImage/UIImage+MultiFormat.h>

@implementation Communtil
+ (BOOL)swapCheck {
    BOOL swapFlag = NO;
    if (([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) && ([[UIDevice currentDevice ] userInterfaceIdiom ] == UIUserInterfaceIdiomPad)) {
        swapFlag = YES;
    }
    return swapFlag;
}

+ (UIImage*) createImageWithColor:(UIColor*) color{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (CGFloat)yy_cellHeight:(NSAttributedString *)text
                   openSwitch:(BOOL)isOpen
                     maxWidth:(CGFloat)maxWidth
              maxCellHeight:(CGFloat)maxCellHeight{
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(maxWidth, MAXFLOAT)];
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:text];
    if (textLayout.textBoundingSize.height > maxCellHeight && !isOpen) {
        return  maxCellHeight;
    }
    return  textLayout.textBoundingSize.height;
}

+ (NSString *)stringWithTime:(NSTimeInterval)time {
    int minute = time / 60;
    int second = (int)time % 60;
    return [NSString stringWithFormat:@"%02d:%02d",minute,second];
}



+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

+ (NSString *)app_versionNumber{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)app_language{
//    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
//    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
//    NSString* preferredLang = [languages objectAtIndex:0];
    return  ([[TXSakuraManager getSakuraCurrentName] hasSuffix:@"en"])?@"en":@"cn";
}

+ (NSString *)app_deviceId{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

+ (NSString *)app_systemVersion{
    return [[UIDevice currentDevice] systemVersion];
}


+ (NSString *)app_networkType{
    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown:
            return @"unkonw";
            break;
        case AFNetworkReachabilityStatusNotReachable:
            return @"disable";
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            return @"4g";
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            return @"wifi";
            break;
        default:
            break;
    }
    return nil;
}

+ (id)readlocalJsonFile:(NSString *)filePath{
    if (!filePath) {
        return nil;
    }
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:filePath options:NSUTF8StringEncoding error:&error];
    if (!data) {
        return nil;
    }
    id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    return  error?nil:jsonObj;
}

#define CHUNK_SIZE 1024
+(NSString *)file_md5:(NSString*)path{
    NSFileHandle* handle = [NSFileHandle fileHandleForReadingAtPath:path];
    if(handle == nil)
        return nil;
    CC_MD5_CTX md5_ctx;
    CC_MD5_Init(&md5_ctx);
    NSData* filedata;
    do {
        filedata = [handle readDataOfLength:CHUNK_SIZE];
        CC_MD5_Update(&md5_ctx, [filedata bytes], [filedata length]);
    }
    while([filedata length]);
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(result, &md5_ctx);
    [handle closeFile];
    NSMutableString *hash = [NSMutableString string];
    for(int i=0;i<CC_MD5_DIGEST_LENGTH;i++){
        [hash appendFormat:@"%02x",result[i]];
    }
    return [hash lowercaseString];
}

+ (BOOL)isBlankString:(NSString *)string{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}


+ (void)playSound:(NSString *)fileName{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:fileName ofType:@"mp3"];
    SystemSoundID theSoundID;
    OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL URLWithString:filePath], &theSoundID);
    if (error == kAudioServicesNoError){
         AudioServicesPlaySystemSound(theSoundID);
    }else {
        NSLog(@"Failed to create sound ");
    }
}


+ (void)playDisplaySound{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:kUSERSETTING_SOUND] boolValue]) {
         [self playSound:kDISAPPER_SOUND];
    }
}

+ (void)playClickSound{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:kUSERSETTING_SOUND] boolValue]) {
        [self playSound:kBUTTON_VOICE];
    }
}

+ (void)playExhitbitSound{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:kUSERSETTING_SOUND] boolValue]) {
        [self playSound:kCLICK_SOUND];
    }
}


+ (BOOL)isLogin{
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:kACCESS_TOKEN];
    return (token != nil && token.length > 0);
}


+ (BOOL)hasARScan{
    return [[[NSUserDefaults standardUserDefaults]objectForKey:kMUSEUM_ARHAND] boolValue];
}


+ (NSString *)token{
    return [[NSUserDefaults standardUserDefaults]objectForKey:kACCESS_TOKEN];
}


+ (BOOL)validateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL )isWifi{
    return [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
}

+ (BOOL)localARResourceReady:(NSString *)museum_id savePath:(NSString *)savePath md5:(NSString *)md5Str{
    //本地存的md5值和传入的md5值一致
    BOOL md5eq = [[[NSUserDefaults standardUserDefaults]stringForKey:kARRESOURCE_MD5(museum_id)]isEqualToString:md5Str];
    if (!md5eq) {return NO;}
    BOOL is_dir = NO;

    //本地是否存在这个目录
    BOOL  dirExit =[[NSFileManager defaultManager]fileExistsAtPath:savePath isDirectory:&is_dir];
    if (md5eq && is_dir && dirExit) {
        return YES;
    }
    return NO;
}


+ (BOOL)app_firstlunching{
    return ![[NSUserDefaults standardUserDefaults]objectForKey:kAPPLICATION_FIRSTLAUNCHING];
}

+ (BOOL)app_welcome{
    return ![[NSUserDefaults standardUserDefaults]objectForKey:kAPPLICARION_WELCOME];
}

+ (float)calcDistByRSSI:(NSInteger)rssi{
    int iRssi = labs(rssi);
    float power = (iRssi-[@80 floatValue])/(10*[@2 floatValue]);
    return pow(10, power);
}


+ (NSString *)iphoneType {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return platform;
}

+ (NSTimeInterval)durationWithAudio:(NSString *)audioUrl{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:@(NO) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:audioUrl] options:opts]; // 初始化视频媒体文件
    NSTimeInterval second = 0;
    second = urlAsset.duration.value / urlAsset.duration.timescale; // 获取视频总时长,单位秒
    return second;
}

+ (BOOL)needToUpdateCheck:(NSString *)version{
    NSInteger curVersion = [self versionStringToValue:[self app_versionNumber]];
    NSInteger serverVersion = [self versionStringToValue:version];
    return serverVersion > curVersion;
}

+ (NSInteger)versionStringToValue:(NSString *)versionValue{
    NSArray *versionNum = [self addNumToVersionLength:[versionValue componentsSeparatedByString:@"."]];
    NSString *versionInt = [versionNum componentsJoinedByString:@""];
    return [versionInt integerValue];
}

+ (NSArray *)addNumToVersionLength:(NSArray *)tmp{
    if (tmp.count == 3) { //长度等于3 正好
        return tmp;
    }else if (tmp.count < 3){ //长度小于3
        NSMutableArray *ctmp = [NSMutableArray arrayWithArray:tmp];
        [ctmp addObject:@"0"];
        return [self addNumToVersionLength:[ctmp copy]];
    }else{ //长度大于3 严重不正常 取前三个值
        if (tmp && tmp.count > 3 ) {
            return @[tmp[0],tmp[1],tmp[2]];
        }else{
            return @[@"0",@"0",@"0"];
        }
    }
}


+ (NSString *)cleanString:(NSString *)searchStr{
    NSString * regExpStr = @"[。？！）（*&%￥#@“”：》《、， ]";
    NSString * replacement = @"哈哈";
    NSRegularExpression *regExp = [[NSRegularExpression alloc] initWithPattern:regExpStr
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];
    NSString *resultStr = searchStr;
    resultStr = [regExp stringByReplacingMatchesInString:searchStr
                                                 options:NSMatchingReportProgress
                                                   range:NSMakeRange(0, searchStr.length)
                                            withTemplate:replacement];
    return resultStr;
}


+ (BOOL)isNum:(NSString *)checkedNumString {
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(checkedNumString.length > 0) {
        return NO;
    }
    return YES;
}

+ (UIImage *)imageFromlocalpath:(NSString *)path{
    NSString *localpath = path.localPath;
    NSData *imgData = [NSData dataWithContentsOfFile:localpath];
    UIImage *img = [UIImage sd_imageWithData:imgData];
    return img;
}

+(NSString*)getCurrentDate{
    NSDate *currentDate = [NSDate date];
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
    return currentDateString;
}

+(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
@end
