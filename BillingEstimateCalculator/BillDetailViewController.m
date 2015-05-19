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

@synthesize billNameTextField = _billNameTextField;

#pragma mark - Managing the detail item

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(!self.selectedBill){
        [self setSelectedBill:[[Bill alloc] retrieveLastUsedBill:self.managedObjectContext]];
    }
    [self configureView];
}

- (void)setSelectedBill:(id)newDetailItem {
    if (_selectedBill != newDetailItem) {
        _selectedBill = (Bill*)newDetailItem;
    }
}

#pragma mark - Setup View

- (void)configureView {
    if (self.selectedBill) {
        [self setupBillDetails];
        [self setupCustomerDetails];
        [self updateCalculations];
    }
}

- (void)setupBillDetails{
    self.dateLabel.text = [[Utils alloc] formatDatetoDateString:self.selectedBill.lastUpdated];
    self.billNameTextField.placeholder = self.selectedBill.name;
    self.titleTextField.placeholder = self.selectedBill.title;
    self.estimatedArtefactsTextField.placeholder = [[NSString alloc] initWithFormat:@"%d", [self.selectedBill.estimatedArtefacts intValue]];
    self.duplicatesTextField.placeholder = [[NSString alloc] initWithFormat:@"%d", (int)([self.selectedBill.duplicates floatValue]*100)];
    self.versionsTextField.placeholder = [[NSString alloc] initWithFormat:@"%d", (int)([_selectedBill.versions floatValue]*100)];
}

-(void)setupCustomerDetails{
    self.customerIdTextField.placeholder = self.selectedBill.company.customerId;
    self.companyNameTextField.placeholder = self.selectedBill.company.name;
    self.addressTextView.text = self.selectedBill.company.address;
    self.emailTextField.placeholder = self.selectedBill.company.email;
    self.mobileTextField.placeholder = self.selectedBill.company.mobile;
    self.phoneTextField.placeholder = self.selectedBill.company.phone;
}

#pragma mark - Update Bill View

// Kept calculations in the model to make view code cleaner,
// Could move into the view or cache results to reduce running calculations multiple times
- (void)updateCalculations{
    self.removedArtefactsLabel.text = [[NSString alloc] initWithFormat: @"%d", [self.selectedBill removedArtefacts]];
    self.foldedVersionsLabel.text = [[NSString alloc] initWithFormat: @"%d", [self.selectedBill foldedInVersions]];
    self.totalUnitsLabel.text = [[NSString alloc] initWithFormat: @"%d", [self.selectedBill totalUnits]];
    self.pricePerMonthLabel.text = [[NSString alloc] initWithFormat: @"$%.02f", [self.selectedBill pricePerMonth]];
    self.averagePricePerDrawingPerMonthLabel.text = [[NSString alloc] initWithFormat: @"$%.02f", [self.selectedBill averagePricePerDrawingPerMonth]];
    self.pricePerYearLabel.text = [[NSString alloc] initWithFormat: @"$%.02f", [self.selectedBill pricePerYear]];
    [self.tableView reloadData];
    [self updateBill];
}

-(void) updateBillDate{
    self.selectedBill.lastUpdated = [NSDate date];
}

- (void) updateBill{
    [self updateBillDate];
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

- (IBAction)didUpdateEstimatedArtefacts:(id)sender {
    self.selectedBill.estimatedArtefacts = [[NSNumber alloc] initWithInt:[self.estimatedArtefactsTextField.text intValue]];
    [self updateCalculations];
}

- (IBAction)didUpdateDuplicates:(id)sender {
    self.selectedBill.duplicates = [[NSNumber alloc] initWithFloat:[self.duplicatesTextField.text floatValue]/100];
    [self updateCalculations];
}

- (IBAction)didUpdateVersions:(id)sender {
    self.selectedBill.versions = [[NSNumber alloc] initWithFloat:[self.versionsTextField.text floatValue]/100];
    NSLog(@"versions %@", self.selectedBill.versions);
    [self updateCalculations];
}

- (void)textViewDidChange:(UITextView *)textView{
    if(textView == self.addressTextView){
        self.selectedBill.company.address = self.addressTextView.text;
        [self updateBill];
    }
}

- (IBAction)emailScreenshot:(id)sender {
    [self captureScreen];
}

#pragma mark - Send Screenshot

- (void) captureScreen {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData * data = UIImagePNGRepresentation(image);
    NSString* filePath = [self getFilepath];
    [data writeToFile:filePath atomically:YES];
    [self showEmail];
}

- (void)showEmail {
    // Email Subject
    NSString *emailTitle = @"Your RedEye Bill";
    // Email Content
    NSString *messageBody = [[NSString alloc] initWithFormat:@"Hi %@ \n\n Here is your latest bill. \n\n Thanks  \n\n The RedEye Team", self.selectedBill.company.name];
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:self.selectedBill.company.email];
    
    //create mail composer
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    NSString* filePath = [self getFilepath];
    //read the file using NSData
    NSData * fileData = [NSData dataWithContentsOfFile:filePath];
    // Set the MIME type
    NSString *mimeType = @"image/png";
    
    //add attachement
    [mc addAttachmentData:fileData mimeType:mimeType fileName:filePath];

    // present the view controller
    [self presentViewController:mc animated:YES completion:NULL];
}

-(NSString*) getFilepath{
    //get the filepath from resources
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
   return [documentsPath stringByAppendingPathComponent:@"screenshot.png"];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Table View Actions

- (IBAction)didSelectEditTiersButton:(id)sender {
    if (self.tableView.editing) {
        [self.editTiersButton setTitle:@"Edit Tiers" forState:UIControlStateNormal];
        [self.tableView setEditing:NO animated:NO];
    } else {
        [self.editTiersButton setTitle:@"Done" forState:UIControlStateNormal];
        [self.tableView setEditing:YES animated:YES];
    }
}

- (void)insertNewObject:(id)sender {
    // Create a new tier object and add it to the selected bill
    [self.selectedBill addTiersObject:[Tier tierWithLowerTier:[self.selectedBill getTierWithHighestArtefactMax] inManagedObjectContext:self.managedObjectContext]];
    // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext  save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [self updateCalculations];
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
        [self updateCalculations];
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
    cell.artefactRangeLabel.text = [[NSString alloc] initWithFormat:@"%d", tier.range];
    
    //calculate num in tier model
    cell.clientArtefactNumLabel.text = [[NSString alloc] initWithFormat:@"%d", tier.clientArtefactNum];
    
    //calculate num in tier model
    cell.priceTierPerMonthLabel.text = [[NSString alloc] initWithFormat:@"%.02f", tier.priceTierPerMonth];
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
