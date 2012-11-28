//
//  DetailViewController.m
//  Inventorius
//
//  Created by Ken Harding on 11/28/12.
//  Copyright (c) 2012 unit91. All rights reserved.
//

#import "InventoryDetailViewController.h"
#import "AssetCollectionViewCell.h"

#import "Item.h"
#import "Container.h"
#import "ContainerDetailViewController.h"
#import "ItemDetailViewController.h"
#import "AssetCreateViewController.h"


@interface InventoryDetailViewController ()
- (void)configureView;
@end

@implementation InventoryDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem)
    {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem)
    {
        [self.collectionView reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddButton:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.title = self.detailItem.strName;
    
    for (Asset* asset in self.detailItem.assets.allObjects)
    {
        if ([asset isKindOfClass:[Item class]])
        {
            NSLog(@"ITEM");
        }
        else if ([asset isKindOfClass:[Container class]])
        {
            NSLog(@"CONTAINER");
        }
        NSLog(@"Asset: %@", asset.strName);
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"SegueInventoryDetailToContainerDetail"])
    {
        // pass the managedObjectContext
        AssetCollectionViewCell *cell = sender;
        NSIndexPath *cellIndex = [self.collectionView indexPathForCell:cell];
        Container* container = [self.detailItem.assets.allObjects objectAtIndex:cellIndex.row];

        ContainerDetailViewController* controller = ((ContainerDetailViewController*)segue.destinationViewController);
        [controller setDetailItem:container];
        controller.managedObjectContext = self.managedObjectContext;
    }
    
    if ([[segue identifier] isEqualToString:@"SegueInventoryDetailToItemDetail"])
    {
        // pass the managedObjectContext
        AssetCollectionViewCell *cell = sender;
        NSIndexPath *cellIndex = [self.collectionView indexPathForCell:cell];
        Item* item = [self.detailItem.assets.allObjects objectAtIndex:cellIndex.row];
        
        ItemDetailViewController* controller = ((ItemDetailViewController*)segue.destinationViewController);
        [controller setDetailItem:item];
        ((ItemDetailViewController*)segue.destinationViewController).managedObjectContext = self.managedObjectContext;
    }
    
    if ([[segue identifier] isEqualToString:@"SegueInventoryDetailToAssetCreate"])
    {
        // pass the managedObjectContext
        ((AssetCreateViewController*)segue.destinationViewController).managedObjectContext = self.managedObjectContext;
        ((AssetCreateViewController*)segue.destinationViewController).m_parentAsset = self.detailItem;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onAddButton:(id)sender
{
    // do segue to InventoryCreate
    [self performSegueWithIdentifier:@"SegueInventoryDetailToAssetCreate" sender:self];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.detailItem.assets count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AssetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    Asset* asset = [self.detailItem.assets.allObjects objectAtIndex:(indexPath.row)];
    if (asset != nil)
    {
        cell.assetTitle.text = asset.strName;
        cell.imageView.image = [UIImage imageWithContentsOfFile:asset.strImagePath];
    }
    return cell;
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Asset* asset = [self.detailItem.assets.allObjects objectAtIndex:indexPath.row];
    if([asset isKindOfClass:[Item class]])
    {
        [self performSegueWithIdentifier:@"SegueInventoryDetailToItemDetail" sender:self];
    }
    else if ([asset isKindOfClass:[Container class]])
    {
        [self performSegueWithIdentifier:@"SegueInventoryDetailToContainerDetail" sender:self];
    }
}

@end
