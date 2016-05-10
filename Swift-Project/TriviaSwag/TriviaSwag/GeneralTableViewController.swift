//
//  GeneralTableViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 4/21/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class GeneralTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.contentInset = UIEdgeInsets(top: tableView.bounds.height * 0.05, left: 0, bottom: 0, right: 0)
        
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    // TODO: - Change the color to background color
        //view.tintColor = SettingSlaveTintColor
        
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.bounds.height * 0.05
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // Change the color of all cells
        cell.backgroundColor = SettingSlaveCellColor
    }
    
    
}
