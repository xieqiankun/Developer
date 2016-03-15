//
//  UIViewController.swift
//  TestWebServices
//
//  Created by 谢乾坤 on 3/11/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    var store: PhotoStore!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print(__FUNCTION__)
        
        store.fetchRecentPhotos() {
            (photoResult) -> Void in
            
            switch photoResult {
            case let .Success(photos):
                print("Successfully found \(photos.count)")
                
                if let firstPhoto = photos.first {
                    self.store.fetchImageForPhoto(firstPhoto, completion: { (imageResult) -> Void in
                        
                        switch imageResult {
                        case let .Success(image):
                            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                self.imageView.image = image
                            })
                        
                        
                        case let .Failure(error):
                            print("error")
                        }
                        
                    })
                }
                
            case let .Failure(error):
                print("error")
            }
        }
    }
    
}