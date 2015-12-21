//
//  ViewController.m
//  stupidTest
//
//  Created by Andrew Miller on 12/20/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "ListViewController.h"
#import "DetailViewController.h"

@interface ListViewController () <UITableViewDataSource, UITableViewDelegate>;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *titlesArray;
@property NSMutableArray *descriptionArray;

@end

@implementation ListViewController

#pragma mark - Upon Loading...
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titlesArray = [NSMutableArray new];
    self.descriptionArray = [NSMutableArray new];
    self.editing = false;
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - Helper Functions
-(void) presentDreamEntry
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Enter New Dream" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {textField.placeholder = @"Dream Title";
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {textField.placeholder = @"Dream Description";
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // what happens when the user selects save
        UITextField *textFieldOne = alertController.textFields[0];
        [self.titlesArray addObject:textFieldOne.text];
        
        UITextField *textFieldTwo = alertController.textFields[1];
        [self.descriptionArray addObject:textFieldTwo.text];
        
        [self.tableView reloadData];
        
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:saveAction];
    
    [self presentViewController:alertController animated:true completion:nil];
    
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // tell tableView how many rows to have
    return self.titlesArray.count;
};

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [self.titlesArray objectAtIndex:indexPath.row];
    
    return cell;
    
};

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES; // why yes here and not true?
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSString *titleItem = [self.titlesArray objectAtIndex:sourceIndexPath.row];
    [self.titlesArray removeObject:titleItem];
    [self.titlesArray insertObject:titleItem atIndex:destinationIndexPath.row];
    
    NSString *descriptionItem = [self.descriptionArray objectAtIndex:sourceIndexPath.row];
    [self.descriptionArray removeObject:descriptionItem];
    [self.descriptionArray insertObject:descriptionItem atIndex:destinationIndexPath.row];
    
    [tableView reloadData]; 
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.titlesArray removeObjectAtIndex:indexPath.row];
    [self.descriptionArray removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
};

#pragma mark - Nav Bar Button Methods
- (IBAction)onEditButtonTapped:(UIBarButtonItem *)sender
{
    
    if (self.editing)
    {
        self.editing = false;
        [self.tableView setEditing:false animated:true];
        sender.title = @"Edit";
        sender.style =  UIBarButtonItemStyleDone;
    }
    else
    {
        self.editing = true;
        [self.tableView setEditing:true animated:true];
        sender.title = @"Done";
        sender.style =  UIBarButtonItemStyleDone;
        
    }
    
}

- (IBAction)onAddButtonTapped:(UIBarButtonItem *)sender
{
    [self presentDreamEntry];
}

#pragma mark - Seque
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DetailViewController *detailVC = segue.destinationViewController;
    
    
    detailVC.titleString = [self.titlesArray objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    
    detailVC.descriptionString = [self.descriptionArray objectAtIndex:self.tableView.indexPathForSelectedRow.row];
}

@end
