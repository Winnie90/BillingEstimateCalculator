//
//  DetailViewController.h
//  BillingEstimateCalculator
//
//  Created by Christopher Winstanley on 15/05/2015.
//  Copyright (c) 2015 Winstanley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bill+Management.h"

@interface BillDetailViewController : UIViewController <UITextViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) Bill *selectedBill;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextField *customerIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *billNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UITableView *tierTableView;
@property (weak, nonatomic) IBOutlet UITextField *estimatedArtefactsTextField;
@property (weak, nonatomic) IBOutlet UITextField *duplicatesTextField;
@property (weak, nonatomic) IBOutlet UITextField *versionsTextField;
@property (weak, nonatomic) IBOutlet UITextField *totalUnitsLabel;
@property (weak, nonatomic) IBOutlet UITextField *removedArtefactsLabel;
@property (weak, nonatomic) IBOutlet UITextField *foldedVersionsLabel;

- (IBAction)didUpdateBillName:(id)sender;
- (IBAction)didUpdateId:(id)sender;
- (IBAction)didUpdateCompanyName:(id)sender;
- (IBAction)didUpdateMobile:(id)sender;
- (IBAction)didUpdateEmail:(id)sender;
- (IBAction)didUpdatePhone:(id)sender;

@end

