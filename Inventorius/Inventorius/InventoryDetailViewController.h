//
//  DetailViewController.h
//  Inventorius
//
//  Created by Ken Harding on 11/28/12.
//  Copyright (c) 2012 unit91. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Inventory.h"
#import "Container.h"
#import "Item.h"
#import "AssetCreateViewController.h"

@interface InventoryDetailViewController : UICollectionViewController<UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) Inventory *detailItem;
@property AssetCreateViewController* navItemToRemove;

@property Container *selectedContainer;
@property Item *selectedItem;

- (IBAction)exportInventory:(id)sender;

@end
