//
//  ContainerDetailViewController.m
//  Inventorius
//
//  Created by Ken Harding on 11/28/12.
//  Copyright (c) 2012 unit91. All rights reserved.
//

#import "ContainerDetailViewController.h"
#import "AssetCollectionViewCell.h"
#import "Item.h"
#import "Container.h"

#import "AssetCreateViewController.h"

@interface ContainerDetailViewController ()

@end

@implementation ContainerDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddButton:)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"SegueContainerDetailToAssetCreate"])
    {
        ((AssetCreateViewController*)segue.destinationViewController).managedObjectContext = self.managedObjectContext;
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
