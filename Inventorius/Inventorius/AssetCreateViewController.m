//
//  ItemCreateViewController.m
//  Inventorius
//
//  Created by Ken Harding on 11/28/12.
//  Copyright (c) 2012 unit91. All rights reserved.
//

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
    
    if (m_containerSwitch.enabled)
    {
        
    }
    else
    {
        
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
    
    [jpgPath appendString:@"/inventorius/"];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    NSDate* currentTime = [NSDate date];
    
    NSString* fileStamp = [format stringFromDate:currentTime];
    
    [jpgPath appendString:fileStamp];
    [jpgPath appendString:@".jpg"];
    
    NSData* jpg = UIImageJPEGRepresentation(selectedImage, 1.0);
    
    [jpg writeToFile:jpgPath atomically:NO];
    
    //self.createdInventory.strImagePath = jpgPath;
    }
@end
