//
//  TierTableViewCell.h
//  BillingEstimateCalculator
//
//  Created by Christopher Winstanley on 16/05/2015.
//  Copyright (c) 2015 Winstanley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TierTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tierNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *priceArtefactPerMonthTextField;
@property (weak, nonatomic) IBOutlet UILabel *artefactMinLabel;
@property (weak, nonatomic) IBOutlet UITextField *artefactMaxTextField;
@property (weak, nonatomic) IBOutlet UILabel *artefactRangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *clientArtefactNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceTierPerMonthLabel;
@end
