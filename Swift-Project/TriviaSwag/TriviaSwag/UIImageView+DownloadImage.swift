//
//  UIImageView+DownloadImage.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 5/11/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit
extension UIImageView {
    func loadImageWithURL(url: NSURL) -> NSURLSessionDownloadTask {
        let session = NSURLSession.sharedSession()
        
        let downloadTask = session.downloadTaskWithURL(url, completionHandler: {
            [weak self] url, response, error in
                if error == nil, let url = url, data = NSData(contentsOfURL: url), image = UIImage(data: data) {
                    dispatch_async(dispatch_get_main_queue()) {
                        if let strongSelf = self {
                            strongSelf.image = image
                        }
                    }
                } else {
                    print(error?.domain)
                }
        })
        
        downloadTask.resume()
        return downloadTask
    }
    
    func loadImageWithURL(url: NSURL, completion: (image:UIImage) -> ()) -> NSURLSessionDownloadTask {
        let session = NSURLSession.sharedSession()
        
        let downloadTask = session.downloadTaskWithURL(url, completionHandler: {
            [weak self] url, response, error in
            if error == nil, let url = url, data = NSData(contentsOfURL: url), image = UIImage(data: data) {
                completion(image: image)
                dispatch_async(dispatch_get_main_queue()) {
                    if let strongSelf = self {
                        strongSelf.image = image
                    }
                }
            } else {
                print(error?.domain)
            }
        })
        
        downloadTask.resume()
        return downloadTask
    }

}