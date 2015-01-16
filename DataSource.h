//
//  DataSource.h
//  NoteApp
//
//  Created by Matt Maher on 1/12/15.
//  Copyright (c) 2015 Matt Maher. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSource : NSObject

+(instancetype) sharedInstance;

- (void) cancelAndDismiss;

- (void) saveAndDismiss;

@end
