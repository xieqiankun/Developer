//
//  EmbeddedWebPageViewController.swift
//  Trivios Tournaments
//
//  Created by Evan Bernstein on 8/26/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import UIKit
import WebKit

class EmbeddedWebPageViewController: UIViewController, WKNavigationDelegate {
    
    var url: NSURL?
    
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureWebView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func configureWebView() {
        loadingIndicator.startAnimating()
        
        let webView = WKWebView(frame: CGRectMake(0, view.frame.height, view.frame.width, view.frame.height))
        webView.navigationDelegate = self
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
        view.addSubview(webView)
    }
    
    
    //MARK: - WKNavigationDelegate
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        if webView.frame.origin.y != 0 {
            UIView.animateWithDuration(0.5, animations: {
                webView.frame = self.view.frame
                }, completion: { completed in
                    self.loadingIndicator.stopAnimating()
            })
        }
    }
    
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        if webView.frame.origin.y != 0 {
            let alert = UIAlertController(title: "Problem", message: "There was a problem loading the page", preferredStyle: .Alert)
            let ok = UIAlertAction(title: "Ok", style: .Default, handler: {
                action in
                dispatch_async(dispatch_get_main_queue(), {
                    self.navigationController?.popViewControllerAnimated(true)
                })
            })
            alert.addAction(ok)
            presentViewController(alert, animated: true, completion: nil)
        }
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
