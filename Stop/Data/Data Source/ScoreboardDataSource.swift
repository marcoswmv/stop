//
//  ScoreboardDataSource.swift
//  Stop
//
//  Created by Marcos Vicente on 17.04.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit

class ScoreboardDataSource: BaseDataSource {
    
    private let manager = GameManager()
    private(set) var data: [Player]?
    
    override func setup() {
        super.setup()
    }
    
    override func reload() {
        
        data = manager.getPlayers()
        self.tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: ScoreboardTableViewCell.identifier) as! ScoreboardTableViewCell
        
        cell.data = data![indexPath.row]
        
        return cell
    }
}
