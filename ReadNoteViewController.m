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
#import <iAd/iAd.h>

@interface ReadNoteViewController () <NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *noteLabel;
@property (nonatomic, strong)NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong)NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSString *noteTitle;
@property (nonatomic, strong) NSString *noteText;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *localizedShareButton;
@property (weak, nonatomic) IBOutlet UIButton *localizedEditButton;

@end

@implementation ReadNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"View is loading.");
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"SavoyeLetPlain" size:30],NSFontAttributeName, nil]];
    self.navigationItem.title = [NSString stringWithFormat:NSLocalizedString(@"Read an Idea", nil)];
    
    [self.localizedShareButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"Share", nil)]];
    self.localizedShareButton.target = self;
    self.localizedShareButton.action = @selector(shareButton:);
    
    [self.localizedEditButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"Edit", nil)] forState:UIControlStateNormal];
    [self.localizedEditButton sizeToFit];
    
    _noteTitle = [NSString stringWithFormat:@"%@", _selectedNote.noteTitle];
    _noteText = [NSString stringWithFormat:@"%@", _selectedNote.noteText];
    
    self.titleLabel.text = _noteTitle;
    self.noteLabel.text = _noteText;
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.canDisplayBannerAds = YES;
    
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
        
        EditNoteViewController *editNoteViewController = (EditNoteViewController*) navigationController;
        editNoteViewController.selectedNote = self.selectedNote;
        editNoteViewController.interstitialPresentationPolicy = ADInterstitialPresentationPolicyAutomatic;
        
    }
}

#pragma mark - Sharing

- (void)shareButton:(UIBarButtonItem *)sender {
    NSMutableArray *noteToShare = [NSMutableArray array];
    [noteToShare addObject:self.noteText];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:noteToShare applicationActivities:nil];
    
    if (!isPhone) {
        activityVC.popoverPresentationController.barButtonItem = sender;
    }
    
    [self presentViewController:activityVC animated:YES completion:nil];
    
    if (UIActivityTypeMail) {
        [activityVC setValue:@"From The Ideamator" forKey:@"subject"];
        
    }
}

@end
