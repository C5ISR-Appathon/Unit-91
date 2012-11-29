//
//  DetailViewController.m
//  Inventorius
//
//  Created by Ken Harding on 11/28/12.
//  Copyright (c) 2012 unit91. All rights reserved.
//

#import "InventoryDetailViewController.h"
#import "AssetCollectionViewCell.h"

#import <MessageUI/MFMailComposeViewController.h>

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

- (void)viewWillAppear:(BOOL)animated
{
    [self configureView];
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
    
//    if(self.navItemToRemove != nil)
//    {
//        NSMutableArray *myNavigationStack = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
//        [myNavigationStack removeObject: self.navItemToRemove];
//        self.navigationController.viewControllers = myNavigationStack;
//        [self.collectionView reloadData];
//    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"SegueInventoryDetailToContainerDetail"])
    {
        // set the detail
        ContainerDetailViewController* controller = ((ContainerDetailViewController*)segue.destinationViewController);
        [controller setDetailItem:self.selectedContainer];
        
        // pass the context
        controller.managedObjectContext = self.managedObjectContext;
    }
    
    if ([[segue identifier] isEqualToString:@"SegueInventoryDetailToItemDetail"])
    {
        // set the detail
        ItemDetailViewController* controller = ((ItemDetailViewController*)segue.destinationViewController);
        [controller setDetailItem:self.selectedItem];
        
        // pass the context
        controller.managedObjectContext = self.managedObjectContext;
    }
    
    if ([[segue identifier] isEqualToString:@"SegueInventoryDetailToAssetCreate"])
    {
        AssetCreateViewController *controller = ((AssetCreateViewController*)segue.destinationViewController);
        // set the parent of the creator
        controller.m_parentAsset = self.detailItem;
        
        // pass the managedObjectContext
        controller.managedObjectContext = self.managedObjectContext;
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
        cell.imageView.image = [UIImage imageWithContentsOfFile:asset.strImagePathThumb];
    }
    return cell;
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Asset* asset = [self.detailItem.assets.allObjects objectAtIndex:indexPath.row];
    if([asset isKindOfClass:[Item class]])
    {
        self.selectedItem = (Item*) asset;
        [self performSegueWithIdentifier:@"SegueInventoryDetailToItemDetail" sender:self];
    }
    else if ([asset isKindOfClass:[Container class]])
    {
        self.selectedContainer = (Container*) asset;
        [self performSegueWithIdentifier:@"SegueInventoryDetailToContainerDetail" sender:self];
    }
}

- (IBAction)exportInventory:(id)sender {
    
    NSMutableString* exportString = [[NSMutableString alloc] init];
    [exportString appendString:@"Inventory Name: "];
    [exportString appendString:_detailItem.strName];
    [exportString appendString:@"|"];
    [exportString appendString:@"Owner: "];
    [exportString appendString:_detailItem.owner];
    [exportString appendString:@"|"];
    [exportString appendString:@"Description: "];
    [exportString appendString:_detailItem.strDescription];
    [exportString appendString:@"|"];
    
    NSSet* assets = _detailItem.assets;
    NSArray* allAssets = assets.allObjects;
    
    for (int i = 0; i < allAssets.count; ++i)
    {
        Asset* currentAsset = ((Asset*)[allAssets objectAtIndex:i]);
        [exportString appendString:@"Asset name: "];
        [exportString appendString:currentAsset.strName];
        [exportString appendString:@"|"];
        [exportString appendString:@"Asset description: "];
        [exportString appendString:currentAsset.strDescription];
        [exportString appendString:@"|"];
    }
    
    
    /*NSMutableString* outputFileName = [[NSMutableString alloc] init];
    
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSString* urlPath = [url path];
    
    [outputFileName appendString:urlPath];
    [outputFileName appendString:@"/"];
    
    [outputFileName appendString:_detailItem.strName];
    [outputFileName appendString:@".txt"];
    
    [exportString writeToFile:outputFileName
              atomically:NO
                encoding:NSStringEncodingConversionAllowLossy
                   error:nil];*/
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setSubject:@"Inventory Report"];
        [controller setMessageBody:exportString isHTML:NO];
        if (controller) [self presentModalViewController:controller animated:YES];
    } else {
        // Handle the error
    }
    
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [self dismissModalViewControllerAnimated:YES];
}
@end
