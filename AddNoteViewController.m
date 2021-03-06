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
#import "AppDelegate.h"
#import "NoteTableViewController.h"

@interface AddNoteViewController () <UIDocumentPickerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *noteField;
@property (weak, nonatomic) IBOutlet UITextField *titleFieldPad;
@property (weak, nonatomic) IBOutlet UITextView *noteFieldPad;
@property (weak, nonatomic) IBOutlet UIPickerView *statusPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *statusPickerPad;

@property (nonatomic, weak) NSArray *statusPhrases;
@property (nonatomic, weak) NSString *selectedStatus;
@property (weak, nonatomic) IBOutlet UILabel *localizedNewIdeaLabel;
@property (weak, nonatomic) IBOutlet UILabel *localizedGoodIdeaLabel;
@property (weak, nonatomic) IBOutlet UILabel *localizedTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *localizedImportButton;

- (IBAction)cancelNote:(UIBarButtonItem *)sender;
- (IBAction)saveNote:(UIBarButtonItem *)sender;

@end

@implementation AddNoteViewController

@synthesize addNote;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (isPhone) {
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"SavoyeLetPlain" size:30],NSFontAttributeName, nil]];
        self.navigationItem.title = [NSString stringWithFormat:NSLocalizedString(@"Add an Idea", nil)];
    }
    
    self.localizedNewIdeaLabel.text = [NSString stringWithFormat:NSLocalizedString(@"New Idea:", nil)];
    self.localizedGoodIdeaLabel.text = [NSString stringWithFormat:NSLocalizedString(@"How Good is the Idea?", nil)];
    self.localizedTitleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"New Idea Title:", nil)];
    self.titleField.placeholder = [NSString stringWithFormat:NSLocalizedString(@"New Idea Title", nil)];
    
    [self.localizedImportButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"Import", nil)] forState:UIControlStateNormal];
    [self.localizedImportButton addTarget:self action:@selector(openImportDocumentPicker:) forControlEvents:UIControlEventTouchUpInside];
    
    self.statusPicker.dataSource = self;
    self.statusPicker.delegate = self;
    self.statusPickerPad.dataSource = self;
    self.statusPickerPad.delegate = self;
    
    self.statusPhrases = [[DataSource sharedInstance] populateStatusArray];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!isPhone) {
        self.preferredContentSize = CGSizeMake(800, 400);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSManagedObjectContext*)managedObjectContext {
    return [(AppDelegate*)[[UIApplication sharedApplication]delegate]managedObjectContext];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.noteField endEditing:YES];
    [self.titleField endEditing:YES];
    [self.noteFieldPad endEditing:YES];
    [self.titleFieldPad endEditing:YES];
}

- (IBAction)cancelNote:(UIBarButtonItem *)sender {
    [[DataSource sharedInstance] cancelAndDismiss];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveNote:(UIBarButtonItem *)sender {
    NSManagedObjectContext *context = [self managedObjectContext];
    self.addNote = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:context];
    if (isPhone) {
        addNote.noteTitle = _titleField.text;
        addNote.noteText = _noteField.text;
    } else {
        addNote.noteTitle = _titleFieldPad.text;
        addNote.noteText = _noteFieldPad.text;
    }
    
    addNote.noteTag = self.selectedStatus;
    
    [[DataSource sharedInstance] saveAndDismiss];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Importing Notes

- (void)openImportDocumentPicker:(id)sender {
    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.text"]
                                                                                                            inMode:UIDocumentPickerModeImport];
    documentPicker.delegate = self;
    documentPicker.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:documentPicker animated:YES completion:nil];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    if (controller.documentPickerMode == UIDocumentPickerModeImport) {
        NSString *alertMessage = [NSString stringWithFormat:NSLocalizedString(@"Successfully imported %@ as a note", nil), [url lastPathComponent]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:NSLocalizedString(@"Import", nil)
                                                  message:alertMessage
                                                  preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Ok", nil) style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        });
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        if (data) {
            NSLog(@"Data: %@", [NSString stringWithUTF8String:[data bytes]]);
            self.noteField.text = [NSString stringWithUTF8String:[data bytes]];
        } else {
            NSLog(@"Data is nil");
        }
    }
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
