//
//  InventoryCreateViewController.m
//  Inventorius
//
//  Created by Ken Harding on 11/28/12.
//  Copyright (c) 2012 unit91. All rights reserved.
//

#import "InventoryCreateViewController.h"

#import "InventoryListViewController.h"

@interface InventoryCreateViewController ()


@end

@implementation InventoryCreateViewController

@synthesize m_cameraButton;
@synthesize m_nameTextField;
@synthesize m_ownerTextField;
@synthesize m_descriptionTextField;
@synthesize selectedImage;
@synthesize picker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
            }
    return self;
}

- (void)onDoneButton:(id) sender
{
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Couldn't save: %@", [error localizedDescription]);
    }
    
    [self performSegueWithIdentifier:@"SegueAfterCreateInventory" sender:self];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.createdInventory = [NSEntityDescription insertNewObjectForEntityForName:@"Inventory" inManagedObjectContext:self.managedObjectContext];
    
    self.createdInventory.strName = @"New Inventory";
    self.createdInventory.owner = @"The Owner";
	// Do any additional setup after loading the view.
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDoneButton:)];
    
    self.navigationItem.rightBarButtonItem = doneButton;
    m_nameTextField.delegate = self;
    m_ownerTextField.delegate = self;
    m_descriptionTextField.delegate = self;
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"SegueAfterCreateInventory"])
    {        
        ((InventoryListViewController*)segue.destinationViewController).managedObjectContext = self.managedObjectContext;
    }
    
    

    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)cameraButtonPressed:(id)sender {
    picker = [[UIImagePickerController alloc] init];
    
    picker.delegate = self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:picker animated:YES completion:^{}];
}

- (IBAction)nameEntered:(id)sender {
    self.createdInventory.strName = m_nameTextField.text;

}

- (IBAction)ownerEntered:(id)sender {
    self.createdInventory.owner = m_ownerTextField.text;
}

- (IBAction)descriptionEntered:(id)sender {
    self.createdInventory.strDescription = m_descriptionTextField.text;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*) Picker {
    
    [[self parentViewController] dismissViewControllerAnimated:(YES) completion:^{}];
}

- (void) imagePickerController:(UIImagePickerController*) Picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [[self parentViewController] dismissViewControllerAnimated:YES completion:^{}];
    Picker = nil;
    
    [[self parentViewController] dismissViewControllerAnimated:YES completion:^{}];
    
    selectedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    [m_cameraButton setBackgroundImage:selectedImage forState:UIControlStateNormal];
}
@end
