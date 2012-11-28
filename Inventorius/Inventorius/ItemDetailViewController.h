//
//  ItemDetailViewController.h
//  Inventorius
//
//  Created by Ken Harding on 11/28/12.
//  Copyright (c) 2012 unit91. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

@interface ItemDetailViewController : UIViewController

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UILabel *strNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorizedIssueLabel;
@property (weak, nonatomic) IBOutlet UILabel *NSNLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitOfIssueLabel;

@property (strong, nonatomic) Item* detailItem;

@end
