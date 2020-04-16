//
//  ScoreboardTableViewCell.swift
//  Stop
//
//  Created by Marcos Vicente on 17.04.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit

class ScoreboardTableViewCell: BaseTableViewCell {

    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerPoints: UILabel!
    
    var data: Player? {
        didSet {
            playerName.text = data?.name
            playerPoints.text = data?.points.description
        }
    }
}
