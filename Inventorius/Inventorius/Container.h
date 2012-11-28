//
//  Container.h
//  Inventorius
//
//  Created by Nicholas Vidovich on 11/28/12.
//  Copyright (c) 2012 unit91. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Asset.h"

@class Asset;

@interface Container : Asset

@property (nonatomic, retain) NSSet *assets;
@end

@interface Container (CoreDataGeneratedAccessors)

- (void)addAssetsObject:(Asset *)value;
- (void)removeAssetsObject:(Asset *)value;
- (void)addAssets:(NSSet *)values;
- (void)removeAssets:(NSSet *)values;

@end
