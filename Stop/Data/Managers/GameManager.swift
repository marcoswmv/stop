//
//  GameManager.swift
//  Stop
//
//  Created by Marcos Vicente on 10.04.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit
import RealmSwift

class GameManager {
    
    private let databaseManager = DataBaseManager()
    
    func createNewGame() -> Game {
        let newGame = Game(id: UUID().uuidString)
        
        databaseManager.createGame(newGame: newGame)
        return newGame
    }
    
    func createNewPlayer(name: String, deviceName: String) -> Player {
        let newPlayer = Player(id: UUID().uuidString, name: name, deviceName: deviceName)
        
        databaseManager.createPlayer(newPlayer: newPlayer)
        
        return newPlayer
    }
    
    func setGameParameters(gameID: String, letter: String = "", letters: [String]? = nil, categories: List<Category>? = nil, player: Player) {
        var newLetter = letter
        
        if letter == "" {
            guard let letter = letters?.randomElement() else { return }
            newLetter = letter
        }
        
        var categoriesToUse = [Category]()
        
        if categories!.isEmpty {
            categoriesToUse = setRandomCategories()
        } else {
            for category in categories! {
                categoriesToUse.append(category)
            }
        }
        
        let game = Game()
        game.id = gameID
        game.letter = newLetter
        game.categories.append(objectsIn: categoriesToUse)
        game.players.append(player)
        
        databaseManager.updateGame(newGame: game)
    }
    
    func setRandomCategories() -> [Category] {
        let categories = databaseManager.fetchCategories()
        var categoriesToReturn = [Category]()
        
        while (categoriesToReturn.count < 8) {
            let randomCategory = categories.randomElement()!
            if !categoriesToReturn.contains(randomCategory) {
                categoriesToReturn.append(randomCategory)
            }
        }
        
        return categoriesToReturn
    }
    
    func joinGame(gameID: String, player: Player) {
        let game = Game()
        game.id = gameID
        
        let realm = try! Realm()
        try! realm.write({
            game.players.append(player)
        })
        
        databaseManager.updateGame(newGame: game)
    }
    
    func updateGameWithDataFromHost(updatedGame: Game, player: Player? = nil) -> Game {
        let game = Game()
        game.id = updatedGame.id
        game.letter = updatedGame.letter
        game.players.append(objectsIn: updatedGame.players)
        game.categories = updatedGame.categories
        
        if let player = player {
            game.players.append(player)
        }
        
        databaseManager.updateGame(newGame: game)
        return game
    }
    
    func getPlayers() -> [Player] {
        return databaseManager.fetchPlayers()
    }
    
    func getGame(with id: String) -> Game {
        return databaseManager.fetchGame(with: id)
    }
    
    func getGameCategories(gameID: String) -> [Category] {
        let categoriesFromDatabase = getGame(with: gameID).categories
        var categories = [Category]()
        
        categories.append(contentsOf: categoriesFromDatabase)
        
        return categories
    }
    
    func getCategoryID(name: String) -> String {
        let categories = databaseManager.fetchCategories()
        var index = ""
        
        for category in categories {
            if category.name == name {
                index = category.id!
            }
        }
        
        return index
    }
    
    func retrieveAnswers(categoryID: String, word: String, playerName: String) -> Answer {
        return Answer(categoryID: categoryID, word: word, playerName: playerName)
    }
}
