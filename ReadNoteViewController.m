//
//  ReadNoteViewController.m
//  NoteApp
//
//  Created by Matt Maher on 1/9/15.
//  Copyright (c) 2015 Matt Maher. All rights reserved.
//

#import "ReadNoteViewController.h"
#import "EditNoteViewController.h"
#import "AppDelegate.h"
#import "Note.h"

@interface ReadNoteViewController () <NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *noteLabel;
@property (nonatomic, strong)NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong)NSFetchedResultsController *fetchedResultsController;

@end

@implementation ReadNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"View is loading.");
    
    NSString *noteTitle = [NSString stringWithFormat:@"%@", _selectedNote.noteTitle];
    NSString *noteText = [NSString stringWithFormat:@"%@", _selectedNote.noteText];
    
    self.titleLabel.text = noteTitle;
    self.noteLabel.text = noteText;
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier]isEqualToString:@"editNote"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        
        //EditNoteViewController *editNoteViewController = (EditNoteViewController*) navigationController.topViewController;
        EditNoteViewController *editNoteViewController = (EditNoteViewController*) navigationController;
        //EditNoteViewController *editNoteViewController = (EditNoteViewController*) segue.destinationViewController;
        
        editNoteViewController.selectedNote = self.selectedNote;
        
    }
}

@end
