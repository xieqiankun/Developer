//
//  AnswerCellTableViewCell.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 4/29/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class AnswerCellTableViewCell: UITableViewCell {

    @IBOutlet weak var answerText: UITextField!
    
    var index: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
