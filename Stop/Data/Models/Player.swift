//
//  Player.swift
//  Stop
//
//  Created by Marcos Vicente on 09.04.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit
import RealmSwift

class Player: Object, Codable {
    
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var deviceName = ""
    
    @objc dynamic var points = 0
    
    required init() {
        super.init()
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: String, name: String, deviceName: String) {
        self.init()
        self.id = id
        self.name = name
        self.deviceName = deviceName
    }
}
