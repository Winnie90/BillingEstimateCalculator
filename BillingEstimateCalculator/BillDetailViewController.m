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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

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
    self.addressTextView.text = self.selectedBill.company.address;
    self.addressTextView.delegate = self;
    self.emailTextField.placeholder = self.selectedBill.company.email;
    self.mobileTextField.placeholder = self.selectedBill.company.mobile;
    self.phoneTextField.placeholder = self.selectedBill.company.phone;
}

-(void) updateBillDate{
    self.selectedBill.lastUpdated = [NSDate date];
}

- (IBAction)didUpdateBillName:(id)sender {
    self.selectedBill.name = self.billNameTextField.text;
    [self updateBill];
}

- (IBAction)didUpdateId:(id)sender {
    self.selectedBill.company.customerId = self.customerIdTextField.text;
    [self updateBill];
}

- (IBAction)didUpdateCompanyName:(id)sender {
    self.selectedBill.company.name = self.companyNameTextField.text;
    [self updateBill];
}

- (IBAction)didUpdateMobile:(id)sender {
    self.selectedBill.company.mobile = self.mobileTextField.text;
    [self updateBill];
}

- (IBAction)didUpdateEmail:(id)sender {
    self.selectedBill.company.email = self.emailTextField.text;
    [self updateBill];
}

- (IBAction)didUpdatePhone:(id)sender {
    self.selectedBill.company.phone = self.phoneTextField.text;
    [self updateBill];
}

- (void)textViewDidChange:(UITextView *)textView{
    if(textView == self.addressTextView){
        self.selectedBill.company.address = self.addressTextView.text;
        [self updateBill];
    }
}

- (void) updateBill{
    [self updateBillDate];
    NSLog(@"company saved");
    NSError* error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Couldn't save: %@, %@", [error localizedDescription], [error userInfo]);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
