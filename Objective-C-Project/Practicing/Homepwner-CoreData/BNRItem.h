//
//  BNRItem.h
//  Homepwner
//
//  Created by 谢乾坤 on 2/23/16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface BNRItem : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@property (nonatomic, strong) NSDate * dateCreated;
@property (nonatomic, strong) NSString * itemKey;
@property (nonatomic, strong) NSString * itemName;
@property (nonatomic) double orderingValue;
@property (nonatomic, strong) NSString * serialNumber;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, strong) NSData * thumbnailData;
@property (nonatomic) int valueInDollars;
@property (nonatomic, strong) NSManagedObject *assetType;

- (void)setThumbnailFromImage:(UIImage *)image;


@end

NS_ASSUME_NONNULL_END

#import "BNRItem+CoreDataProperties.h"
