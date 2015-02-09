//
//  SearchTableViewController.h
//  NoteApp
//
//  Created by Matt Maher on 1/15/15.
//  Copyright (c) 2015 Matt Maher. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Note;

@interface NoteTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *noteList;
@property (nonatomic, strong) UISearchController *searchController;

@end
