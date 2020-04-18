//
//  Game.swift
//  Stop
//
//  Created by Marcos Vicente on 10.04.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit
import RealmSwift

class Game: Object, Codable {
    
//    MARK: -Before the game
    @objc dynamic var id: String? = nil
    @objc dynamic var letter: String? = nil
    
    var players = List<Player>()
    var categories = List<Category>()
    
//    MARK: -After the game
    @objc dynamic var winner: String? = nil
    @objc dynamic var total: String? = nil
    
    var answers = List<Answer>()

    convenience init(id: String) {
        self.init()
        self.id = id
    }
    
    required init() {
        super.init()
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
