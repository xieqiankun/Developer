//
//  ShopViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 5/11/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController {

    
    @IBOutlet var iaps: [UIImageView]!
    
    @IBOutlet var ticketsLabel: [UILabel]!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .Custom
        transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clearColor()
        
        if triviaCurrentShop != nil {
            configueShopItems()
        } else {
            triviaFetchPurchesItems({ (shop, error) in
                self.configueShopItems()
            })
        }
        
    }
    
    func configueShopItems() {
        
        if let currentShop = triviaCurrentShop {
            for iap in iaps {
                let index = iaps.indexOf(iap)
                let item = currentShop.shopItems[index!]
                //check if there is cached image
                if item.cachedImage != nil {
                    iap.image = item.cachedImage!
                } else if let url = item.image, nsurl = NSURL(string: url)  {
                    iap.loadImageWithURL(nsurl,completion: {
                        image in
                        item.cachedImage = image
                    })
                }
            }
            for ticket in ticketsLabel {
                let index = ticketsLabel.indexOf(ticket)
                let item = currentShop.shopItems[index!]
                if let num = item.quantity where item.type == "tickets"{
                    ticket.text = String(num)
                }
            }
        }

        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close() {
        dismissViewControllerAnimated(true, completion: nil)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


// Custom Transitioning Delegate
extension ShopViewController: UIViewControllerTransitioningDelegate {
    func presentationControllerForPresentedViewController( presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController?
    {
        
        return DimmingPresentationController( presentedViewController: presented, presentingViewController: presenting)
    }
    
    func animationControllerForPresentedController( presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return FadeInAnimationController()
    }
    
    func animationControllerForDismissedController( dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeOutAnimationController()
    }
    
}
