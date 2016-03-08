//
//  BracketTableViewController.swift
//  GStack-Swift-SDK
//
//  Created by 谢乾坤 on 3/7/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class BracketTableViewController: UITableViewController {

    var selectedTournament: GStackTournament?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor(patternImage:UIImage(named: "Background.png")!)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        GStack.sharedInstance.gStackFetchTournaments { (error, tournaments) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.tableView.reloadData()
                
                print("I am here in table view")
                print(GStack.sharedInstance.GStacKBracketTtournaments.count)
                
            })
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return GStack.sharedInstance.GStacKBracketTtournaments.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let v = UIView()
        v.backgroundColor = UIColor.clearColor()
        return v
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cellIdentifer = "BracketCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifer, forIndexPath: indexPath) as! BracketTableViewCell
        
        let tournmanet = GStack.sharedInstance.GStacKBracketTtournaments[indexPath.section]
        
        cell.selectionStyle = UITableViewCellSelectionStyle.Blue
        
        cell.tournamentName.text = tournmanet.name
        cell.tournamentStyle.text = tournmanet.style
        cell.tournamentCategory.text = tournmanet.questions?.category
        cell.tournamentQuestionNum.text = String("\(tournmanet.questions!.num!) Questions")
        
        //set ui
        cell.backgroundColor = UIColor.clearColor()
        cell.contentView.layer.borderColor = UIColor.whiteColor().CGColor
        cell.contentView.layer.cornerRadius = 8
        cell.contentView.layer.masksToBounds = true
        cell.contentView.layer.borderWidth = 2.0
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return tableView.bounds.size.height * 0.025
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.selectedTournament = GStack.sharedInstance.GStacKBracketTtournaments[indexPath.section]
        
        self.performSegueWithIdentifier("playBracket", sender: self)
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "playBracket" {
            
            let pbc = segue.destinationViewController as! PlayBracketViewController
            
            pbc.tournament = self.selectedTournament
            
            print("I am in segue and \(pbc.tournament!.name!)")
            
        }
        
    }
    

}
