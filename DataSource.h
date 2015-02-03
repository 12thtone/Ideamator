//
//  DataSource.h
//  NoteApp
//
//  Created by Matt Maher on 1/12/15.
//  Copyright (c) 2015 Matt Maher. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Note, NoteTableViewController;

@interface DataSource : NSObject

+ (instancetype) sharedInstance;

@property (nonatomic, strong, readonly) NSArray *statusArray;
@property (nonatomic, strong) NSMutableArray *searchResults;

- (NSArray*) searchNotes:(NSString*)searchText notes:(NSMutableArray*)noteList;

- (NSArray *) populateStatusArray;

- (void) cancelAndDismiss;

- (void) saveAndDismiss;

@end
