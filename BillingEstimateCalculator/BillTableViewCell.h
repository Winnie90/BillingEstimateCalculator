//
//  BillTableViewCell.h
//  BillingEstimateCalculator
//
//  Created by Christopher Winstanley on 15/05/2015.
//  Copyright (c) 2015 Winstanley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdatedLabel;

@end
