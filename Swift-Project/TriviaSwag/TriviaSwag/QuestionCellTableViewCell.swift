//
//  QuestionCellTableViewCell.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 4/29/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class QuestionCellTableViewCell: UITableViewCell {

    @IBOutlet weak var textView: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
