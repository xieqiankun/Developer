//
//  Photo+CoreDataProperties.m
//  Photomania
//
//  Created by 谢乾坤 on 2/24/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Photo+CoreDataProperties.h"
#import "FlickrFetcher.h"
#import "Phtotgrapher+CoreDataProperties.h"

@implementation Photo (CoreDataProperties)

@dynamic title;
@dynamic subtitle;
@dynamic imageURL;
@dynamic unique;
@dynamic whoTook;


+ (Photo *)photoWithFlickrInfo:(NSDictionary *)photoDictionary
         inanagedObjectContext:(NSManagedObjectContext *)context
{
    Photo *photo = nil;
    
    NSString *unique = photoDictionary[FLICKR_PHOTO_ID];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", unique];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if(!matches || error || [matches count] > 1){
        //handle error
    } else if ([matches count]){
        photo = [matches firstObject];
    } else {
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        photo.unique = unique;
        photo.title = [photoDictionary valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        photo.imageURL = [[FlickrFetcher urlForPhoto:photoDictionary format:FlickrPhotoFormatLarge] absoluteString];
        
        
        NSString *photographerName = [photoDictionary valueForKeyPath:FLICKR_PHOTO_OWNER];
        photo.whoTook = [Phtotgrapher photographerWithName:photographerName inManagedObjectContext:context];
        
    }
    
    
    
    return photo;
}

+ (void) loadPhotosFromFlickrArray:(NSArray *)photos
          intoManagedObjectContext:(NSManagedObjectContext *)context
{
    
}

@end
