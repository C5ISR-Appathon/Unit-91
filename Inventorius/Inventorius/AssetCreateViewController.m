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
    
    self.createdAsset = [NSEntityDescription insertNewObjectForEntityForName:@"Asset" inManagedObjectContext:self.managedObjectContext];
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

- (IBAction)onDoneButton:(id)sender {
    
    //If is container
    if (m_containerSwitch.enabled)
    {
        
        self.createdAsset = [NSEntityDescription insertNewObjectForEntityForName:@"Container" inManagedObjectContext:self.managedObjectContext];
        if ([self.createdAsset isKindOfClass:[Container class]])
        {
            
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
