//
//  GameCategoriesDataSource.swift
//  Stop
//
//  Created by Marcos Vicente on 10.04.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit

class GameCategoriesDataSource: BaseDataSource {
    
    private let manager = GameManager()
    private(set) var data: [Category]?
    
    var newGame: Game?
    
    override func setup() {
        super.setup()
    }
    
    override func reload() {
        
        if let game = newGame {
            data = manager.getGameCategories(gameID: game.id!)
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: GameCategoryTableViewCell.identifier) as! GameCategoryTableViewCell
        
        cell.data = data![indexPath.row]
        cell.categoryWord.tag = indexPath.row
        cell.category.tag = indexPath.row
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        
        return cell
    }
}
