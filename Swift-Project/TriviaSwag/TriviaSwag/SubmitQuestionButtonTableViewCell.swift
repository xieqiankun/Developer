//
//  SubmitQuestionTableViewCell.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 4/29/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

protocol SubmitQuestionButtonDelegate: class {
    func submitAction()
}

class SubmitQuestionButtonTableViewCell: UITableViewCell {

    weak var delegate: SubmitQuestionButtonDelegate?
    
    @IBAction func sumbit() {
        delegate?.submitAction()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
