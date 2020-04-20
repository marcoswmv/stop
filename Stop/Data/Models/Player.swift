//
//  Player.swift
//  Stop
//
//  Created by Marcos Vicente on 09.04.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class Player: Object, Codable {
    
    @objc dynamic var id: String? = nil
    @objc dynamic var name: String? = nil
    @objc dynamic var deviceName: String? = nil
    @objc dynamic var game: Game?
    @objc dynamic var points = 0
    
    var answers = List<Answer>()
    
    convenience init(id: String, name: String, deviceName: String, game: Game) {
        self.init()
        self.id = id
        self.name = name
        self.deviceName = deviceName
        self.game = game
    }
    
    required init() {
        super.init()
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    
}
