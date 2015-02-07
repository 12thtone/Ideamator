//
//  SearchResultsTableViewController.m
//  NoteApp
//
//  Created by Matt Maher on 1/31/15.
//  Copyright (c) 2015 Matt Maher. All rights reserved.
//

#import "SearchResultsTableViewController.h"
#import "NoteTableViewController.h"
#import "Note.h"
#import "ReadNoteViewController.h"

@interface SearchResultsTableViewController()
@property (nonatomic, strong) ReadNoteViewController *readNoteVC;
@end

@implementation SearchResultsTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.searchController.searchBar setHidden:NO];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SearchResultCell" forIndexPath:indexPath];
    
    Note *note = [self.searchResults objectAtIndex:indexPath.row];
    
    cell.textLabel.text = note.noteTitle;
    cell.detailTextLabel.text = note.noteTag;
    
    return cell;
    
}
/*
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier]isEqualToString:@"readNote"]) {
        NSIndexPath *indexFilteredPath = [self.sea indexPathForSelectedRow];
        self.selectedFilteredNote = [self.searchResults objectAtIndex:indexFilteredPath.row];
        readNoteViewController.selectedNote = _selectedFilteredNote;
    }
}*/
/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Note *selectedNote = [self.searchResults objectAtIndex:indexPath.row];
    ReadNoteViewController *readNoteViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"ReadNoteViewController"];
    readNoteViewController.selectedNote = selectedNote;
    [self.presentingViewController.navigationController pushViewController:readNoteViewController animated:YES];
}
*/
/*
NSIndexPath *indexFilteredPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
self.selectedFilteredNote = [self.searchResults objectAtIndex:indexFilteredPath.row];
readNoteViewController.selectedNote = _selectedFilteredNote;
 */

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier]isEqualToString:@"fromSearchToRead"]) {
        //[self.searchController setActive:NO];
        [self.searchController.searchBar setHidden:YES];
        self.readNoteVC = [segue destinationViewController];
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Note *selectedNote = [self.searchResults objectAtIndex:indexPath.row];
    self.readNoteVC.selectedNote = selectedNote;
    
}

@end

