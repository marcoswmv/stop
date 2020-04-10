//
//  CategoriesViewController.swift
//  Stop
//
//  Created by Marcos Vicente on 09.04.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit

class CategoriesViewController: BaseViewController {

//    MARK: - OUTLETS
    
    @IBOutlet weak var navigationBar: NavigationBarView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteCategory: IBDesignableButton!
    @IBOutlet weak var addCategory: IBDesignableButton!
    
    @IBAction func deleteCategoryOnTouchUpInside(_ sender: Any) {
        deleteSelectedCategories()
    }
    
    @IBAction func addCategoryOnTouchUpInside(_ sender: Any) {
        addNewCategory()
    }
    
    
//    MARK: - PROPERTIES AND METHODS
    
    var dataSource: CategoriesDataSource?
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupDataSource()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.isEditing = false
    }

    func setupDataSource() {
        dataSource = CategoriesDataSource(tableView: self.tableView)
        dataSource?.reload()
    }
    
    func addNewCategory() {
        let alertController = UIAlertController(title: "New category", message: nil, preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: "Done", style: .default, handler: { action in
            
            let categoryName = alertController.textFields?.first?.text?.capitalizingFirstLetter()
            let newCategory = Category(id: UUID().uuidString, name: categoryName!)
            
            DataBaseManager.shared.insertCategory(newCategory: newCategory)
            
            self.dataSource?.reload()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addTextField { (textField) in
            textField.autocapitalizationType = .sentences
            textField.borderStyle = .none
            textField.placeholder = "Enter a name for the category"
            textField.font = UIFont(name: "AvenirNext-Regular", size: 15)
            textField.textColor = UIColor(named: "Red App")
        }
        
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func deleteSelectedCategories() {
        let indexPaths = self.tableView.indexPathsForSelectedRows
        
        if let indexPaths = indexPaths {
            for indexPath in indexPaths {
                guard let categoryToDelete = dataSource?.data![indexPath.row] else { return }
                DataBaseManager.shared.deleteCategory(category: categoryToDelete)
            }
        } else {
            let alertController = UIAlertController(title: "Select a category", message: "You haven't selected any category. Select at least one to  delete!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            alertController.addAction(okAction)
            
            present(alertController, animated: true, completion: nil)
        }
        
        dataSource?.reload()
    }
    
    @objc func handleRefresh() {
        dataSource?.reload()
        refreshControl.endRefreshing()
    }
}
