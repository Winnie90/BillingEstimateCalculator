//
//  DetailViewController.h
//  BillingEstimateCalculator
//
//  Created by Christopher Winstanley on 15/05/2015.
//  Copyright (c) 2015 Winstanley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bill+Management.h"
#import <MessageUI/MessageUI.h>

@interface BillDetailViewController : UIViewController <UIGestureRecognizerDelegate, UITextViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) Bill *selectedBill;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
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
@property (weak, nonatomic) IBOutlet UILabel *lastUpdatedLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *estimatedArtefactsTextField;
@property (weak, nonatomic) IBOutlet UITextField *duplicatesTextField;
@property (weak, nonatomic) IBOutlet UITextField *versionsTextField;
@property (weak, nonatomic) IBOutlet UILabel *totalUnitsLabel;
@property (weak, nonatomic) IBOutlet UILabel *removedArtefactsLabel;
@property (weak, nonatomic) IBOutlet UILabel *foldedVersionsLabel;

@property (weak, nonatomic) IBOutlet UILabel *pricePerMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *averagePricePerDrawingPerMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *pricePerYearLabel;

//edit tiers properties
@property (weak, nonatomic) IBOutlet UIButton *editTiersButton;

//update bill detail actions
- (IBAction)didUpdateBillName:(id)sender;
- (IBAction)didUpdateId:(id)sender;
- (IBAction)didUpdateEstimatedArtefacts:(id)sender;
- (IBAction)didUpdateDuplicates:(id)sender;
- (IBAction)didUpdateVersions:(id)sender;

// update company detail actions
- (IBAction)didUpdateCompanyName:(id)sender;
- (IBAction)didUpdateMobile:(id)sender;
- (IBAction)didUpdateEmail:(id)sender;
- (IBAction)didUpdatePhone:(id)sender;

//update tiers actions
- (IBAction)didSelectEditTiersButton:(id)sender;
- (IBAction)insertNewObject:(id)sender;

//get to resign view controller
- (IBAction)setNewTextField:(id)sender;
- (IBAction)textFieldFinished:(id)sender;
@end

