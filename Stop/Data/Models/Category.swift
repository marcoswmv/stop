//
//  Category.swift
//  Stop
//
//  Created by Marcos Vicente on 09.04.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit
import RealmSwift

class Category: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    
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
    }
    
//    deinit {
//        print("\(self) is being deinitialized")
//    }
}
