//
//  Note.h
//  NoteApp
//
//  Created by Matt Maher on 1/9/15.
//  Copyright (c) 2015 Matt Maher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Note : NSManagedObject

@property (nonatomic, retain) NSString * noteTitle;
@property (nonatomic, retain) NSString * noteText;
@property (nonatomic, retain) NSString * noteTag;

@end
