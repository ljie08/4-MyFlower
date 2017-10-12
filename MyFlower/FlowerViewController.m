//
//  FlowerViewController.m
//  MyFlower
//
//  Created by ljie on 2017/8/18.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "FlowerViewController.h"
#import "CloudsView.h"
#import "Flower.h"

@interface FlowerViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *sunView;//太阳
@property (nonatomic, strong) CloudsView *cloudsView;//云
@property (weak, nonatomic) IBOutlet UIView *seedView;//种子坑
@property (weak, nonatomic) IBOutlet UIView *grassView;//草地
@property (weak, nonatomic) IBOutlet UILabel *flowerNumLab;//已种成的花
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *grassPadding;

@property (nonatomic, strong) NSTimer *countdownTimer;//倒计时
@property (nonatomic, strong) NSTimer *flowerTimer;//花儿成长
@property (nonatomic, strong) UILabel *hintLabel;//提示
@property (nonatomic, assign) NSInteger num;//5秒提示开始种
@property (nonatomic, strong) UIView *flowerSeed;//种子

@property (nonatomic, assign) int second;//倒计时-秒
@property (nonatomic, assign) int minute;//倒计时-分

@property (nonatomic, strong) UIImageView *flowerImg;//花

@property (nonatomic, assign) BOOL isForeground;//是否在前台

@end

@implementation FlowerViewController

#pragma mark - 生命周期
- (instancetype)init {
    if (self = [super init]) {
        _viewmodel = [[FlowerViewModel alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.num = 5;
    self.isForeground = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)goBackground {
    self.isForeground = NO;
    [self stopTimers];
}

- (void)enterForeground {
    self.isForeground = YES;
    [self setupAnimationSunAndClouds];
    
    [self backgroundColorAnimation];
    [self resetTimer];
}

//云朵view的初始位置在-375，在push或pop的时候会显示出这个视图。所以要避免push或pop的时候，显示出来云朵view，将要出现和将要消失时候设置透明度为0，已经出现透明度为1.
- (void)viewWillDisappear:(BOOL)animated {
    self.cloudsView.alpha = 0;
    [self stopTimers];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    self.cloudsView.alpha = 0;
    NSLog(@"flowerName -- %@", self.viewmodel.flowerName);
}

- (void)viewDidAppear:(BOOL)animated {
    self.cloudsView.alpha = 1;
}

- (void)saveDataIsPlant:(BOOL)isPlant {
    [self.viewmodel saveFlowersRecordWithSuccess:^(BOOL result) {
        if (result && isPlant) {
            [self setupAlertVC];
        }
    } failure:^(NSString *errorString) {
        NSLog(@"%@", errorString);
        [self showMassage:errorString];
    }];
}

#pragma mark - 定时器
//取消定时器
- (void)stopTimers {
    [self.countdownTimer setFireDate:[NSDate distantFuture]];
    [self.flowerTimer setFireDate:[NSDate distantFuture]];
}

//5s倒计时
- (void)countDownSecond {
    self.hintLabel.text = [NSString stringWithFormat:@"%ld %@", self.num, NSLocalizedString(@"countdown", nil)];
    self.hintLabel.hidden = NO;
    if (self.num > 0) {
        self.num--;
    } else {
        self.hintLabel.hidden = YES;
        [self stopTimers];
        [self seedDownAnimation];
    }
}

//生长时间3分钟计时
- (void)flowerGrowing {
    self.hintLabel.hidden = NO;
    //3分钟到了关闭定时器
    if (self.minute >= 3) {
        [self.flowerTimer setFireDate:[NSDate distantFuture]];
        
    } else {
        //计时，并让花儿变大
        if (self.second <= 59) {
            self.second++;
        } else {
            self.second = 0;
            if (self.minute < 3) {
                self.minute++;
            } else {
                self.minute = 3;
            }
        }
        NSString *secondStr = [NSString stringWithFormat:@"%d", self.second];
        if (self.second < 10) {
            secondStr = [NSString stringWithFormat:@"0%d", self.second];
        }
        self.hintLabel.text = [NSString stringWithFormat:@"0%d:%@", self.minute, secondStr];
    }
}

#pragma mark - UI
- (void)initUIView {
    [self setBackButton:YES];
    
    self.grassPadding.constant = 190 * Heigt_Scale;
    
    [self backgroundColorAnimation];
    
    [self setupAnimationSunAndClouds];
    [self setupOtherView];
    
    self.second = 0;
    self.minute = 0;
}

//倒计时view
- (void)setupOtherView {
    //提示信息label
    self.hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.sunView.frame)+70*Heigt_Scale, Screen_Width-20, 50*Heigt_Scale)];
    self.hintLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.hintLabel];
    
    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownSecond) userInfo:nil repeats:YES];
    
    //种子
    self.flowerSeed = [[UIView alloc] init];
    self.flowerSeed.backgroundColor = [LJUtil hexStringToColor:@"#5F3900"];
    self.flowerSeed.alpha = 0.0;
    [self.view addSubview:self.flowerSeed];
    [self.flowerSeed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hintLabel);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@4);
        make.height.equalTo(@6);
    }];
    
    //花儿
    self.flowerImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.viewmodel.flowerName]];
    self.flowerImg.frame = CGRectMake(0, 0, 5, 5);
    self.flowerImg.center = self.seedView.center;
    [self.grassView addSubview:self.flowerImg];
    self.flowerImg.alpha = 0.0;
}

- (void)setupFlower {
    //花儿
    self.flowerImg.image = [UIImage imageNamed:self.viewmodel.flowerName];
    self.flowerImg.alpha = 0.0;
    self.flowerImg.frame = CGRectMake(0, 0, 5, 5);
    self.flowerImg.center = self.seedView.center;
    
    self.flowerSeed.center = CGPointMake(Screen_Width/2, CGRectGetMaxY(self.hintLabel.frame));
}

- (void)setupAlertVC {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"planthint", nil) message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *flower1Action = [UIAlertAction actionWithTitle:NSLocalizedString(@"rose", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.viewmodel.flowerName = @"rose";
        [self resetTimer];
    }];
    
    UIAlertAction *flower2Action = [UIAlertAction actionWithTitle:NSLocalizedString(@"sunflower", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.viewmodel.flowerName = @"sunflower";
        [self resetTimer];
    }];
    
    UIAlertAction *flower3Action = [UIAlertAction actionWithTitle:NSLocalizedString(@"tulip", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.viewmodel.flowerName = @"tulip";
        [self resetTimer];
    }];
    
    [alert addAction:flower1Action];
    [alert addAction:flower2Action];
    [alert addAction:flower3Action];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 动画
//带有动画的太阳和云
- (void)setupAnimationSunAndClouds {
    //旋转的太阳
    CABasicAnimation *tAnimation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    tAnimation.fromValue = [NSNumber numberWithFloat:0.f];
    
    tAnimation.toValue =  [NSNumber numberWithFloat: M_PI *2];
    //旋转速度，数字越大旋转越慢
    tAnimation.duration  = 10;
    
    tAnimation.autoreverses = NO;
    
    tAnimation.fillMode =kCAFillModeForwards;
    
    tAnimation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    [self.sunView.layer addAnimation:tAnimation forKey:nil];
    
    self.cloudsView = [[CloudsView alloc] initWithFrame:CGRectMake(-Screen_Width, CGRectGetMinY(self.sunView.frame), Screen_Width, 130*Heigt_Scale)];
    
    [self.view addSubview:self.cloudsView];
    
    //移动的云
    CABasicAnimation *pAnimation =  [CABasicAnimation animationWithKeyPath:@"position"];
    
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    pAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(-Screen_Width/2, CGRectGetMidY(self.cloudsView.frame))];
    
    pAnimation.toValue =  [NSValue valueWithCGPoint:CGPointMake(Screen_Width*1.5, CGRectGetMidY(self.cloudsView.frame))];
    //旋转速度，数字越大旋转越慢
    pAnimation.duration  = 20;
    
    pAnimation.autoreverses = NO;
    
    pAnimation.fillMode =kCAFillModeForwards;
    
    pAnimation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    [self.cloudsView.layer addAnimation:pAnimation forKey:nil];
}

//种子下落动画
- (void)seedDownAnimation {
    self.flowerSeed.alpha = 1.0;
    
    self.flowerImg.frame = CGRectMake(0, 0, 5, 5);
    self.flowerImg.center = self.seedView.center;

    [UIView animateWithDuration:1.5f animations:^{
        self.flowerSeed.center = self.grassView.center;
        self.flowerSeed.alpha = 0.0;
        self.flowerImg.alpha = 1.0;
        
        self.flowerTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(flowerGrowing) userInfo:nil repeats:YES];
    } completion:^(BOOL finished) {
        if (self.isForeground) {
            [self flowerGrowingUpAnimation];
        }
    }];
}

//种子生长动画
- (void)flowerGrowingUpAnimation {
    //缩放
    CGFloat width = 170*Width_Scale;
    CGFloat y_padding = 190*Heigt_Scale/2-width/2;
    
    [UIView animateWithDuration:20 animations:^{
        self.flowerImg.frame = CGRectMake((Screen_Width-width)/2, y_padding-width/2, width, width);
        
    } completion:^(BOOL finished) {
        if (!self.isForeground) {
            return;
        }
        NSLog(@"长大了");
        //长大后，倒计时和花儿生长时间定时器都取消,提示信息label隐藏
        [self stopTimers];
        self.hintLabel.hidden = YES;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"finish", nil) message:NSLocalizedString(@"grownup", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"sure", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            //更新花朵数量，刚长成的花朵消失,并重新开始种花
            [self updateFlowerNumAndDismiss];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self saveDataIsPlant:NO];
            [self goBack];
        }];
        
        [alert addAction:cancelAction];
        [alert addAction:sureAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

//更新花朵数量，刚长成的花朵消失,并重新开始种花
- (void)updateFlowerNumAndDismiss {
    NSInteger number = [self.flowerNumLab.text integerValue];
    self.flowerNumLab.text = [NSString stringWithFormat:@"%ld", number+1];
    
    [UIView animateWithDuration:2.0f animations:^{
        self.flowerImg.frame = CGRectMake(self.flowerNumLab.center.x, self.flowerNumLab.center.y, 5, 5);;
        self.flowerImg.alpha = 0.0;
    } completion:^(BOOL finished) {
        //保存花
        [self saveDataIsPlant:YES];
    }];
}

//重置定时器和相关数据
- (void)resetTimer {
    NSLog(@"重新种了 -- %@", self.viewmodel.flowerName);
    self.hintLabel.hidden = YES;
    
    //消失后重新开启倒计时定时器，再一次种花，提示信息label显示,倒计时的分秒置为初始值
    self.second = 0;
    self.minute = 0;
    self.num = 5;
    [self setupFlower];
    
    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownSecond) userInfo:nil repeats:YES];
}

//背景色变化动画
-(void)backgroundColorAnimation{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    animation.toValue =(id) [LJUtil hexStringToColor:@"#EDE7AF"].CGColor;
    animation.duration = 3;
    animation.repeatCount = CGFLOAT_MAX;
    //F1E7D4
    //F7F5E9
    [self.view.layer addAnimation:animation forKey:@"backgroundAnimation"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
