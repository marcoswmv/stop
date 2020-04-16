//
//  GameCategoriesDataSource.swift
//  Stop
//
//  Created by Marcos Vicente on 10.04.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit

class GameCategoriesDataSource: BaseDataSource {
    
    var newGame = Game()
    
    override func setup() {
        super.setup()
    }
    
    override func reload() {
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newGame.categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: GameCategoryTableViewCell.identifier) as! GameCategoryTableViewCell
        
        cell.data = newGame.categories[indexPath.row]
        
        return cell
    }
}
