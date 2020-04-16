//
//  GameCategoryTableViewCell.swift
//  Stop
//
//  Created by Marcos Vicente on 10.04.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit

class GameCategoryTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var categoryWord: UILabel!
    
    var data: Category? {
        didSet {
            category.text = data?.name
        }
    }
}
