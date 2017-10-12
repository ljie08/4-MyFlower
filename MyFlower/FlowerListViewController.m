//
//  FlowerListViewController.m
//  MyFlower
//
//  Created by ljie on 2017/8/18.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "FlowerListViewController.h"
#import "FlowerCell.h"
#import "FlowerDetailViewController.h"

@interface FlowerListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *flowerTable;
@property (nonatomic, strong) NSMutableArray *flowerArr;//
@property (weak, nonatomic) IBOutlet UIButton *witherBtn;//凋谢的花
@property (weak, nonatomic) IBOutlet UIButton *aliveBtn;//还活着的花

@end

@implementation FlowerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"flowerlist", nil);
    
    self.flowerArr = [NSMutableArray array];
    
    //将原来种植的花取出来放数组
    NSString *listFile = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *listPath = [listFile stringByAppendingPathComponent:@"flower.plist"];
    self.flowerArr = [NSKeyedUnarchiver unarchiveObjectWithFile:listPath];
    if (self.flowerArr == nil) {
        self.flowerArr = [NSMutableArray new];
    }
    //倒序
    NSArray *arr = [self.flowerArr reverseObjectEnumerator].allObjects;
    self.flowerArr = (NSMutableArray *)arr;
    
    NSLog(@"%@",self.flowerArr);
}

- (void)viewWillAppear:(BOOL)animated {
    [self getData];
}

//提示语
- (IBAction)showHint:(UIButton *)button {
    if (button.tag == 10000) {
        [self showMassage:NSLocalizedString(@"withered", nil)];
    } else {
        [self showMassage:NSLocalizedString(@"alive", nil)];
    }
}

//获取凋谢的花
- (void)getData {
    NSMutableArray *witheredArr = [NSMutableArray array];
    NSMutableArray *aliveArr = [NSMutableArray array];
    if (self.flowerArr.count) {
        for (Flower *flower in self.flowerArr) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd";
            NSDate *flowerDate = [formatter dateFromString:flower.date];
            NSInteger days = [LJUtil getDaysFromNowToEnd:flowerDate];
            int day = (int)days;
            day = abs(day);
            if (day>6) {
                flower.isWithered = YES;
                [witheredArr addObject:flower];
            } else {
                flower.isWithered = NO;
                [aliveArr addObject:flower];
            }
        }
    }
    
    [self.flowerArr removeAllObjects];
    [self.flowerArr addObjectsFromArray:aliveArr];
    [self.flowerArr addObjectsFromArray:witheredArr];
    
    NSLog(@"witheredArr -- %ld", witheredArr.count);
    NSLog(@"aliveArr -- %ld", aliveArr.count);
    NSLog(@"flowerArr -- %ld", self.flowerArr.count);
    [self.witherBtn setTitle:[NSString stringWithFormat:@"%ld", witheredArr.count] forState:UIControlStateNormal];
    [self.aliveBtn setTitle:[NSString stringWithFormat:@"%ld", aliveArr.count] forState:UIControlStateNormal];
}

#pragma mark -- UI
- (void)initUIView {
    [self setBackButton:YES];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"colors"]];
    UIImage *image = [UIImage imageNamed:@"colors"];
    self.view.layer.contents = (id) image.CGImage;// 如果需要背景透明加上下面这句
    self.view.layer.backgroundColor = [UIColor clearColor].CGColor;
}

#pragma mark - table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.flowerArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FlowerCell *cell = [FlowerCell myCellWithTableview:tableView];
    Flower *flower = self.flowerArr[indexPath.section];
    [cell setCellDataWithFlower:flower];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FlowerDetailViewController *detail = [[FlowerDetailViewController alloc] init];
    detail.flower = self.flowerArr[indexPath.section];
    [self.navigationController pushViewController:detail animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
