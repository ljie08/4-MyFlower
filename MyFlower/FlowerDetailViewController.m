//
//  FlowerDetailViewController.m
//  MyFlower
//
//  Created by ljie on 2017/8/24.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "FlowerDetailViewController.h"
#import "FlowerView.h"

@interface FlowerDetailViewController ()

@end

@implementation FlowerDetailViewController

- (instancetype)init {
    if (self = [super init]) {
        _flower = [[Flower alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@", self.flower.flowerName);
}

- (void)initUIView {
    [self setBackButton:YES];
    //创建雪花飘落效果的view
    FlowerView *flower = [FlowerView snowflakesFallingViewWithBackgroundImageName:@"colors" snowImageName:@"sakura" frame:self.view.bounds];
    //开始下雪
    [flower beginSnow];
    [self.view addSubview:flower];
    
    [self setupFlowerview];
}

- (void)setupFlowerview {
    NSString *name;
    if (self.flower.isWithered) {
        name = [NSString stringWithFormat:@"%@_gray", self.flower.flowerName];
    } else {
        name = [NSString stringWithFormat:@"%@", self.flower.flowerName];
    }
    UIImageView *flower = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
    flower.frame = CGRectMake(0, 0, 100*Width_Scale, 100*Width_Scale);
    flower.center = CGPointMake(Screen_Width / 2, Screen_Height - 50 * Heigt_Scale - 100 * Width_Scale / 2);
    [self.view addSubview:flower];
    
    UILabel *dieLab = [[UILabel alloc] init];
    dieLab.textColor = FontColor;
    dieLab.numberOfLines = 0;
    dieLab.text = self.flower.isWithered?NSLocalizedString(@"die", nil):@"";
    [self.view addSubview:dieLab];
    [dieLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(flower.mas_right);
        make.centerY.equalTo(flower);
        make.height.equalTo(@40);
    }];

    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.text = [NSString stringWithFormat:@"%ld", self.flower.flowerNum];
    numLabel.textColor = MyColor;
    [self.view addSubview:numLabel];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(flower.mas_top).offset(-10);
        make.centerX.equalTo(self.view);
    }];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = NSLocalizedString(@"num", nil);
    label1.font = [UIFont systemFontOfSize:13];
    label1.textColor = MyColor;
    [self.view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(numLabel.mas_top).offset(-10);
        make.centerX.equalTo(self.view);
    }];
    
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.text = self.flower.date;
    dateLabel.textColor = MyColor;
    [self.view addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(label1.mas_top).offset(-10);
        make.centerX.equalTo(self.view);
    }];
    UILabel *label2 = [[UILabel alloc] init];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = NSLocalizedString(@"date", nil);
    label2.font = [UIFont systemFontOfSize:13];
    label2.textColor = MyColor;
    [self.view addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(dateLabel.mas_top).offset(-10);
        make.centerX.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
