//
//  HHFrameworkAPI.h
//  HHTouchFramework
//
//  Created by caohuihui on 15/11/30.
//  Copyright © 2015年 caohuihui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHFrameworkAPI : NSObject

/**
 *  @brief  得到主视图
 *
 *  @return ViewController
 */
+(id)getMainViewController;

/**
 *  @brief  得到其他视图
 *
 *  @return ViewController
 */
+(id)getOtheViewController;

@end
