//
//  InventoryCreateViewController.h
//  Inventorius
//
//  Created by Ken Harding on 11/28/12.
//  Copyright (c) 2012 unit91. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Inventory.h"

@interface InventoryCreateViewController : UIViewController <UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) Inventory *createdInventory;

@property (strong, nonatomic) IBOutlet UIButton *m_cameraButton;
@property (strong, nonatomic) IBOutlet UITextField *m_nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *m_ownerTextField;
@property (strong, nonatomic) IBOutlet UITextField *m_descriptionTextField;
@property (strong, nonatomic) UIImagePickerController *picker;
@property (nonatomic, retain) UIImageView* selectedImage;
- (IBAction)cameraButtonPressed:(id)sender;
- (IBAction)nameEntered:(id)sender;
- (IBAction)ownerEntered:(id)sender;
- (IBAction)descriptionEntered:(id)sender;

@end
