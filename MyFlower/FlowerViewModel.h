//
//  FlowerViewModel.h
//  MyFlower
//
//  Created by ljie on 2017/8/22.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlowerViewModel : NSObject

@property (nonatomic, strong) NSMutableArray *flowerArr;//花
@property (nonatomic, strong) NSString *flowerName;
@property (nonatomic, strong) Flower *model;

//将种植成功的花保存起来
- (void)saveFlowersRecordWithSuccess:(void (^)(BOOL result))success failure:(void (^)(NSString *errorString))failure;

@end
