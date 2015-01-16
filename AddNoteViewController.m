//
//  AddNoteViewController.m
//  NoteApp
//
//  Created by Matt Maher on 1/9/15.
//  Copyright (c) 2015 Matt Maher. All rights reserved.
//

#import "AddNoteViewController.h"
#import "Note.h"
#import "DataSource.h"

@interface AddNoteViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *noteField;
- (IBAction)cancelNote:(UIBarButtonItem *)sender;
- (IBAction)saveNote:(UIBarButtonItem *)sender;

@end

@implementation AddNoteViewController

@synthesize addNote;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelNote:(UIBarButtonItem *)sender {
    [[DataSource sharedInstance] cancelAndDismiss];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveNote:(UIBarButtonItem *)sender {
    addNote.noteTitle = _titleField.text;
    addNote.noteText = _noteField.text;
    [[DataSource sharedInstance] saveAndDismiss];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
