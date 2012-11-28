//
//  AssetCollectionViewCell.h
//  Inventorius
//
//  Created by Ken Harding on 11/28/12.
//  Copyright (c) 2012 unit91. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *assetTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
