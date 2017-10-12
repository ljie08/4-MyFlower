//
//  FlowerCell.h
//  MyFlower
//
//  Created by ljie on 2017/8/22.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlowerCell : UITableViewCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview;

- (void)setCellDataWithFlower:(Flower *)flower;

@end
