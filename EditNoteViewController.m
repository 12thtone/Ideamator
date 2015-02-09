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

@interface EditNoteViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

- (IBAction)saveEdit:(UIBarButtonItem *)sender;
- (IBAction)cancelEdit:(UIBarButtonItem *)sender;

@property (weak, nonatomic) IBOutlet UILabel *noteTitle;
@property (weak, nonatomic) IBOutlet UITextView *noteText;
@property (weak, nonatomic) IBOutlet UIPickerView *editStatusPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *editStatusPickerPad;
@property (nonatomic, strong)NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong)NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, weak) NSArray *statusPhrases;
@property (nonatomic, weak) NSString *selectedStatus;

@end

@implementation EditNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *noteTitle = [NSString stringWithFormat:@"%@", _selectedNote.noteTitle];
    NSString *noteText = [NSString stringWithFormat:@"%@", _selectedNote.noteText];
    self.statusPhrases = [[DataSource sharedInstance] populateStatusArray];
    
    self.editStatusPicker.dataSource = self;
    self.editStatusPicker.delegate = self;
    self.editStatusPickerPad.dataSource = self;
    self.editStatusPickerPad.delegate = self;
    
    self.noteTitle.text = noteTitle;
    self.noteText.text = noteText;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.noteText endEditing:YES];
}

- (IBAction)saveEdit:(UIBarButtonItem *)sender {
    _selectedNote.noteText = _noteText.text;
    _selectedNote.noteTag = self.selectedStatus;
    [[DataSource sharedInstance] saveAndDismiss];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)cancelEdit:(UIBarButtonItem *)sender {
    [[DataSource sharedInstance] cancelAndDismiss];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Picker

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.statusPhrases count];
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.statusPhrases[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedStatus = self.statusPhrases[row];
    NSLog(@"Status is %@", self.selectedStatus);
}

@end