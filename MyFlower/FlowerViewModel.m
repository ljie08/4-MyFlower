//
//  FlowerViewModel.m
//  MyFlower
//
//  Created by ljie on 2017/8/22.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "FlowerViewModel.h"

@implementation FlowerViewModel

- (instancetype)init {
    if (self = [super init]) {
        _flowerArr = [NSMutableArray array];
        _model = [[Flower alloc] init];
    }
    
    return self;
}

//将种植成功的花保存起来
- (void)saveFlowersRecordWithSuccess:(void (^)(BOOL result))success failure:(void (^)(NSString *errorString))failure {
    //每次保存的时候先将数组置为本地存储的数组，以防每次再进入种植界面的时候，数组已经初始化为nil，所以每次数组都是一个model
    NSString *listFile = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *listPath = [listFile stringByAppendingPathComponent:@"flower.plist"];
    [self.flowerArr removeAllObjects];
    self.flowerArr = [NSKeyedUnarchiver unarchiveObjectWithFile:listPath];
    if (self.flowerArr == nil) {
        self.flowerArr = [NSMutableArray new];
    }
    
    //当前时间和id
    NSString *currentDate = [LJUtil getCurrentTimes];
    NSString *currentFlowerId = [NSString stringWithFormat:@"%@%@", self.flowerName, currentDate];
    NSLog(@"currentFlowerId -- %@", currentFlowerId);
    
    //遍历数组，数组为空，直接将当前model保存
    //如果当前时间和当前花名都和model一样，则这个model的数量加1
    //如果只有一个一样，或都不一样，直接保存当前数据到model
    //数组里有
    //2017-08-10 -- rose 3朵，sunflower 5朵
    //2017-08-15 -- rose 1朵，tulip 3朵
    //当前种的是rose ，2017-08-23，名字相同，日期不同，则将这个rose对于8月23和数量为1赋值给self。model
    //如果数组里有id相同的，修改这个model的花朵数量。如果没有相同的，直接添加
    if (self.flowerArr.count) {
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.flowerArr];
        for (Flower *flower in tempArr) {
            NSString *flowerId = [NSString stringWithFormat:@"%@%@", flower.flowerName, flower.date];
            NSLog(@"flowerId -- %@", flowerId);
            
            if ([flowerId isEqualToString:currentFlowerId]) {
                self.model.flowerID = flower.flowerID;
                self.model.flowerName = flower.flowerName;
                self.model.flowerNum = flower.flowerNum+1;
                self.model.date = flower.date;
                NSInteger index = [self.flowerArr indexOfObject:flower];
                [self.flowerArr replaceObjectAtIndex:index withObject:self.model];
            } else {
                Flower *model = [[Flower alloc] init];
                model.flowerID = currentFlowerId;
                model.flowerName = self.flowerName;
                model.date = currentDate;
                model.flowerNum = 1;
                if (![self isContainsCurrentFlowerWithFlowerID:currentFlowerId]) {
                    [self.flowerArr addObject:model];
                }
            }
        }
    } else {
        self.model.flowerID = currentFlowerId;
        self.model.flowerName = self.flowerName;
        self.model.date = currentDate;
        self.model.flowerNum = 1;
        [self.flowerArr addObject:self.model];
        
    }
//    [self.flowerArr addObject:self.model];
    
    //将添加了model的数组归档 存到本地
    [NSKeyedArchiver archiveRootObject:self.flowerArr toFile:listPath];
    
    NSLog(@"flowerArr count -> %ld", self.flowerArr.count);
    
    NSMutableArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:listPath];
    NSLog(@"%@",arr);
    
    success(YES);
}

- (BOOL)isContainsCurrentFlowerWithFlowerID:(NSString *)flowerID {
    for (Flower *flower in self.flowerArr) {
        if ([flowerID isEqualToString:flower.flowerID]) {
            return YES;
        }
    }
    return NO;
}

@end
