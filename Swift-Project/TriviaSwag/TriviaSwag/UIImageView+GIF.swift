//
//  UIImageView+GIF.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 6/10/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import Foundation

extension UIImageView{
    
    func loadGifWithURL(url: NSURL) -> NSURLSessionDownloadTask {
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.requestCachePolicy = NSURLRequestCachePolicy.ReturnCacheDataElseLoad
        config.URLCache = NSURLCache.sharedURLCache()
        
        let session = NSURLSession(configuration: config)
        
        let downloadTask = session.downloadTaskWithURL(url, completionHandler: {
            [weak self] url, response, error in
            if error == nil, let url = url, data = NSData(contentsOfURL: url), image = UIImage.gifWithData(data) {
                dispatch_async(dispatch_get_main_queue()) {
                    if let strongSelf = self {
                        strongSelf.image = image
                    }
                }
            } else {
                print(error?.domain)
                print(error?.code)
            }
            session.finishTasksAndInvalidate()
        })
        
        downloadTask.resume()
        return downloadTask
    }

    
}