//
//  Inventory.h
//  Inventorius
//
//  Created by Nicholas Vidovich on 11/28/12.
//  Copyright (c) 2012 unit91. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Asset.h"

@class Asset;

@interface Inventory : Asset

@property (nonatomic, retain) NSString * owner;
@property (nonatomic, retain) NSSet *assets;
@end

@interface Inventory (CoreDataGeneratedAccessors)

- (void)addAssetsObject:(Asset *)value;
- (void)removeAssetsObject:(Asset *)value;
- (void)addAssets:(NSSet *)values;
- (void)removeAssets:(NSSet *)values;

@end
