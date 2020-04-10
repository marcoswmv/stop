//
//  Player.swift
//  Stop
//
//  Created by Marcos Vicente on 09.04.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit
import RealmSwift

class Player: Object {
    
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var points = 0
    
    required init() {
        super.init()
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: String, name: String) {
        self.init()
        self.id = id
        self.name = name
        
        if let points = addPoints() {
            self.points = points
        }
        
    }
    
    deinit {
        print("\(self) is being deinitialized")
    }
    
    
//    TODO: Think about how the points are going to de attributed
    func addPoints(points: Int? = nil) -> Int? {
        return points
    }
    
}
