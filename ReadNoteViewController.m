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
#import "NoteTableViewController.h"

@interface ReadNoteViewController () <NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *noteLabel;
@property (nonatomic, strong)NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong)NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSString *noteTitle;
@property (nonatomic, strong) NSString *noteText;

- (IBAction)shareButton:(UIBarButtonItem *)sender;

@end

@implementation ReadNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"View is loading.");
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"SavoyeLetPlain" size:30],NSFontAttributeName, nil]];
    self.navigationItem.title = @"Read an Idea";
    
    _noteTitle = [NSString stringWithFormat:@"%@", _selectedNote.noteTitle];
    _noteText = [NSString stringWithFormat:@"%@", _selectedNote.noteText];
    
    self.titleLabel.text = _noteTitle;
    self.noteLabel.text = _noteText;
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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

#pragma mark - Sharing

- (IBAction)shareButton:(UIBarButtonItem *)sender {
    NSMutableArray *noteToShare = [NSMutableArray array];
    [noteToShare addObject:self.noteText];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:noteToShare applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
    
    if (UIActivityTypeMail) {
        [activityVC setValue:@"From The Ideamator" forKey:@"subject"];
        
    }
}

@end
