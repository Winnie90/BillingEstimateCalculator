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
#import "TierTableViewCell.h"
#import "Tier+Management.h"

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

#pragma mark - Setup View

- (void)configureView {
    if (self.selectedBill) {
        [self setupBillDetails];
    }
}

- (void)setupBillDetails{
    self.dateLabel.text = [[Utils alloc] formatDatetoDateString:self.selectedBill.lastUpdated];
    self.billNameTextField.placeholder = self.selectedBill.name;
    self.titleTextField.placeholder = self.selectedBill.title;
    self.estimatedArtefactsTextField.placeholder = [[NSString alloc] initWithFormat:@"%d", [self.selectedBill.estimatedArtefacts intValue]];
    self.duplicatesTextField.placeholder = [[NSString alloc] initWithFormat:@"%d", (int)([self.selectedBill.duplicates floatValue]*100)];
    self.versionsTextField.placeholder = [[NSString alloc] initWithFormat:@"%d", (int)([self.selectedBill.versions floatValue]*100)];
    [self setupCustomerDetails];
    [self updateCalculations];
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

#pragma mark - Update Bill View

- (void)updateCalculations{
    self.removedArtefactsLabel.text = [[NSString alloc] initWithFormat: @"%d", [self.selectedBill removedArtefacts]];
    self.foldedVersionsLabel.text = [[NSString alloc] initWithFormat: @"%d", [self.selectedBill foldedInVersions]];
    self.totalUnitsLabel.text = [[NSString alloc] initWithFormat: @"%d", [self.selectedBill totalUnits]];
}

-(void) updateBillDate{
    self.selectedBill.lastUpdated = [NSDate date];
}

#pragma mark - Save Bill

- (void) updateBill{
    [self updateBillDate];
    NSLog(@"company saved");
    NSError* error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Couldn't save: %@, %@", [error localizedDescription], [error userInfo]);
    }
}

#pragma mark - Action Handlers

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

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TierTableViewCell *cell = (TierTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"TierCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)configureCell:(TierTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Tier *tier = (Tier*)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.tierNameLabel.text = [[NSString alloc] initWithFormat:@"Tier %ld", (long)indexPath.row+1];
    
    //get artefact per month from tier
    cell.priceArtefactPerMonthTextField.placeholder = [[NSString alloc] initWithFormat:@"%@", tier.priceArtefactPerMonth];
    
    //if tier has a lower tier
    if (!tier.lowerTier) {
        cell.artefactMinLabel.text = @"1 -";
    } else {
        cell.artefactMinLabel.text = [[NSString alloc] initWithFormat:@"%d -", [tier.lowerTier.artefactMax intValue]+1];
    }
    
    //get artefact max from tier
    cell.artefactMaxTextField.placeholder = [[NSString alloc] initWithFormat:@"%@", tier.artefactMax];
    
    //calculate in tier model
    cell.artefactRangeLabel.text = [[NSString alloc] initWithFormat:@"%d", [tier.artefactMax intValue] - [tier.lowerTier.artefactMax intValue]];
    
    //calculate num in tier model
    //cell.clientArtefactNumLabel.text = tier.clientArtefactNum;
    
    //calculate num in tier model
    //cell.priceTierPerMonthLabel.text = tier.priceTierPerMonth;
}


#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    // fetch tiers from the data store
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tier" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"bill == %@", self.selectedBill];
    [fetchRequest setPredicate:pred];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"artefactMax" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(TierTableViewCell*)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
