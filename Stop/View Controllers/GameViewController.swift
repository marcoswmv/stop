//
//  GameViewController.swift
//  Stop
//
//  Created by Marcos Vicente on 10.04.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit

class GameViewController: BaseViewController {

    //    MARK: - OUTLETS
    
    @IBOutlet weak var navigationBar: NavigationBarView!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    //    MARK: - PROPERTIES AND METHODS
    
    var game: Game?
    var dataSource: GameCategoriesDataSource?  // Tem que receberas categorias da propriedade game acima
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupDataSource()
        setupNavigationBar()
    }
    
    func setupDataSource() {
        dataSource = GameCategoriesDataSource(tableView: self.tableView)
        dataSource?.reload()
    }
    
    func setupNavigationBar() {
        navigationBar.backButton.isHidden = true
        navigationBar.editButton.isHidden = true
        navigationBar.gameLetter.isHidden = false
        navigationBar.title.font = UIFont(name: UIFont.regularFontFamily, size: 30.0)
        
        navigationBar.gameLetter.text = "B"
    }

}
