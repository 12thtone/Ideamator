//
//  ReadNoteViewController.h
//  NoteApp
//
//  Created by Matt Maher on 1/9/15.
//  Copyright (c) 2015 Matt Maher. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Note;

@interface ReadNoteViewController : UIViewController 

@property (nonatomic, strong)Note *selectedNote;

@end
