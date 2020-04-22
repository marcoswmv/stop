//
//  ScoreboardViewController.swift
//  Stop
//
//  Created by Marcos Vicente on 17.04.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit

class ScoreboardViewController: BaseViewController {

//    MARK: - Outlets
    @IBOutlet weak var navigationBarView: NavigationBarView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var winnerName: UILabel!
    
    @IBAction func goToMainMenuOnTouchUpInside(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
//    MARK: - Properties
    
    var dataSource: ScoreboardDataSource?
    var gameManager = GameManager()
    
//    MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBarView.editButton.isHidden = true
        navigationBarView.backButton.isHidden = true
        setupDataSource()
        
        winnerName.text = gameManager.findOutTheWinner(firstPlayer: (dataSource?.firstPlayer)!,
                                                       secondPlayer: (dataSource?.secondPlayer)!)
    }
    
    func setupDataSource() {
        dataSource = ScoreboardDataSource(tableView: self.tableView)
        dataSource?.reload()
    }
}
