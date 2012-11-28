//
//  Asset.h
//  Inventorius
//
//  Created by Nicholas Vidovich on 11/28/12.
//  Copyright (c) 2012 unit91. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Asset : NSManagedObject

@property (nonatomic, retain) NSString * strName;
@property (nonatomic, retain) NSString * strDescription;
@property (nonatomic, retain) NSString * strImagePath;
@property (nonatomic, retain) NSString * strImagePathThumb;

@end
