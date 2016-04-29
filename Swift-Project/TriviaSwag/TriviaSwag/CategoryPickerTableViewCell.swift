//
//  CategoryPickerTableViewCell.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 4/28/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class CategoryPickerTableViewCell: UITableViewCell {
    
    deinit{
        print("cell deinit")
    }

    @IBOutlet weak var categoryPicker: UIPickerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
