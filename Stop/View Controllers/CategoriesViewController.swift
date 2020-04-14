//
//  CategoriesViewController.swift
//  Stop
//
//  Created by Marcos Vicente on 09.04.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit
import RealmSwift

class CategoriesViewController: BaseViewController {

//    MARK: - OUTLETS
    
    @IBOutlet weak var navigationBar: NavigationBarView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteCategory: IBDesignableButton!
    @IBOutlet weak var addCategory: IBDesignableButton!
    @IBOutlet weak var doneButton: IBDesignableButton!
    
    @IBAction func deleteCategoryOnTouchUpInside(_ sender: Any) {
        deleteSelectedCategories()
    }
    
    @IBAction func addCategoryOnTouchUpInside(_ sender: Any) {
        Alert.shared.showNewCategoryAlert(on: self, with: NSLocalizedString("New category", comment: "Alert title - New category") , message: nil)
    }
    
    @IBAction func doneOnTouchUpInside(_ sender: Any) {
        completionHandler!(selectedCategories)
        navigationController?.popViewController(animated: true)
    }
    
    
    
//    MARK: - PROPERTIES AND METHODS
    
    let refreshControl = UIRefreshControl()
    
    var previousViewController: String?
    var dataSource: CategoriesDataSource?
    var categoriesManager: CategoriesManager?
    
    var completionHandler: ((_: List<Category>) -> Void)?
    var selectedCategories = List<Category>()
    var countSelected = 0
    
    var gameID: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupDataSource()
        setupUIelements()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setDoneButtonBeforeViewAppears()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        setDoneButtonBeforeViewDisappears()
    }
    
    func setupDataSource() {
        dataSource = CategoriesDataSource(tableView: self.tableView)
        dataSource?.reload()
    }
    
    func setupUIelements() {
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        tableView.isEditing = false
    }
    
    func setDoneButtonBeforeViewAppears() {
        
        if previousViewController == "GameSetupViewController" {

            doneButton.isHidden = false
            tableView.allowsSelectionDuringEditing = true
            tableView.allowsMultipleSelectionDuringEditing = true
            
        } else if previousViewController == "MainMenuViewController" {

            tableView.allowsSelection = false
            tableView.allowsMultipleSelection = false
        }
    }
    
    func setDoneButtonBeforeViewDisappears() {
        doneButton.isHidden = true
    }
    
    func deleteSelectedCategories() {
        let indexPaths = self.tableView.indexPathsForSelectedRows
        
        if let indexPaths = indexPaths {
            for indexPath in indexPaths {
                guard let categoryToDelete = dataSource?.data![indexPath.row] else { return }
                categoriesManager?.deleteCategory(category: categoryToDelete)
            }
        } else {
            Alert.shared.showBasicAlert(on: self,
                                        with: NSLocalizedString("Select a category", comment: "Alert Title - Select a category"),
                                        message: NSLocalizedString("You haven't selected any category. Select at least one to  delete!",
                                                                   comment: "Alert Message - You haven't selected any category. Select at least one to  delete!"))
        }
        
        dataSource?.reload()
    }
    
    @objc func handleRefresh() {
        dataSource?.reload()
        refreshControl.endRefreshing()
    }
}
