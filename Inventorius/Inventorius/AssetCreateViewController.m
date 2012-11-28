//
//  ItemCreateViewController.m
//  Inventorius
//
//  Created by Ken Harding on 11/28/12.
//  Copyright (c) 2012 unit91. All rights reserved.
//

#import "Container.h"
#import "Item.h"
#import "AssetCreateViewController.h"
#import "Inventory.h"


@interface AssetCreateViewController ()

@end

@implementation AssetCreateViewController

@synthesize m_cameraButton;
@synthesize m_containerInventoryLabel;
@synthesize m_containerSwitch;
@synthesize m_nameTextField;
@synthesize m_quantityTextField;
@synthesize m_descriptionTextField;
@synthesize selectedImage;
@synthesize picker;
@synthesize m_authorizedIssueNumberTextField;
@synthesize m_nsnTextField;
@synthesize m_unitOfIssueTextField;
@synthesize m_assetPath;
@synthesize m_parentAsset;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

///@TODO: On done/scene leave, determine which type we are (item/container), create that, and populate it with info. DO NOT CREATE AN ASSET ON LOAD.

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDoneButton:)];
    
    self.navigationItem.rightBarButtonItem = doneButton;
    
    m_nameTextField.delegate = self;
    m_quantityTextField.delegate = self;
    m_descriptionTextField.delegate = self;
    m_authorizedIssueNumberTextField.delegate = self;
    m_nsnTextField.delegate = self;
    m_unitOfIssueTextField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"SegueAssetCreateToInventoryDetail"])
    {
        ((AssetCreateViewController*)segue.destinationViewController).managedObjectContext = self.managedObjectContext;
    }
    else if ([[segue identifier] isEqualToString:@"SegueAssetCreateToContainerDetail"])
    {
        ((AssetCreateViewController*)segue.destinationViewController).managedObjectContext = self.managedObjectContext;
    }
    
    
    
}

- (IBAction)onDoneButton:(id)sender {
    
    //If is container
    if (m_containerSwitch.isSelected)
    {        
        self.createdAsset = [NSEntityDescription insertNewObjectForEntityForName:@"Container" inManagedObjectContext:self.managedObjectContext];
        if ([self.createdAsset isKindOfClass:[Container class]])
        {
            ((Container *) self.createdAsset).assets = [[NSSet alloc] init];
        }
        
    }
    else
    {
        self.createdAsset = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:self.managedObjectContext];
        if ([self.createdAsset isKindOfClass:[Item class]])
        {
            ((Item *) self.createdAsset).nsn = m_nsnTextField.text;
            ((Item *) self.createdAsset).authorizedIssue = [NSDecimalNumber decimalNumberWithString:m_authorizedIssueNumberTextField.text];
            ((Item *) self.createdAsset).quantity = [NSDecimalNumber decimalNumberWithString:m_quantityTextField.text];
            ((Item *) self.createdAsset).unitOfIssue = [NSDecimalNumber decimalNumberWithString:m_unitOfIssueTextField.text];
        }
    }
    self.createdAsset.strDescription = m_descriptionTextField.text;
    self.createdAsset.strImagePath = m_assetPath;
    self.createdAsset.strName = m_nameTextField.text;
    
    //Check to see who pushed to us; we want to return to them
    if ([m_parentAsset isKindOfClass:[Container class]])
    {
        Container *container = (Container*) m_parentAsset;
        [container addAssetsObject:self.createdAsset];
        
        NSError *error;
        if (![[self managedObjectContext] save:&error])
        {
            NSLog(@"Could not save: %@", error.description);
        }
        [self performSegueWithIdentifier:@"SegueAssetCreateToContainerDetail" sender:self];
    }
    else
    {
        Inventory *inventory = (Inventory*) m_parentAsset;
        [inventory addAssetsObject:self.createdAsset];
        
        NSError *error;
        if (![[self managedObjectContext] save:&error])
        {
            NSLog(@"Could not save: %@", error.description);
        }
        [self performSegueWithIdentifier:@"SegueAssetCreateToInventoryDetail" sender:self];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*) Picker {
    
    [[self parentViewController] dismissViewControllerAnimated:(YES) completion:^{}];
}

- (void) imagePickerController:(UIImagePickerController*) Picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [[self parentViewController] dismissViewControllerAnimated:YES completion:^{}];
    Picker = nil;
    
    
    
    selectedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    [m_cameraButton setBackgroundImage:selectedImage forState:UIControlStateNormal];
    
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
    
    NSData* jpg = UIImageJPEGRepresentation(selectedImage, 1.0);
    
    [jpg writeToFile:jpgPath atomically:NO];
    
    //self.createdInventory.strImagePath = jpgPath;
    m_assetPath = jpgPath;

    }
@end
