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
        let defaultCategories: [[String: Any]] = [["id": UUID().uuidString, "name": "Male name"],
                                                  ["id": UUID().uuidString, "name": "Female name"],
                                                  ["id": UUID().uuidString, "name": "Car brand"],
                                                  ["id": UUID().uuidString, "name": "Fruit"],
                                                  ["id": UUID().uuidString, "name": "Vegetable"],
                                                  ["id": UUID().uuidString, "name": "Color"],
                                                  ["id": UUID().uuidString, "name": "City"],
                                                  ["id": UUID().uuidString, "name": "Country"],
                                                  ["id": UUID().uuidString, "name": "Fashion brand"],
                                                  ["id": UUID().uuidString, "name": "My mother is"],
                                                  ["id": UUID().uuidString, "name": "Artist/Singer/Rapper"],
                                                  ["id": UUID().uuidString, "name": "Gadget"]]
        
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
