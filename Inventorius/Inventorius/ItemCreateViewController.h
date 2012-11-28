//
//  ItemCreateViewController.h
//  Inventorius
//
//  Created by Ken Harding on 11/28/12.
//  Copyright (c) 2012 unit91. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemCreateViewController : UIViewController <UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UIButton *m_cameraButton;
@property (strong, nonatomic) IBOutlet UILabel *m_containerInventoryLabel;
@property (strong, nonatomic) IBOutlet UISwitch *m_containerSwitch;
@property (strong, nonatomic) IBOutlet UITextField *m_nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *m_quantityTextField;
@property (strong, nonatomic) IBOutlet UITextField *m_descriptionTextField;
@property (strong, nonatomic) UIImagePickerController *picker;
@property (nonatomic, retain) UIImageView* selectedImage;
- (IBAction)cameraButtonPressed:(id)sender;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@end
