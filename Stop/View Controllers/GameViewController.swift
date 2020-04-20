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
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBAction func stopWatchOnTouchUpInside(_ sender: Any) {
        stopTheGame()
    }
    
    
    //    MARK: - PROPERTIES AND METHODS
    
    var connectionManager: ConnectionManager!
    
    var game: Game?
    var player: Player?
    var dataSource: GameCategoriesDataSource?
    
    var timer = Timer()
    var (minutes, seconds, fractions) = (0, 0, 0)
    
    var gameManager = GameManager()
    var categoryName: String?
    
    var completionHandler: ((Player?, Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupDataSource()
        setupNavigationBar()
        hideKeyboardWhenTappedAround()
        handleGame()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startStopwatch()
        print(game!)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        gameManager.cleanAnswers()
        gameManager.cleanPlayers()
    }
    
    func setupDataSource() {
        dataSource = GameCategoriesDataSource(tableView: self.tableView)
        dataSource?.newGame = game
        dataSource?.reload()
    }
    
    func setupNavigationBar() {
        navigationBar.backButton.isHidden = true
        navigationBar.editButton.isHidden = true
        navigationBar.gameLetter.isHidden = false
        navigationBar.title.font = UIFont(name: UIFont.regularFontFamily, size: 30.0)
        
        navigationBar.gameLetter.text = game?.letter
    }
    
    func startStopwatch() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.handleTimer), userInfo: nil, repeats: true)
    }

    @objc func handleTimer() {
        
        fractions += 1
        if fractions > 99 {
            seconds += 1
            fractions = 0
        }
        
        if seconds == 60 {
            minutes += 1
            seconds = 0
        }
        
        let minutesString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        let secondsString = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        
        timeLabel.text = "\(minutesString):\(secondsString)"
    }
    
    func stopStopwatch() {
        timer.invalidate()
        (minutes, seconds) = (0, 0)
        timeLabel.text = "00:00"
    }
    
    func handleGame() {
        completionHandler = { [weak self] firstPlayer, stop in
            if stop {
                self?.gameManager.calculatePoints(firstPlayer: (self?.player)!)
                
                self?.stopStopwatch()
                let scoreboardViewController = ScoreboardViewController.instantiate() as! ScoreboardViewController
                self?.navigationController?.pushViewController(scoreboardViewController, animated: true)
            }
        }
    }
    
    func stopTheGame() {
        gameManager.calculatePoints(firstPlayer: player!)
        
        let data = ["player": player!, "stop": true] as [String : Any]
        connectionManager.sendData(dataDictionary: data)
        
        stopStopwatch()
        let scoreboardViewController = ScoreboardViewController.instantiate() as! ScoreboardViewController
        navigationController?.pushViewController(scoreboardViewController, animated: true)
    }
    
}
