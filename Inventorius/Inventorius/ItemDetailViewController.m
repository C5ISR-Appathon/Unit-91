//
//  ItemDetailViewController.m
//  Inventorius
//
//  Created by Ken Harding on 11/28/12.
//  Copyright (c) 2012 unit91. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "AssetCreateViewController.h"

@interface ItemDetailViewController ()
-(void) configureView;
@end

@implementation ItemDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem)
    {
        [_strNameLabel setText:self.detailItem.strName];
        [_quantityLabel setText:self.detailItem.quantity.stringValue];
        [_descriptionLabel setText:self.detailItem.strDescription];
        [_authorizedIssueLabel setText:self.detailItem.authorizedIssue.stringValue];
        [_NSNLabel setText:self.detailItem.nsn];
        [_unitOfIssueLabel setText:self.detailItem.unitOfIssue.stringValue];
        [_imageView setImage:[UIImage imageWithContentsOfFile:self.detailItem.strImagePath]];

    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self configureView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self configureView];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(onEditButton:)];
    self.navigationItem.rightBarButtonItem = editButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"SegueItemDetailToAssetCreate"])
    {
        AssetCreateViewController* controller = ((AssetCreateViewController*)segue.destinationViewController);
        controller.managedObjectContext = self.managedObjectContext;
        controller.createdAsset = self.detailItem;
    }

}

- (void)onEditButton:(id)sender
{
    // do segue to InventoryCreate
    [self performSegueWithIdentifier:@"SegueItemDetailToAssetCreate" sender:self];
}


@end
