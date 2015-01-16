//
//  EditNoteViewController.m
//  NoteApp
//
//  Created by Matt Maher on 1/9/15.
//  Copyright (c) 2015 Matt Maher. All rights reserved.
//

#import "EditNoteViewController.h"
#import "Note.h"
#import "AppDelegate.h"
#import "DataSource.h"
#import "ReadNoteViewController.h"

@interface EditNoteViewController ()

- (IBAction)saveEdit:(UIBarButtonItem *)sender;
- (IBAction)cancelEdit:(UIBarButtonItem *)sender;

@property (weak, nonatomic) IBOutlet UILabel *noteTitle;
@property (weak, nonatomic) IBOutlet UITextView *noteText;
@property (nonatomic, strong)NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong)NSFetchedResultsController *fetchedResultsController;

@end

@implementation EditNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *noteTitle = [NSString stringWithFormat:@"%@", _selectedNote.noteTitle];
    NSString *noteText = [NSString stringWithFormat:@"%@", _selectedNote.noteText];
    
    self.noteTitle.text = noteTitle;
    self.noteText.text = noteText;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveEdit:(UIBarButtonItem *)sender {
    _selectedNote.noteText = _noteText.text;
    [[DataSource sharedInstance] saveAndDismiss];
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)cancelEdit:(UIBarButtonItem *)sender {
    [[DataSource sharedInstance] cancelAndDismiss];
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end