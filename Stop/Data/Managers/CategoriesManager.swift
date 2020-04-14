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
    
    func getCategories() -> [Category] {
        databaseManager.fetchCategories()
    }
    
    func deleteCategory(category: Category) {
        databaseManager.deleteCategory(category: category)
    }
}
