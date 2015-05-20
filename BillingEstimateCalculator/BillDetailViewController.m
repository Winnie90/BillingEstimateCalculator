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
    @property (weak, nonatomic) UITextField *currentTextField;
@end

@implementation BillDetailViewController

#pragma mark - Managing the detail item

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(!self.selectedBill){
        [self setSelectedBill:[[Bill alloc] retrieveLastUsedBill:self.managedObjectContext]];
    }
    [self configureView];
    [self setupGestureRecognizer];
}

- (void)setSelectedBill:(id)newDetailItem {
    if (_selectedBill != newDetailItem) {
        _selectedBill = (Bill*)newDetailItem;
    }
}

#pragma mark - Setup bill view methods

- (void)configureView {
    if (self.selectedBill) {
        [self setupBillDetails];
        [self setupCustomerDetails];
        [self updateCalculations];
    }
}

- (void)setupBillDetails{
    self.billNameTextField.placeholder = self.selectedBill.name;
    self.titleTextField.placeholder = self.selectedBill.title;
    self.estimatedArtefactsTextField.placeholder = [[NSString alloc] initWithFormat:@"%d", [self.selectedBill.estimatedArtefacts intValue]];
    self.duplicatesTextField.placeholder = [[NSString alloc] initWithFormat:@"%d", (int)([self.selectedBill.duplicates floatValue]*100)];
    self.versionsTextField.placeholder = [[NSString alloc] initWithFormat:@"%d", (int)([self.selectedBill.versions floatValue]*100)];
    self.dateLabel.text = [[Utils getInstance] formatDateToDateString:self.selectedBill.lastUpdated];
    self.lastUpdatedLabel.text = [[NSString alloc] initWithFormat:@"Last Updated: %@", [[Utils getInstance] formatDateToDateTimeString:self.selectedBill.lastUpdated]];
}

-(void)setupCustomerDetails{
    self.customerIdTextField.placeholder = self.selectedBill.company.customerId;
    self.companyNameTextField.placeholder = self.selectedBill.company.name;
    self.addressTextView.text = self.selectedBill.company.address;
    self.emailTextField.placeholder = self.selectedBill.company.email;
    self.mobileTextField.placeholder = self.selectedBill.company.mobile;
    self.phoneTextField.placeholder = self.selectedBill.company.phone;
}

#pragma mark - Update bill view methods

// Kept calculations in the model to make viewcontroller code cleaner,
// Could cache results to reduce running calculations multiple times
- (void)updateCalculations{
    self.removedArtefactsLabel.text = [[NSString alloc] initWithFormat: @"%d", [self.selectedBill removedArtefacts]];
    self.foldedVersionsLabel.text = [[NSString alloc] initWithFormat: @"%d", [self.selectedBill foldedInVersions]];
    self.totalUnitsLabel.text = [[NSString alloc] initWithFormat: @"%d", [self.selectedBill totalUnits]];
    self.pricePerMonthLabel.text = [[NSString alloc] initWithFormat: @"$%.02f", [self.selectedBill pricePerMonth]];
    self.averagePricePerDrawingPerMonthLabel.text = [[NSString alloc] initWithFormat: @"$%.02f", [self.selectedBill averagePricePerDrawingPerMonth]];
    self.pricePerYearLabel.text = [[NSString alloc] initWithFormat: @"$%.02f", [self.selectedBill pricePerYear]];
    [self updateBill];
}

- (void) updateBillDate{
    self.selectedBill.lastUpdated = [NSDate date];
    self.lastUpdatedLabel.text = [[NSString alloc] initWithFormat:@"Last Updated: %@", [[Utils getInstance] formatDateToDateTimeString:self.selectedBill.lastUpdated]];
}

- (void) updateBill{
    [self updateBillDate];
    NSError* error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Couldn't save: %@, %@", [error localizedDescription], [error userInfo]);
    }
    [self.tableView reloadData];
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

- (IBAction)didUpdatePhone:(id)sender {
    self.selectedBill.company.phone = self.phoneTextField.text;
    [self updateBill];
}

- (IBAction)didUpdateEmail:(id)sender {
    if ([[Utils getInstance] isValidEmailAddress:self.emailTextField.text]) {
        self.selectedBill.company.email = self.emailTextField.text;
        [self updateBill];
    } else {
        [self errorAlert:@"Incorrect Email" message:@"The email address you entered wasn't valid"];
        self.emailTextField.text = self.selectedBill.company.email;
    }
}

- (IBAction)didUpdateEstimatedArtefacts:(id)sender {
    if ([[Utils getInstance] isValidNumber:self.estimatedArtefactsTextField.text]) {
        self.selectedBill.estimatedArtefacts = [[NSNumber alloc] initWithInt:[self.estimatedArtefactsTextField.text intValue]];
        [self updateCalculations];
    } else {
        [self errorAlert:@"Incorrect Number" message:@"The estimated artefacts text you entered wasn't a valid number"];
        self.estimatedArtefactsTextField.text = [[NSString alloc] initWithFormat:@"%@", self.selectedBill.estimatedArtefacts];
    }
}

- (IBAction)didUpdateDuplicates:(id)sender {
    if ([[Utils getInstance] isValidNumber:self.duplicatesTextField.text] && [self.duplicatesTextField.text floatValue]<=100.0) {
        self.selectedBill.duplicates = [[NSNumber alloc] initWithFloat:[self.duplicatesTextField.text floatValue]/100];
        [self updateCalculations];
    } else {
        [self errorAlert:@"Incorrect Number" message:@"The duplicates text you entered wasn't a valid number. It must be less than 100%."];
        self.duplicatesTextField.text = [[NSString alloc] initWithFormat:@"%@", self.selectedBill.duplicates];
    }
}

- (IBAction)didUpdateVersions:(id)sender {
    if ([[Utils getInstance] isValidNumber:self.versionsTextField.text] && [self.versionsTextField.text floatValue]<=100.0) {
        self.selectedBill.versions = [[NSNumber alloc] initWithFloat:[self.versionsTextField.text floatValue]/100];
        [self updateCalculations];
    } else {
        [self errorAlert:@"Incorrect Number" message:@"The versions text you entered wasn't a valid number. It must be less than 100%."];
        self.versionsTextField.text = [[NSString alloc] initWithFormat:@"%@", self.selectedBill.versions];
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    if(textView == self.addressTextView){
        self.selectedBill.company.address = self.addressTextView.text;
        [self updateBill];
    }
}

- (IBAction)emailScreenshot:(id)sender {
    [self captureScreenshot];
}

-(void)errorAlert:(NSString*)title message:(NSString*)message{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action") style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Tier table View Actions

- (IBAction)didSelectEditTiersButton:(id)sender {
    //switch the editing state of the table view
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
    [self updateCalculations];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:textField.tag inSection:0];
    TierTableViewCell *cell = (TierTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    
    if(textField == cell.priceArtefactPerMonthTextField){
        if ([[Utils getInstance] isValidNumber:cell.priceArtefactPerMonthTextField.text] && [cell.priceArtefactPerMonthTextField.text floatValue] >=0.0) {
            cell.tier.priceArtefactPerMonth = [[NSNumber alloc] initWithFloat:[cell.priceArtefactPerMonthTextField.text floatValue]];
        } else {
            [self errorAlert:@"Incorrect Number" message:@"The price artefact per month text you entered wasn't a valid number. It must be greater than or equal to 0."];
            cell.priceArtefactPerMonthTextField.text = [[NSString alloc] initWithFormat:@"$%.02f", [cell.tier.priceArtefactPerMonth floatValue]];
        }
    } else if (textField == cell.artefactMaxTextField){
        if ([[Utils getInstance] isValidNumber:cell.artefactMaxTextField.text] && [cell.artefactMaxTextField.text intValue] > 1) {
            cell.tier.artefactMax = [[NSNumber alloc] initWithInt:[cell.artefactMaxTextField.text intValue]];
        } else {
            [self errorAlert:@"Incorrect Number" message:@"The price artefact per month text you entered wasn't a valid number. It must be greater than or equal to 0."];
            cell.artefactMaxTextField.text = [[NSString alloc] initWithFormat:@"%@", cell.tier.artefactMax];
        }
    }
    
    [self updateCalculations];
}

#pragma mark - Tier table view creation methods

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

- (void)configureCell:(TierTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Tier *tier = (Tier*)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.tierNameLabel.text = [[NSString alloc] initWithFormat:@"Tier %ld", (long)indexPath.row+1];
    
    //get artefact per month from tier
    cell.priceArtefactPerMonthTextField.placeholder = [[NSString alloc] initWithFormat:@"$%.02f", [tier.priceArtefactPerMonth floatValue]];
    cell.priceArtefactPerMonthTextField.tag = indexPath.row;
    
    //if tier has a lower tier
    if (!tier.lowerTier) {
        cell.artefactMinLabel.text = @"1 -";
    } else {
        cell.artefactMinLabel.text = [[NSString alloc] initWithFormat:@"%d -", [tier.lowerTier.artefactMax intValue]+1];
    }
    
    //get artefact max from tier
    cell.artefactMaxTextField.placeholder = [[NSString alloc] initWithFormat:@"%@", tier.artefactMax];
    cell.artefactMaxTextField.tag = indexPath.row;
    
    //calculate in tier model
    cell.artefactRangeLabel.text = [[NSString alloc] initWithFormat:@"%d", tier.range];
    
    //calculate num in tier model
    cell.clientArtefactNumLabel.text = [[NSString alloc] initWithFormat:@"%d", tier.clientArtefactNum];
    
    //calculate num in tier model
    cell.priceTierPerMonthLabel.text = [[NSString alloc] initWithFormat:@"$%.02f", tier.priceTierPerMonth];
    
    cell.tier = tier;
}

#pragma mark - Tier table view editing methods

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        [self.selectedBill refreshTiers];
        [self updateCalculations];
    }
}

#pragma mark - Fetched results controller methods

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

#pragma mark - Send screenshot methods

- (void) captureScreenshot {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]){
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
    } else {
        UIGraphicsBeginImageContext(self.view.bounds.size);
    }
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
    [mc addAttachmentData:fileData mimeType:mimeType fileName:[[NSString alloc] initWithFormat:@"%@-RedEyeBill-%@", self.selectedBill.company.name, [[Utils getInstance] formatDateToDateString:self.selectedBill.lastUpdated]]];
    
    // present the view controller
    [self presentViewController:mc animated:YES completion:NULL];
}

-(NSString*) getFilepath{
    //get the filepath from resources
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //Get the docs directory
    NSString *documentsPath = [paths objectAtIndex:0];
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
    if (error) {
        [self errorAlert:@"Mail sent failure" message:[[NSString alloc] initWithFormat:@"%@", [error localizedDescription]]];
    }
}

#pragma mark Text field methods

- (void)setupGestureRecognizer{
    //tap gesture recognizer to hide keyboard
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(hideKeyBoard)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)hideKeyBoard {
    [self.currentTextField resignFirstResponder];
    [self.addressTextView resignFirstResponder];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.tableView]) {
        return NO;
    }
    return YES;
}

- (IBAction)setNewTextField:(id)sender{
    UITextField *textField = (UITextField*)sender;
    self.currentTextField = textField;
}

- (IBAction)textFieldFinished:(id)sender
{
    [sender resignFirstResponder];
}

#pragma mark Memory warning methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
