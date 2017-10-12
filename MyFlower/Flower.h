//
//  Flower.h
//  MyFlower
//
//  Created by ljie on 2017/8/22.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Flower : NSObject

@property (nonatomic, copy) NSString *flowerID;//花ID
@property (nonatomic, copy) NSString *flowerName;//花名字
@property (nonatomic, copy) NSString *date;//种花时间
@property (nonatomic, assign) NSInteger flowerNum;//种花数量
@property (nonatomic, assign) BOOL isWithered;//是否凋谢 7天后凋谢

@end
