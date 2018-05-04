//
//  MuseumDef_h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/14.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#ifndef MuseumDef_h
#define MuseumDef_h



//#define kBASE_URL  @"https://api.morview.com/v2.1/"
//#define kBASEURL_WEBSITE @"https://museum.morview.com/"
////#define kBASE_URL @"http://106.14.239.47:8360/v2.1/"
////#define kBASEURL_WEBSITE @"http://106.14.239.47/"
//#define kPAYMENTURL @"https://payment.morview.com/"
//#define kALIPAYURL  kPAYMENTURL@"payment/alipay/purchase"
//#define kWXPAYURL  kPAYMENTURL@"payment/wechatpay/purchase"
//
//#define kIAPURL  kPAYMENTURL@"admin/base/iapConfig"
//
//
////advertising
//#define kADVERTISINGURL  kBASE_URL@"ads"
//
///**
// 首页博物馆列表
// */
//#define kMUSEUM_LIST   kBASE_URL@"museumList"
//
///**
// iBeacon信息
// */
//#define kMUSEUM_IBEACONINFO kBASE_URL@"museumiBeaconInfo"
//
///**
// AR资源包
// */
//#define kMUSEUM_ARRESOURCE  kBASE_URL@"museumARResource"
///**
// 博物馆地图信息
// */
//#define kMUSEUM_MAPINFO   kBASE_URL@"museumMapInfo"
///**
// 博物馆基本信息
// */
//#define kMUSEUM_INFO    kBASE_URL@"museumInfo"
///**
// 地图搜索
// */
//#define kMAP_SEARCH      kBASE_URL@"mapSearch"
//
///**
// 首页搜索
// */
//#define kHOME_SEARCH      kBASE_URL@"searchInfo"
///**
// 地图头部展品
// */
//#define kMAP_TOPEXHIBITIONS  kBASE_URL@"topExhibits"
///**
// 展品详情
// */
//#define kEXHIBIT_INFO  kBASE_URL@"exhibitInfo"
///**
// 展品评论列表
// */
//#define kEXHIBIT_COMMENTS  kBASE_URL@"exhibitComments"
///**
// 评论展品
// */
//#define kEXHIBIT_CMT kBASE_URL@"commentExhibit"
///**
// 展品点赞
// */
//#define kEXHIBIT_LIKE  kBASE_URL@"likeExhibit"
///**
// 展品收藏
// */
//#define kEXHIBIT_FAV kBASE_URL@"favoriteExhibit"
///**
// 展品收藏列表
// */
//#define kEXHIBIT_FAVORITES kBASE_URL@"favoriteExhibits"
///**
// 动态列表
// */
//#define kNEWS_LIST kBASE_URL@"newsList"
//
//
//#define kNEWS_DETAIL  kBASE_URL@"newsDetail"
///**
// 系统反馈
// */
//#define kSYSTEM_FEEDBACK kBASE_URL@"systemFeedback"
///**
// 登录
// */
//#define kLOGIN   kBASE_URL@"login"
//
///**
// 用户评论
// */
//#define kMY_COMMENTS kBASE_URL@"myComments"
//
//#define kUSER_CENTER kBASE_URL@"userCenter"
//
///**
// 修改头像
// */
//#define kEDIT_AVATAR  kBASE_URL@"editAvatar"
///**
// 修改昵称
// */
//#define kEDIT_NICKNAME  kBASE_URL@"editNickname"
///**
// 修改性别
// */
//#define kEDIT_SEX  kBASE_URL@"editSex"
///**
// 修改个性签名
// */
//#define kEDIT_SIGNAL  kBASE_URL@"editSignal"
///**
// 修改生日
// */
//#define kEDIT_BIRTH  kBASE_URL@"editBirth"
//
///**
// 绑定手机号
// */
//#define kBIND_PHONENUM  kBASE_URL@"bindPhonenum"
//
///**
// 评论点赞
// */
//#define kLIKE_COMMENT  kBASE_URL@"likeComment"



///**
// 根据GPS获取博物馆
// */
//#define kGPS_MUSEUM_LIST  kBASE_URL@"museumListByGPS"
//
//#define kMUSEUM_ALLEXHIBITS  kBASE_URL@"exhibits"
//
//#define kMUSEUM_REFRESHTOKEN  kBASE_URL@"refreshtoken"



//#define kPAYSUCCESS  @"MUSEUMPAYSUCCESS"

/**
 极光短信验证码获取地址
 */
//#define kJSMS_URL   @"https://api.sms.jpush.cn/v1/codes"


//#define kKuDanKey  @"klmp6+d1CD29WEornTpfFyrctpJbz11OIUown8eB++SWxPIYXLBQT7RdTg8dQnhqgmHxJCh1yRIKuyGkG14tcDmqb37PxLwI8qOZZYhxdblHy52WvVglh2eruzsxcvbe/DyRjNShaPQwbnjE1weWHNFzDS/YjDehRNMp+EVxLWNFlF8veThBOuYHctZ5fsbby2glfMZoZmLDS/kZNvQCPzLX6AXIJd5pGuHpEXZKgh4NPivRifIjmrYKtPvg6p5AeAjNBwQskci2c2mpSaffy+V9Yn/NsapjIrPsXWio8Go8JcFc/3Bs6DsHpxbGBB05jrbJWS/Isms1VBJHQq6HCzIdqMNItnp5bN5RwTuxeQwakp8Y7CRo/eS6XLJoH6ma0XEA6yjA5APXVc3PEMJ/AwjGNv8YDpBmA5NN93HEP2aO0VtWCixMEgqyLfw59EaGNMwRZq266PJfcN+TreHi7LQtPh3tnMS+AZ6g4QZLLnxW9Sw8vQ7WIKzC0UHV8+QdMjLrtvNhxLsfNm4CIE4cVtL3xy6yHXp5eIJWmDGVvBUhQQuEZkwubqIVytilMHxXtYF4px6uqX1dTfqZeVOl5hsjWYnRzWoeBRmwOsfukOdLPW8h8cn4iUeWSHXRSNb53yHYTyjeCkPMHYyZve8i2qypqum/5d3oNHk9Tt9PBMQ="



#endif /* MuseumDef_h */
