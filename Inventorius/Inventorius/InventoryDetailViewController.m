//
//  DetailViewController.m
//  Inventorius
//
//  Created by Ken Harding on 11/28/12.
//  Copyright (c) 2012 unit91. All rights reserved.
//

#import "InventoryDetailViewController.h"
#import "AssetCollectionViewCell.h"
#import "Asset.h"

#import "ContainerDetailViewController.h"

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
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"SegueToInventoryDetail"])
    {        
        // pass the managedObjectContext
        ((InventoryDetailViewController*)segue.destinationViewController).managedObjectContext = self.managedObjectContext;
    }
    
    if ([[segue identifier] isEqualToString:@"SegueInventoryDetailToContainerDetail"])
    {
        // pass the managedObjectContext
        ((ContainerDetailViewController*)segue.destinationViewController).managedObjectContext = self.managedObjectContext;
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
    [self performSegueWithIdentifier:@"SegueToAssetCreate" sender:self];
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
        cell.imageView.image = [UIImage imageWithContentsOfFile:asset.strImagePathThumb];
    }
    return cell;
}

@end
