//
//  AccountInfomationTableViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 4/21/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class AccountInfomationTableViewController: UITableViewController {
    
    let fields = ["Name", "Phone Number", "Address Line 1", "Address Line 2 (Optional)", "City", "State", "Zip Code", "Country"]
    var fieldTracker = [String:String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.separatorColor = SettingSlaveCellColor
        
        
        if let user = triviaCurrentUser{
            fieldTracker["Name"] = (user.name!)
            if let p = user.phone{
                fieldTracker["Phone Number"] = p
            }
            else {
                fieldTracker["Phone Number"] = ""
            }
            if let add = user.address{
                if let l1 = add.line1{
                    fieldTracker["Address Line 1"] = l1
                }
                else {
                    fieldTracker["Address Line 1"] = ""
                }
                
                if let l2 = add.line2{
                    fieldTracker["Address Line 2 (Optional)"] = l2
                }
                else {
                   fieldTracker["Address Line 2 (Optional)"] = ""
                }
                
                if let c = add.city{
                    fieldTracker["City"] = c
                }
                else {
                    fieldTracker["City"] = ""
                }
                
                if let s = add.territory{
                    fieldTracker["State"] = s
                }
                else {
                    fieldTracker["State"] = ""
                }
                
                if let zip = add.zipCode{
                    fieldTracker["Zip Code"] = zip
                }
                else {
                    fieldTracker["Zip Code"] = ""
                }
                
                if let c = add.country{
                    fieldTracker["Country"] = c
                }
                else{
                    fieldTracker["Country"] = ""
                }
            }
        }
    }
    
    @IBAction func updateAccount(sender: UIButton) {
        var infos:[String] = []
        for i in 0...7{
            infos.append(fieldTracker[fields[i]]!)
        }
        
        let updated = triviaUserAddress(_line1: infos[2], _line2: infos[3], _city: infos[4], _zipCode: infos[6], _territory: infos[5], _country: infos[7])
        
        triviaUpdateAddress(infos[0], phone: infos[1], address: updated, completion: {(error: NSError?) in
            if let err = error{
                print(err.localizedDescription)
            }
            else {
                let alert = UIAlertController(title: "Success", message: "Your information has been successfully updated", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Continue", style: .Default, handler: {(action: UIAlertAction) in
                    
                    
                    
                }))
                
            }
        
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 1){
            return 8
        }
        return 1
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.section == 0){
            let cell = tableView.dequeueReusableCellWithIdentifier("TitleCell")
            cell?.backgroundColor = SettingSlaveTintColor
            return cell!
        }
        else if (indexPath.section == 2){
            let cell = tableView.dequeueReusableCellWithIdentifier("SaveChanges")
            cell?.backgroundColor = SettingSlaveTintColor
            return cell!
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("AccountField") as! AccountField
            cell.backgroundColor = SettingSlaveTintColor
            cell.fieldTitle.text = fields[indexPath.row]
            cell.fieldBody.text = fieldTracker[fields[indexPath.row]]
            cell.fieldBody.backgroundColor = SettingSlaveTintColor
            cell.owner = self
            return cell
        }
        
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        // TODO: - Change the color to background color
        view.tintColor = SettingSlaveTintColor
    }
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // Change the color of all cells
        cell.backgroundColor = SettingSlaveTintColor
    }

}
