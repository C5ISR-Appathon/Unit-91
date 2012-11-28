//
//  ItemDetailViewController.m
//  Inventorius
//
//  Created by Ken Harding on 11/28/12.
//  Copyright (c) 2012 unit91. All rights reserved.
//

#import "ItemDetailViewController.h"

@interface ItemDetailViewController ()

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [_strNameLabel setText:self.detailItem.strName];
    [_quantityLabel setText:self.detailItem.quantity.stringValue];
    [_descriptionLabel setText:self.detailItem.strDescription];
    [_authorizedIssueLabel setText:self.detailItem.authorizedIssue.stringValue];
    [_NSNLabel setText:self.detailItem.nsn];
    [_unitOfIssueLabel setText:self.detailItem.unitOfIssue.stringValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
