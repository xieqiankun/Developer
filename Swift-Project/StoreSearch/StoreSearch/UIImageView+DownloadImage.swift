//
//  UIImageView+DownloadImage.swift
//  StoreSearch
//
//  Created by 谢乾坤 on 4/27/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit
extension UIImageView {
    func loadImageWithURL(url: NSURL) -> NSURLSessionDownloadTask {
        let session = NSURLSession.sharedSession()
        //1
        let downloadTask = session.downloadTaskWithURL(
            url, completionHandler: { [weak self] url, response, error in
                // 2
                print(url)
                if error == nil, let url = url,
                    // 3
                    data = NSData(contentsOfURL: url), image = UIImage(data: data) {
                    // 4
                    dispatch_async(dispatch_get_main_queue()) {
                        if let strongSelf = self {
                        strongSelf.image = image
                        }
                    }
                }
            })
        // 5
        downloadTask.resume()
        return downloadTask
    }
}