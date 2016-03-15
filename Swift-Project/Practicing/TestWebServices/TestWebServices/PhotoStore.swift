//
//  PhotoStore.swift
//  TestWebServices
//
//  Created by 谢乾坤 on 3/11/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

enum ImageResult {
    case Success(UIImage)
    case Failure(ErrorType)
}

enum PhotoError: ErrorType {
    case ImageCreationError
}

class PhotoStore {
    
    
    let session: NSURLSession = {
        print(__FUNCTION__)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return  NSURLSession(configuration: config)
    }()
    
    func processRecentPhotosRequest (data data: NSData?, error: NSError?) -> PhotoResult {
                
        guard let jsonData = data else {
            return .Failure(error!)
        }
        return FlickrAPI.phtotsFromJSONData(jsonData)
    }
    
    func fetchRecentPhotos(completion completion:(PhotoResult) -> Void) {
        
        let url = FlickrAPI.recentPhotosURL()
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request) { (
            data, reponse, error) -> Void in
            
//            if let jsonData = data {
////                if let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) {
////                    print(jsonString)
////                }
//                
//                do{
//                    let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
//                    print(jsonObject)
//                }
//                catch let error{
//                    print("error occour")
//                }
//                
//                
//            }
//            else if let requestError = error {
//                print("error with fetch data \(requestError)")
//            }
//            else {
//                print("unexpected error")
            let result = self.processRecentPhotosRequest(data:data, error:error)
            
           // print(result)
            
            completion(result)
//            }
        }
        
        task.resume()
    }
    
    func fetchImageForPhoto(photo: Photo, completion: (ImageResult) -> Void){
        
        let photoURL = photo.remoteURL
        
        let request = NSURLRequest(URL:photoURL)
        
        let task = session.dataTaskWithRequest(request){
            (data, reponse, error) -> Void in
            
            let result = self.processImageRequest(data: data, error: error)
            
            //not understand....
            if case let .Success(image) = result {
                photo.image = image
            }
            
            completion(result)
        }
        task.resume()
 
    }
    
    func processImageRequest(data data: NSData?, error: NSError?) -> ImageResult {
        
        guard let imageData = data,
            image = UIImage(data: imageData) else {
                if data == nil {
                    return ImageResult.Failure(error!)
                }
                else {
                    return ImageResult.Failure(PhotoError.ImageCreationError)
                }
        }
        
        return .Success(image)
        
        
        
        
    }
    
    
}