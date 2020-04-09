//
//  DataBaseManager.swift
//  Stop
//
//  Created by Marcos Vicente on 09.04.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit
import RealmSwift

class DataBaseManager {
    
    static let shared = DataBaseManager()
    
    func insertCategory(newCategory: Category) {
        let realm = try! Realm()
        try! realm.write({
            realm.add(newCategory, update: .modified)
        })
    }
    
    func fetchCategories() -> Results<Category> {
        let realm = try! Realm()
        return realm.objects(Category.self)
    }
    
    func updateCategory(newCategory: Category) {
        let realm = try! Realm()
        try! realm.write({
            realm.add(newCategory, update: .modified)
        })
    }
    
    func deleteCategory(category: Category) {
        let realm = try! Realm()
        try! realm.write({
            realm.delete(category)
        })
    }
}
