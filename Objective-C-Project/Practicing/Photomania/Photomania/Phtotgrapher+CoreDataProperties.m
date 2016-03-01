//
//  Phtotgrapher+CoreDataProperties.m
//  Photomania
//
//  Created by 谢乾坤 on 2/24/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Phtotgrapher+CoreDataProperties.h"

@implementation Phtotgrapher (CoreDataProperties)

@dynamic name;
@dynamic photos;

+ (Phtotgrapher *)photographerWithName:(NSString *)name
                inManagedObjectContext:(NSManagedObjectContext *)context
{
    Phtotgrapher * photographer = nil;
    
    if([name length]){
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Phtotgrapher"];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
        
        NSError * error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        if(!matches || ([matches count] > 1)){
            //error handle
        } else if (![matches count]){
            
            photographer = [NSEntityDescription insertNewObjectForEntityForName:@"Phtotgrapher" inManagedObjectContext:context];
            photographer.name = name;
            
            
        } else {
            photographer = [matches lastObject];
        }
    }
    
    return photographer;
    
}

@end
