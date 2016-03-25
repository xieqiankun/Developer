//
//  ShopViewController.swift
//  Trivios Tournaments
//
//  Created by Evan Bernstein on 8/24/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import UIKit

class ShopTableViewCell: UITableViewCell {
    @IBOutlet var productImageView: UIImageView!
    @IBOutlet var productDescriptionLabel: UILabel!
    @IBOutlet var productPriceLabel: UILabel!
}

class ShopViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var ticketsView: UIView!
    @IBOutlet var productsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    // MARK: - UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ShopCell", forIndexPath: indexPath) as! ShopTableViewCell
        
        //Configure cell...
        
        return cell
    }
}
