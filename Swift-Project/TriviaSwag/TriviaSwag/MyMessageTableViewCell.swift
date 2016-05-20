//
//  MyMessageTableViewCell.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 5/17/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

let kMyMessageBorderColor = UIColor(red: 27/255, green: 20/255, blue: 100/255, alpha: 1)
let kMyMessageBackgroundColor = UIColor(red: 213/255, green: 220/255, blue: 32/255, alpha: 1)


class MyMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var messageBody: UILabel!
    @IBOutlet weak var messageDate: UILabel!
    @IBOutlet weak var messageBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        messageBackground.backgroundColor = kMyMessageBackgroundColor
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configueCell() {
        
        messageBackground.layer.cornerRadius = 15//messageBackground.bounds.height / 5
        messageBackground.layer.borderColor = kMyMessageBorderColor.CGColor
        messageBackground.layer.borderWidth = 3.0
    }


}
