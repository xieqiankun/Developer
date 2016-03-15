//
//  ImageStore.swift
//  Homeowner
//
//  Created by 谢乾坤 on 3/10/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class ImageStore {
    
    let cache = NSCache()
    
    func setImage(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key)
        
        let imageURL = imageURLForKey(key)
        
        print(imageURL)
        
        if let data = UIImageJPEGRepresentation(image, 0.5) {
            data.writeToURL(imageURL, atomically: true)
        }
        
    }
    
    func imageForKey(key: String) -> UIImage? {
        
        //return cache.objectForKey(key) as? UIImage
        
        if let existingImage = cache.objectForKey(key) as? UIImage {
            return existingImage
        }
        let imageURL = imageURLForKey(key)
        //need to learn about the grand word
        guard let imageFromDisk = UIImage(contentsOfFile: imageURL.path!) else {
            return nil
        }
        cache.setObject(imageFromDisk, forKey: key)
        
        return imageFromDisk
        
    }
    
    func deleteImageForKey(key: String) {
        cache.removeObjectForKey(key)
        
        let imageURL = imageURLForKey(key)
        do {
            try NSFileManager.defaultManager().removeItemAtURL(imageURL)
        } catch let deleteEror {
            print("Error removing the image from the disk:\(deleteEror)")
        }
    }
    
    func imageURLForKey(key: String) -> NSURL {
        let documentsDirectories = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = documentsDirectories.first!
        
        print(documentDirectory)
        
        return documentDirectory.URLByAppendingPathComponent(key)
        
    }
    
}
