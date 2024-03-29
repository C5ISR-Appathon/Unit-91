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
#import "ImagePicker.h"
#import "InventoryDetailViewController.h"
#import "ContainerDetailViewController.h"

@interface AssetCreateViewController ()

@end

@implementation AssetCreateViewController

@synthesize m_cameraButton;
@synthesize m_containerInventoryLabel;
@synthesize m_containerSwitch;
@synthesize m_nameTextField;
@synthesize m_quantityTextField;
@synthesize m_descriptionTextField;
@synthesize picker;
@synthesize m_authorizedIssueNumberTextField;
@synthesize m_nsnTextField;
@synthesize m_unitOfIssueTextField;
@synthesize m_assetPath;
@synthesize m_thumbPath;
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

- (void)dismissKeyboard
{
    [m_quantityTextField resignFirstResponder];
    [m_nameTextField resignFirstResponder];
    [m_descriptionTextField resignFirstResponder];
    [m_authorizedIssueNumberTextField resignFirstResponder];
    [m_nsnTextField resignFirstResponder];
    [m_unitOfIssueTextField resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
	// Do any additional setup after loading the view.
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDoneButton:)];
    
    self.navigationItem.rightBarButtonItem = doneButton;
    
    m_nameTextField.delegate = self;
    m_quantityTextField.delegate = self;
    m_descriptionTextField.delegate = self;
    m_authorizedIssueNumberTextField.delegate = self;
    m_nsnTextField.delegate = self;
    m_unitOfIssueTextField.delegate = self;    
    
    if (_createdAsset != nil)
    {
        //If is container
        if (([self.createdAsset isKindOfClass:[Container class]]))
        {
            
        }
        else if ([self.createdAsset isKindOfClass:[Item class]])
        {
            
            m_nsnTextField.text = ((Item *) self.createdAsset).nsn;
            
            m_unitOfIssueTextField.text = ((Item *) self.createdAsset).unitOfIssue.stringValue;
            m_quantityTextField.text = ((Item *) self.createdAsset).quantity.stringValue;
            m_authorizedIssueNumberTextField.text = ((Item *) self.createdAsset).authorizedIssue.stringValue;
            
        }
        
        m_descriptionTextField.text = self.createdAsset.strDescription;
        m_assetPath = self.createdAsset.strImagePath;
        m_thumbPath = self.createdAsset.strImagePathThumb;
        m_nameTextField.text = self.createdAsset.strName;
        [m_cameraButton setBackgroundImage:[UIImage imageWithContentsOfFile:m_thumbPath] forState:UIControlStateNormal];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"SegueAssetCreateToInventoryDetail"])
    {
        //((InventoryDetailViewController*)segue.destinationViewController).navItemToRemove = self;
        ((InventoryDetailViewController*)segue.destinationViewController).managedObjectContext = self.managedObjectContext;
    }
    else if ([[segue identifier] isEqualToString:@"SegueAssetCreateToContainerDetail"])
    {
        ((ContainerDetailViewController*)segue.destinationViewController).managedObjectContext = self.managedObjectContext;
    }
}

- (IBAction)onDoneButton:(id)sender {
    
    BOOL isNewAsset = YES;
    //If is container
    if (m_containerSwitch.isOn)
    {
        
        if (self.createdAsset == nil)
        {
            self.createdAsset = [NSEntityDescription insertNewObjectForEntityForName:@"Container" inManagedObjectContext:self.managedObjectContext];
        }
        else
        {
            isNewAsset = NO;
        }
        
        if ([self.createdAsset isKindOfClass:[Container class]])
        {
            ((Container *) self.createdAsset).assets = [[NSSet alloc] init];
        }
        
    }
    else
    {

        if (self.createdAsset == nil)
        {

            self.createdAsset = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:self.managedObjectContext];
        }
        else
        {
            isNewAsset = NO;
        }
        
        if ([self.createdAsset isKindOfClass:[Item class]])
        {
            ((Item *) self.createdAsset).nsn = m_nsnTextField.text;
            ((Item *) self.createdAsset).authorizedIssue = [NSDecimalNumber decimalNumberWithString:m_authorizedIssueNumberTextField.text];
            if ([((Item *) self.createdAsset).authorizedIssue isEqualToNumber:[NSDecimalNumber notANumber]])
            {
                ((Item *) self.createdAsset).authorizedIssue = 0;
            }
            
            ((Item *) self.createdAsset).quantity = [NSDecimalNumber decimalNumberWithString:m_quantityTextField.text];
            
            if ([((Item *) self.createdAsset).quantity isEqualToNumber:[NSDecimalNumber notANumber]])
            {
                ((Item *) self.createdAsset).quantity = 0;
            }
            ((Item *) self.createdAsset).unitOfIssue = [NSDecimalNumber decimalNumberWithString:m_unitOfIssueTextField.text];
            if ([((Item *) self.createdAsset).unitOfIssue isEqualToNumber:[NSDecimalNumber notANumber]])
            {
                ((Item *) self.createdAsset).unitOfIssue = 0;
            }
            
        }
    }
    self.createdAsset.strDescription = m_descriptionTextField.text;
    if(m_assetPath != nil)
    {
        self.createdAsset.strImagePath = m_assetPath;
        self.createdAsset.strImagePathThumb = m_thumbPath;
    }
    else
    {
        self.createdAsset.strImagePath = [[NSBundle mainBundle] pathForResource:@"inventory_icon_retina" ofType:@"png"];
        self.createdAsset.strImagePathThumb = [[NSBundle mainBundle] pathForResource:@"inventory_icon_retina" ofType:@"png"];

    }
    
    self.createdAsset.strName = m_nameTextField.text;
    
    //Check to see who pushed to us; we want to return to them
    if ([m_parentAsset isKindOfClass:[Container class]])
    {
        if(isNewAsset == YES)
        {
            Container *container = (Container*) m_parentAsset;
            [container addAssetsObject:self.createdAsset];
        }
        
        NSError *error;
        if (![[self managedObjectContext] save:&error])
        {
            NSLog(@"Could not save: %@", error.debugDescription);
        }
        //[self performSegueWithIdentifier:@"SegueAssetCreateToContainerDetail" sender:self];
    }
    else
    {
        if(isNewAsset == YES)
        {
            Inventory *inventory = (Inventory*) m_parentAsset;
            [inventory addAssetsObject:self.createdAsset];
        }
        
        NSError *error;
        if (![[self managedObjectContext] save:&error])
        {
            NSLog(@"Could not save: %@", error.debugDescription);
        }
        
        //[self performSegueWithIdentifier:@"SegueAssetCreateToInventoryDetail" sender:self];
    }

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSwitch:(id)sender {
    if (m_containerSwitch.isOn)
    {
        m_quantityTextField.hidden = true;
        m_authorizedIssueNumberTextField.hidden = true;
        m_nsnTextField.hidden = true;
        m_unitOfIssueTextField.hidden = true;
    }
    else
    {
        m_quantityTextField.hidden = false;
        m_authorizedIssueNumberTextField.hidden = false;
        m_nsnTextField.hidden = false;
        m_unitOfIssueTextField.hidden = false;
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

- (void) imagePickerController:(UIImagePickerController*) Picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    @autoreleasepool
    {    
        [[self parentViewController] dismissViewControllerAnimated:YES completion:^{}];
        
        UIImage* selectedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
                
        NSMutableString *jpgPath = [[NSMutableString alloc] init];
        NSMutableString *thumbPath = [[NSMutableString alloc] init];
        
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSString* urlPath = [url path];
        
        [jpgPath appendString:urlPath];
        [jpgPath appendString:@"/"];
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"MMM-dd-yyyy_HH-mm-ss"];
        
        NSDate* currentTime = [NSDate date];
        
        NSString* fileStamp = [format stringFromDate:currentTime];
        
        [jpgPath appendString:fileStamp];
        [thumbPath appendString:jpgPath];
        [thumbPath appendString:@"-thumb.jpg"];
        [jpgPath appendString:@".jpg"];
        
        NSData* jpg = UIImageJPEGRepresentation(selectedImage, 0.7);
        
        [jpg writeToFile:jpgPath atomically:NO];
        
        
        CGSize destinationSize = CGSizeMake(128, 128);
        
        UIGraphicsBeginImageContext(destinationSize);
        [selectedImage drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
        UIImage *thumbImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // TODO : fix for aspect ratio
        NSData *thumb = UIImageJPEGRepresentation(thumbImage, 1.0);
        
        [thumb writeToFile:thumbPath atomically:NO];
        
        [m_cameraButton setBackgroundImage:[UIImage imageWithContentsOfFile:thumbPath] forState:UIControlStateNormal];
        
        m_assetPath = jpgPath;
        m_thumbPath = thumbPath;
    }

}
@end
