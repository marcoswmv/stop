//
//  CategoriesManager.swift
//  Stop
//
//  Created by Marcos Vicente on 14.04.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit

class CategoriesManager {
    
    private let databaseManager = DataBaseManager()
    
//    MARK: Setting default categories
    
    func setDefaultCategories() {
        let defaultCategories = [Category(id: UUID().uuidString, name: "Male name"),
                                 Category(id: UUID().uuidString, name: "Female name"),
                                 Category(id: UUID().uuidString, name: "Car brand"),
                                 Category(id: UUID().uuidString, name: "Fruit"),
                                 Category(id: UUID().uuidString, name: "Vegetable"),
                                 Category(id: UUID().uuidString, name: "Color"),
                                 Category(id: UUID().uuidString, name: "City"),
                                 Category(id: UUID().uuidString, name: "Country"),
                                 Category(id: UUID().uuidString, name: "Fashion brand"),
                                 Category(id: UUID().uuidString, name: "My mother is"),
                                 Category(id: UUID().uuidString, name: "Artist/Singer/Rapper"),
                                 Category(id: UUID().uuidString, name: "Gadget") ]
        if databaseManager.fetchCategories().isEmpty {
            for category in defaultCategories {
                databaseManager.updateCategory(newCategory: category)
            }
        }
    }
    
    func getCategories() -> [Category] {
        databaseManager.fetchCategories()
    }
    
    func deleteCategory(category: Category) {
        databaseManager.deleteCategory(category: category)
    }
}
