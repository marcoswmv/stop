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
    
    @objc dynamic var word: String?
    @objc dynamic var categoryID: String?
    @objc dynamic var playerID: String?
    
    init(word: String, categoryID: String, playerID: String) {
        self.word = word
        self.categoryID = categoryID
        self.playerID = playerID
    }
    
    required init() {
        super.init()
    }
    
    override class func primaryKey() -> String? {
        return "word"
    }
}
