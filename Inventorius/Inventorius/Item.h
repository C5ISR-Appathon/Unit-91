//
//  Item.h
//  Inventorius
//
//  Created by Nicholas Vidovich on 11/28/12.
//  Copyright (c) 2012 unit91. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Asset.h"


@interface Item : Asset

@property (nonatomic, retain) NSDecimalNumber * quantity;
@property (nonatomic, retain) NSDecimalNumber * unitOfIssue;
@property (nonatomic, retain) NSDecimalNumber * authorizedIssue;
@property (nonatomic, retain) NSString * nsn;

@end
