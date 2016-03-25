//
//  OtherGamesViewController.swift
//  Trivios Tournaments
//
//  Created by Evan Bernstein on 8/26/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import UIKit
import StoreKit

class OtherGamesViewController: UIViewController, SKStoreProductViewControllerDelegate {
    
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadPage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func loadPage() {
        let appStoreVC = SKStoreProductViewController()
        appStoreVC.delegate = self
        appStoreVC.loadProductWithParameters([SKStoreProductParameterITunesItemIdentifier: "903967339"], completionBlock: nil)
    }
    
    
    
    // MARK: - SKStoreProductViewControllerDelegate
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
