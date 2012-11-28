//
//  InventoryCreateViewController.m
//  Inventorius
//
//  Created by Ken Harding on 11/28/12.
//  Copyright (c) 2012 unit91. All rights reserved.
//

#import "InventoryCreateViewController.h"

#import "InventoryListViewController.h"

@interface InventoryCreateViewController ()

@end

@implementation InventoryCreateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
            }
    return self;
}

- (void)onDoneButton:(id) sender
{
    self.createdInventory = [NSEntityDescription insertNewObjectForEntityForName:@"Inventory" inManagedObjectContext:self.managedObjectContext];
        
    self.createdInventory.strName = @"New Inventory";
    self.createdInventory.owner = @"The Owner";
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Couldn't save: %@", [error localizedDescription]);
    }
    
    [self performSegueWithIdentifier:@"SegueAfterCreateInventory" sender:self];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDoneButton:)];
    
    self.navigationItem.rightBarButtonItem = doneButton;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"SegueAfterCreateInventory"])
    {        
        ((InventoryListViewController*)segue.destinationViewController).managedObjectContext = self.managedObjectContext;
    }
    
    

    
}

@end
