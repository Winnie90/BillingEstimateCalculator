//
//  BillDetailViewController.m
//  BillingEstimateCalculator
//
//  Created by Christopher Winstanley on 15/05/2015.
//  Copyright (c) 2015 Winstanley. All rights reserved.
//

#import "BillDetailViewController.h"
#import "Company+Management.h"
#import "Utils.h"

@interface BillDetailViewController ()

@end

@implementation BillDetailViewController

#pragma mark - Managing the detail item

- (void)setSelectedBill:(id)newDetailItem {
    if (_selectedBill != newDetailItem) {
        _selectedBill = (Bill*)newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    if (self.selectedBill) {
        [self setupBillDetails];
    }
}

- (void)setupBillDetails{
    self.dateLabel.text = [[Utils alloc] formatDatetoDateString:self.selectedBill.lastUpdated];
    self.billNameTextField.placeholder = self.selectedBill.name;
    self.titleTextField.placeholder = self.selectedBill.title;
    [self setupCustomerDetails];
}

-(void)setupCustomerDetails{
    self.customerIdTextField.placeholder = self.selectedBill.company.customerId;
    self.companyNameTextField.placeholder = self.selectedBill.company.name;
    self.addressTextField.placeholder = self.selectedBill.company.address;
    self.emailTextField.placeholder = self.selectedBill.company.email;
    self.mobileTextField.placeholder = self.selectedBill.company.mobile;
    self.phoneTextField.placeholder = self.selectedBill.company.phone;
}

-(void) updateBillDate{
    //TODO:
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
