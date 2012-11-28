//
//  ImagePicker.m
//  Inventorius
//
//  Created by Ken Harding on 11/28/12.
//  Copyright (c) 2012 unit91. All rights reserved.
//

#import "ImagePicker.h"

@implementation ImagePicker


+ (ImagePicker *)sharedSingleton
{
    static ImagePicker *sharedSingleton;
    
    @synchronized(self)
    {
        if (!sharedSingleton)
            sharedSingleton = [[ImagePicker alloc] init];
        
        return sharedSingleton;
    }
}

@end
