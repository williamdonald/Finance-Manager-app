//
//  TransactionSummaryViewController.m
//  FinanceManager
//
//  Created by IIT CCT7 on 12/9/11.
//  Copyright 2011 IIT. All rights reserved.
//

#import "TransactionSummaryViewController.h"
#import "FinanceManagerAppDelegate.h"
#import "Item.h"
#import "TransactionSummaryCell.h"

@implementation TransactionSummaryViewController
@synthesize transactionItems,montharray,yearString;

#pragma mark -
#pragma mark View lifecycle

-(void) loadItemsFromDatabase:(NSString *)databasePath {
	sqlite3 *database;
	
	transactionItems = [[NSMutableArray alloc] init];
	
	if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		NSString *sqlStatement = @"SELECT * FROM Expenses";
		sqlite3_stmt *compiledStatement;
		NSLog(@"open: %s", sqlite3_errmsg(database));
		if (sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, nil) == SQLITE_OK) {
			NSLog(@"prepare: %s", sqlite3_errmsg(database));
			while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
				//reading data
				NSLog(@"stepping through: %@", [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)]);
				NSLog(@"stepping: %s %d", sqlite3_errmsg(database), sqlite3_errcode(database));
				int aIdent = sqlite3_column_int(compiledStatement, 0);
				NSString *aDescription = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
				NSString *aAmount = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
				NSString *aTag = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
				NSString *aDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
				//make menu item
				Item *item = [[Item alloc] initWithId:aIdent description:aDescription amount:aAmount tag:aTag date:aDate];
				[transactionItems addObject:item];
				[item release];
			}
			NSLog(@"done stepping: %s %d", sqlite3_errmsg(database), sqlite3_errcode(database));
		}
		sqlite3_finalize(compiledStatement);
		NSLog(@"closing: %s", sqlite3_errmsg(database));
	}
	sqlite3_close(database);
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	appDelegate = (FinanceManagerAppDelegate *)[[UIApplication sharedApplication] delegate];
	transactionItems = [appDelegate items];
	NSLog(@"no of items %d", [transactionItems count]);
	montharray= [[NSArray alloc] initWithObjects: @"01", @"02", @"03", @"04", @"05", @"06", @"07",@"08", @"09", @"10", @"11", @"12", nil];

	//Testing how to get current year
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"YYYY"];
	yearString = [formatter stringFromDate:[NSDate date]];
	NSLog(@"current year: %@",yearString);
	[formatter release];
	
	
	
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self setTitle:@"Monthly Expense Records"];
	[self.tableView reloadData];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [montharray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"TransactionSummaryCell";
    
    TransactionSummaryCell *cell =(TransactionSummaryCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TransactionSummaryCell" owner:nil options:nil];
		for (id currentObject in topLevelObjects) {
			if ([currentObject isKindOfClass:[TransactionSummaryCell class]]) {
				cell = (TransactionSummaryCell*)currentObject;
				break;
			}
		}
    }
    // Configure the cell...
	//Item  *expItem = (Item *)[transactionItems objectAtIndex:[indexPath row]]; 
	//[[cell textLabel] setText:[expItem month]];
	//NSString *month = [self getMonthText:[expItem month]];
	[[cell monthLabel] setText:[montharray objectAtIndex:indexPath.row]];
	[[cell yearLabel] setText:yearString];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

