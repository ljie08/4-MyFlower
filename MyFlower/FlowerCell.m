//
//  FlowerCell.m
//  MyFlower
//
//  Created by ljie on 2017/8/22.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "FlowerCell.h"

@interface FlowerCell ()

@property (weak, nonatomic) IBOutlet UIImageView *flowerView;
@property (weak, nonatomic) IBOutlet UILabel *flowerNum;
@property (weak, nonatomic) IBOutlet UILabel *flowerDate;

@end

@implementation FlowerCell


+ (instancetype)myCellWithTableview:(UITableView *)tableview {
    static NSString *cellid = @"FlowerCell";
    FlowerCell *cell = [tableview dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"FlowerCell" owner:nil options:nil].firstObject;
    }
    cell.backgroundColor = CellBgColor;
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 10;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)setCellDataWithFlower:(Flower *)flower {
    self.flowerView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", flower.flowerName]];
    self.flowerNum.text = [NSString stringWithFormat:@"%ld %@", flower.flowerNum, NSLocalizedString(@"duo", nil)];
    self.flowerDate.text = flower.date;
    if (flower.isWithered) {
        self.flowerView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_gray", flower.flowerName]];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
