//
//  HomeViewController.m
//  MyFlower
//
//  Created by ljie on 2017/8/18.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "HomeViewController.h"
#import "FlowerViewController.h"
#import "FlowerListViewController.h"

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *flowerView;//旋转的花
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flowerPadding;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titlePadding;
@property (weak, nonatomic) IBOutlet UIImageView *bigFlower;
@property (weak, nonatomic) IBOutlet UIButton *plantBtn;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flowerWithAnimation) name:UIApplicationWillEnterForegroundNotification object:nil];
}

//直接写在这里，再app进入后台运行的时候，再回来，不会走willApear这个方法，所以加个通知，当app进入后台后，再返回app时，调用这个动画
//如果在initUI里写的话，pop回来就没有动画了
- (void)viewWillAppear:(BOOL)animated {
    //旋转的花
    [self flowerWithAnimation];
}

//种花
- (IBAction)plantFlower:(id)sender {
    FlowerViewController *flower = [[FlowerViewController alloc] init];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"planthint", nil) message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *flower1Action = [UIAlertAction actionWithTitle:NSLocalizedString(@"rose", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        flower.viewmodel.flowerName = @"rose";
        [self.navigationController pushViewController:flower animated:NO];
    }];
    
    UIAlertAction *flower2Action = [UIAlertAction actionWithTitle:NSLocalizedString(@"sunflower", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        flower.viewmodel.flowerName = @"sunflower";
        [self.navigationController pushViewController:flower animated:NO];
    }];
    
    UIAlertAction *flower3Action = [UIAlertAction actionWithTitle:NSLocalizedString(@"tulip", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        flower.viewmodel.flowerName = @"tulip";
        [self.navigationController pushViewController:flower animated:NO];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:flower1Action];
    [alert addAction:flower2Action];
    [alert addAction:flower3Action];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

//花的列表
- (void)gotoFlowerVC {
    FlowerListViewController *flower = [[FlowerListViewController alloc] init];
    [self.navigationController pushViewController:flower animated:YES];
}

#pragma mark - UI
- (void)initUIView {
    [self setNav];
    
    self.flowerPadding.constant = -Screen_Width/2.0;
    
    [self.titleLab.layer addAnimation:[self opacityForever_Animation:1.0f] forKey:nil];
     [self.bigFlower.layer addAnimation:[self scale:[NSNumber numberWithFloat:.5f] orgin:[NSNumber numberWithFloat:1.5f] durTimes:2.0f Rep:MAXFLOAT] forKey:nil];
    [self.plantBtn.layer addAnimation:[self opacityForever_Animation:.5f] forKey:nil];
    
    self.titlePadding.constant = 150*Heigt_Scale;
}

- (void)setNav {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 30, 30);
    [rightBtn setImage:[UIImage imageNamed:@"flower"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(gotoFlowerVC) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self addNavigationWithTitle:nil leftItem:nil rightItem:rightItem titleView:nil];
}

//旋转的花
- (void)flowerWithAnimation {
    CABasicAnimation *tAnimation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    tAnimation.fromValue = [NSNumber numberWithFloat:0.f];
    
    tAnimation.toValue =  [NSNumber numberWithFloat: M_PI *2];
    //旋转速度，数字越大旋转越慢
    tAnimation.duration  = 20;
    
    tAnimation.autoreverses = NO;
    
    tAnimation.fillMode = kCAFillModeForwards;
    
    tAnimation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    
    [self.flowerView.layer addAnimation:tAnimation forKey:nil];
}

#pragma mark =====缩放-=============
- (CABasicAnimation *)scale:(NSNumber *)Multiple orgin:(NSNumber *)orginMultiple durTimes:(float)time Rep:(float)repertTimes {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    animation.fromValue = Multiple;
    
    animation.toValue = orginMultiple;
    
    animation.autoreverses = YES;
    
    animation.repeatCount = repertTimes;
    
    animation.duration = time;//不设置时候的话，有一个默认的缩放时间.
    
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    return  animation;
}

#pragma mark === 永久闪烁的动画 ======
- (CABasicAnimation *)opacityForever_Animation:(float)time {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    
    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
    
    animation.autoreverses = YES;
    
    animation.duration = time;
    
    animation.repeatCount = MAXFLOAT;
    
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
    
    return animation;
}

#pragma mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
