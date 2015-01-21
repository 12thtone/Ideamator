//
//  SearchTableViewController.m
//  NoteApp
//
//  Created by Matt Maher on 1/15/15.
//  Copyright (c) 2015 Matt Maher. All rights reserved.
//

#import "NoteTableViewController.h"
#import "AppDelegate.h"
#import "Note.h"
#import "AddNoteViewController.h"
#import "ReadNoteViewController.h"
#import "DataSource.h"

@interface NoteTableViewController () <NSFetchedResultsControllerDelegate, UISearchDisplayDelegate, UISearchBarDelegate>

@property (nonatomic, strong)Note *note;
@property (nonatomic, retain) NSMutableArray *searchResults;
@property (nonatomic, retain) NSMutableArray *fixedResults;

@property (nonatomic, strong)NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong)NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) Note *selectedFilteredNote;
@property (nonatomic, strong) Note *selectedNote;

@end

@implementation NoteTableViewController

@synthesize searchResults;
@synthesize fixedResults;
@synthesize noteList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSManagedObjectContext*)managedObjectContext {
    return [(AppDelegate*)[[UIApplication sharedApplication]delegate]managedObjectContext];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSError *error = nil;
    
    if (![[self fetchedResultsController]performFetch:&error]) {
        NSLog(@"Error! %@", error);
        abort();
    }
    
    self.searchResults = [NSMutableArray arrayWithCapacity:[[self.fetchedResultsController fetchedObjects] count]];
    fixedResults = [NSMutableArray arrayWithCapacity:[[self.fetchedResultsController fetchedObjects] count]];
    [self.tableView reloadData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    self.searchResults = nil;
    self.fixedResults = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [[self.fetchedResultsController sections]count];
}
/*
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 {
 id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections]objectAtIndex:section];
 
 return [sectionInfo numberOfObjects];
 }
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [self.searchResults count];
    }
    else
    {
        //return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
        id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections]objectAtIndex:section];
        
        return [sectionInfo numberOfObjects];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    Note *note = nil;
    
    //if (tableView == self.searchDisplayController.searchResultsTableView)
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        note = [self.searchResults objectAtIndex:indexPath.row];
        NSLog(@"In the search");
        [fixedResults addObject:note.noteTitle];
    }
    else
    {
        //Note *note = [self.fetchedResultsController objectAtIndexPath:indexPath];
        note = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    
    cell.textLabel.text = note.noteTitle;
    
    //fixedResults = response.responseText;
    
    //fixedResults = [self.searchResults objectAtIndex:cell.textLabel.text];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier]isEqualToString:@"addNote"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        
        AddNoteViewController *addNoteViewController = (AddNoteViewController*) navigationController.topViewController;
        
        Note *addNote = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:[self managedObjectContext]];
        
        addNoteViewController.addNote = addNote;
    }
    
    if ([[segue identifier]isEqualToString:@"readNote"]) {
        
        ReadNoteViewController *readNoteViewController = segue.destinationViewController;
        
        if (self.searchResults.count != 0) {
            NSIndexPath *indexFilteredPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            self.selectedFilteredNote = [self.searchResults objectAtIndex:indexFilteredPath.row];
            readNoteViewController.selectedNote = _selectedFilteredNote;
        }
        else
        {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            self.selectedNote = [self.fetchedResultsController objectAtIndexPath:indexPath];
            readNoteViewController.selectedNote = _selectedNote;
        }
        /*
        ReadNoteViewController *readNoteViewController = (ReadNoteViewController*) segue.destinationViewController;
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        Note *selectedNote = (Note*)[self.fetchedResultsController objectAtIndexPath:indexPath];
        
        readNoteViewController.selectedNote = selectedNote;
         */
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Return NO if you do not want the specified item to be editable.
    
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSManagedObjectContext *context = [self managedObjectContext];
        
        Note *noteToDelete = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        [context deleteObject:noteToDelete];
        
        NSError *error = nil;
        
        if (![context save:&error]) {
            NSLog(@"Error! %@", error);
        }
    }
    
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

#pragma mark - Fetched Results Controller Section

- (NSFetchedResultsController*)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"noteTitle" ascending:YES];
    
    NSArray *sortDescriptors = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    
    fetchRequest.sortDescriptors = sortDescriptors;
    
    _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

#pragma mark - Fetched Results Controller Delegates

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate: {
            Note *changeNote = [self.fetchedResultsController objectAtIndexPath:indexPath];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.textLabel.text = changeNote.noteTitle;
        }
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
    }
}

#pragma mark - Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [self.searchResults removeAllObjects];
    noteList = [self.fetchedResultsController fetchedObjects].mutableCopy;
    self.searchResults = [[DataSource sharedInstance] searchNotes:(NSString*)searchText scope:(NSString*)scope notes:(NSMutableArray*)noteList].mutableCopy;
}

#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:@"All"];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:@"All"];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    // After a search, and after the Cancel button is pressed, the data in the first cell is displayed when any cell is touched.
    // [self viewDidLoad] fixes that.]
    [self viewDidLoad];
}

#pragma mark - Importing Notes

@end
