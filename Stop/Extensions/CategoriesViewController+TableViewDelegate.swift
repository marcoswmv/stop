//
//  CategoriesViewController+TableViewDelegate.swift
//  Stop
//
//  Created by Marcos Vicente on 12.04.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit

extension CategoriesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if countSelected < 15 {
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.accessoryType = cell.accessoryType == .checkmark ? .none : .checkmark
            }
            
            let selectedCategory = dataSource?.data![indexPath.row]
            
            if !selectedCategories.contains(selectedCategory!) {
                selectedCategories.append(selectedCategory!)
            } else {
                for (index, category) in selectedCategories.enumerated() {
                    if category.id == selectedCategory?.id {
                        selectedCategories.remove(at: index)
                    }
                }
            }
            
            countSelected += 1
        } else {
            Alert.shared.showBasicAlert(on: UIApplication.getTopViewController()!,
                                        with: NSLocalizedString("Selection Limit", comment: "Alert title - Selection Limit"),
                                        message: NSLocalizedString("You've reached the allowed categories selection limit of 15. Please unselect some categories if you wish to select anothers.",
                                                                   comment: "Alert message - You've reached the allowed categories selection limit of 15. Please unselect some categories if you wish to select anothers."))
        }
    }
}
