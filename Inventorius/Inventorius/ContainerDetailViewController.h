//
//  ContainerDetailViewController.h
//  Inventorius
//
//  Created by Ken Harding on 11/28/12.
//  Copyright (c) 2012 unit91. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Container.h"
#import "Item.h"

@interface ContainerDetailViewController : UICollectionViewController<UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) Container* detailItem;

@property Container *selectedContainer;
@property Item *selectedItem;

@end
