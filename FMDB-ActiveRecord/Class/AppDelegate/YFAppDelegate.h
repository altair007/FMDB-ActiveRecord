//
//  YFAppDelegate.h
//  FMDB-ActiveRecord
//
//  Created by   颜风 on 14-6-20.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFAppDelegate : UIResponder <UIApplicationDelegate>

@property (retain, nonatomic) UIWindow *window;

/**
 *  显示一个含有特定消息的弹出视图.
 *
 *  @param message 信息.
 */
- (void) showAlertViewWithMessage: (NSString *) message;

@end
