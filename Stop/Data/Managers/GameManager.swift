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
    
    func setGameParameters(gameID: String, start: Bool = false, letter: String = "", letters: [String]? = nil, categories: List<Category>? = nil, player: Player) {
        var newLetter = letter
        
        if letter == "" {
            guard let letter = letters?.randomElement() else { return }
            newLetter = letter
        }
        
        let game = Game()
        game.id = gameID
        game.letter = newLetter
        game.start = start
        
        if let categories = categories {
            for category in categories {
                game.categories.append(category)
            }
        }
        
        game.players.append(player)
        
        databaseManager.updateGame(newGame: game)
    }
    
    func joinGame(gameID: String, player: Player) {
        let game = Game()
        game.id = gameID
        game.players.append(player)
        
        databaseManager.updateGame(newGame: game)
    }
    
    func updateGameWithDataFromHost(updatedGame: Game) {
        let game = Game()
        if game.id == updatedGame.id {
            game.id = updatedGame.id
            game.letter = updatedGame.letter
            game.players.append(objectsIn: updatedGame.players)
            game.categories = updatedGame.categories
            game.start = updatedGame.start
            
            databaseManager.updateGame(newGame: game)
        } else {
            
            print("Different games!")
        }
    }
    
    func getGame(with id: String) -> Game {
        return databaseManager.fetchGame(with: id)
    }
    
    
//    func setLetterForGame(gameID: String, letter: String = "", letters: [String]? = nil) {
//        var newLetter = letter
//
//        if letter == "" {
//            guard let letter = letters?.randomElement() else { return }
//            newLetter = letter
//        }
//
//        let game = Game()
//        game.id = gameID
//        game.letter = newLetter
//
//        databaseManager.updateGame(newGame: game)
//    }
//
//    func setCategoriesForGame(gameID: String, categories: List<Category>) {
//        let game = Game()
//        game.id = gameID
//
//        for category in categories {
//            game.categories.append(category)
//        }
//
//        databaseManager.updateGame(newGame: game)
//    }
//
//    func joinGame(gameID: String, player: Player) {
//        let game = Game()
//        game.id = gameID
//
//        game.players.append(player)
//
//        databaseManager.updateGame(newGame: game)
//    }
    
    func getAnswers(categoryName: String, word: String, playerName: String) {
//        let game =
//        let categoryID = getCategoryID(name: categoryName)
//        retrieveAnswers(categoryID: categoryID, word: word, playerName: playerName)
//    }
//
//    func getGame(id: String) -> Game {
//        let games = dataBase.fetchGames()
//        let result = Game()
//
//        if games.contains(Game(id: id))
        
    }
    
    func getCategoryID(name: String) -> String {
        let categories = databaseManager.fetchCategories()
        var index = ""
        
        for category in categories {
            if category.name == name {
                index = category.id
            }
        }
        
        return index
    }
    
    func retrieveAnswers(categoryID: String, word: String, playerName: String) -> Answer {
        return Answer(categoryID: categoryID, word: word, playerName: playerName)
    }
}
