//
//  AppDelegate.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/2/24.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic,assign)NSInteger arCount;

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,assign)NSInteger exShowCount;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;



@end

