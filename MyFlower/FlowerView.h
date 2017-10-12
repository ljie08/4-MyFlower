//
//  FlowerView.h
//  MyFlower
//
//  Created by ljie on 2017/8/24.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlowerView : UIView

/**
 * 快速创建一个雪花飘落效果的view
 *
 * @param bgImageName 背景图片的名称
 * @param snowImageName 雪花图片的名称
 * @param frame frame
 *
 * @return 实例化的 雪花飘落效果的view
 */
+ (instancetype)snowflakesFallingViewWithBackgroundImageName:(NSString *)bgImageName snowImageName:(NSString *)snowImageName frame:(CGRect)frame;
/**
 开始下雪
 */
- (void)beginSnow;

@end
