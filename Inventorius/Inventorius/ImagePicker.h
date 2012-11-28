//
//  ImagePicker.h
//  Inventorius
//
//  Created by Ken Harding on 11/28/12.
//  Copyright (c) 2012 unit91. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImagePicker : UIImagePickerController
{
}

+ (ImagePicker *)sharedSingleton;
@end
