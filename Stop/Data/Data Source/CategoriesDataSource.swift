//
//  CategoryDataSource.swift
//  Stop
//
//  Created by Marcos Vicente on 10.04.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit
import RealmSwift

class CategoriesDataSource: BaseDataSource {
    
    private let manager = DataBaseManager.shared
    private(set) var data: [Category]?
    
    override func setup() {
        super.setup()
    }
    
    override func reload() {
        
        let result = manager.fetchCategories()
        var categories = [Category]()
        
        for category in result {
            categories.append(category)
        }
        
        self.data = categories
        
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier) as! CategoryTableViewCell
        
        cell.data = data![indexPath.row]
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(named: "Secondary Red App")
        cell.selectedBackgroundView = backgroundView
        
        cell.tintColor = UIColor(named: "Red App")
        
        return cell
    }

    
//    MARK: - EDITING CELLS
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, comSmit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let categoryToDelete = data![indexPath.row]
            manager.deleteCategory(category: categoryToDelete)
            
            data?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
            
    }
    
//    MARK: - DELEGATE
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
            } else {
                cell.accessoryType = .checkmark
                
//                Where the categories are chosen
                print(data![indexPath.row].name)
            }
        }
    }

}
