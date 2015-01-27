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

@interface AddNoteViewController () <UIDocumentPickerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *noteField;
@property (weak, nonatomic) IBOutlet UITextField *titleFieldPad;
@property (weak, nonatomic) IBOutlet UITextView *noteFieldPad;

- (IBAction)cancelNote:(UIBarButtonItem *)sender;
- (IBAction)saveNote:(UIBarButtonItem *)sender;
- (IBAction)openImportDocumentPicker:(id)sender;

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
    if (isPhone) {
        addNote.noteTitle = _titleField.text;
        addNote.noteText = _noteField.text;
    } else {
        addNote.noteTitle = _titleFieldPad.text;
        addNote.noteText = _noteFieldPad.text;
    }
    addNote.noteTitle = _titleField.text;
    addNote.noteText = _noteField.text;
    [[DataSource sharedInstance] saveAndDismiss];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Importing Notes

- (IBAction)openImportDocumentPicker:(id)sender {
    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.text"]
                                                                                                            inMode:UIDocumentPickerModeImport];
    documentPicker.delegate = self;
    documentPicker.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:documentPicker animated:YES completion:nil];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    if (controller.documentPickerMode == UIDocumentPickerModeImport) {
        NSString *alertMessage = [NSString stringWithFormat:@"Successfully imported %@ as a note", [url lastPathComponent]];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Import"
                                                  message:alertMessage
                                                  preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
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

@end
