//
//  InventoryCreateViewController.m
//  Inventorius
//
//  Created by Ken Harding on 11/28/12.
//  Copyright (c) 2012 unit91. All rights reserved.
//

#import "InventoryCreateViewController.h"

#import "InventoryListViewController.h"

#import "ImagePicker.h"

@interface InventoryCreateViewController ()


@end

@implementation InventoryCreateViewController

@synthesize m_cameraButton;
@synthesize m_nameTextField;
@synthesize m_ownerTextField;
@synthesize m_descriptionTextField;
@synthesize picker;
@synthesize m_imagePath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
            }
    return self;
}

- (void)onDoneButton:(id) sender
{
    
    self.createdInventory = [NSEntityDescription insertNewObjectForEntityForName:@"Inventory" inManagedObjectContext:self.managedObjectContext];
    self.createdInventory.strImagePath = m_imagePath;
    self.createdInventory.strName = m_nameTextField.text;
    self.createdInventory.owner = m_ownerTextField.text;
    self.createdInventory.strDescription = m_descriptionTextField.text;
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Couldn't save: %@", [error localizedDescription]);
    }
    
    [self performSegueWithIdentifier:@"SegueAfterCreateInventory" sender:self];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //self.createdInventory.strName = @"New Inventory";
    //self.createdInventory.owner = @"The Owner";
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
    picker = [ImagePicker sharedSingleton];
    
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

- (void)imagePickerControllerDidCancel:(UIImagePickerController*) Picker {
    
    [[self parentViewController] dismissViewControllerAnimated:(YES) completion:^{}];
}

- (void) imagePickerController:(UIImagePickerController*) Picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    @autoreleasepool
    {
        [[self parentViewController] dismissViewControllerAnimated:YES completion:^{}];    
        
        UIImageView* selectedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
        
        NSMutableString  *jpgPath = [[NSMutableString alloc] init];
        
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSString* urlPath = [url path];
        
        [jpgPath appendString:urlPath];
        [jpgPath appendString:@"/"];
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"MMM-dd-yyyy_HH-mm-ss"];
        
        NSDate* currentTime = [NSDate date];
        
        NSString* fileStamp = [format stringFromDate:currentTime];
        
        [jpgPath appendString:fileStamp];
        [jpgPath appendString:@".jpg"];
        
        NSData* jpg = UIImageJPEGRepresentation(selectedImage, 0.7);
        
        [jpg writeToFile:jpgPath atomically:NO];
        
        self.createdInventory.strImagePath = jpgPath;
        m_imagePath = jpgPath;
        [m_cameraButton setBackgroundImage:[UIImage imageWithContentsOfFile:jpgPath] forState:UIControlStateNormal];
    }
}
@end
