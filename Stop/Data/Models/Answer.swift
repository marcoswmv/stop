//
//  Answer.swift
//  Stop
//
//  Created by Marcos Vicente on 10.04.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit
import RealmSwift

class Answer: Object, Codable {
    
    @objc dynamic var categoryID: String?
    @objc dynamic var word: String?
    @objc dynamic var playerName: String?
    
    init(categoryID: String, word: String, playerName: String) {
        self.categoryID = categoryID
        self.word = word
        self.playerName = playerName
    }
    
    required init() {
        super.init()
    }
    
    override class func primaryKey() -> String? {
        return "categoryID"
    }
}
