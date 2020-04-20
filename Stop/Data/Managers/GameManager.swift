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
    
    func createNewPlayer(name: String, deviceName: String, game: Game) -> Player {
        let newPlayer = Player(id: UUID().uuidString, name: name, deviceName: deviceName, game: game)
        
        databaseManager.createPlayer(newPlayer: newPlayer)
        
        return newPlayer
    }
    
//    func setGameParameters(gameToSet: Game,
//                               letter: String = "",
//                               letters: [String]? = nil,
//                               categories: List<Category>? = nil,
//                               typeOfPlayer: TypeOfPlayer,
//                               player: Player) -> Game {
//
//            let realm = databaseManager.realm
//
//            var newLetter = letter
//            var categoriesToUse = List<Category>()
//
//            try! realm.write({
//                gameToSet.players.append(player)
//
//    //            let predicate = NSPredicate(format: "id = %@", argumentArray: [player.id!])
//    //            let playerToUpdate = realm.objects(Player.self).filter(predicate).first
//    //            playerToUpdate!.name = playerName
//            })
//
//            if typeOfPlayer == .Host {
//
//                if letter == "" {
//                    if let randomLetter = letters?.randomElement() { newLetter = randomLetter }
//                } else {
//                    newLetter = letter
//                }
//
//                if categories!.isEmpty {
//                    categoriesToUse = setRandomCategories()
//                } else {
//                    categoriesToUse = categories!
//                }
//            }
//
//            let dict = ["id": gameToSet.id!,
//                        "letter": newLetter,
//                        "categories": categoriesToUse] as [String : Any]
//            databaseManager.updateGame(realm: realm, newGame: dict)
//            return databaseManager.fetchGame(realm: realm, with: gameToSet.id!)
//        }
    
    func setGameParameters(gameToSet: Game,
                           letter: String = "",
                           letters: [String]? = nil,
                           categories: List<Category>? = nil,
                           typeOfPlayer: TypeOfPlayer,
                           player: Player) -> Game {
        
        let realm = databaseManager.realm
        
        let game = Game()
        game.id = gameToSet.id
        
        try! realm.write({
            if typeOfPlayer == .Host {
                var newLetter = letter
                
                if letter == "", let letter = letters?.randomElement() {
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
                
                game.letter = newLetter
                game.categories.append(objectsIn: categoriesToUse)
            }
            game.players.append(player)
            
            realm.add(game, update: .modified)
        })
        
//        databaseManager.updateGame(realm: realm, newGame: game)
        return databaseManager.fetchGame(with: gameToSet.id!)
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
    
    func joinGame(gameToJoin: Game, player: Player) {

        let realm = try! Realm()
        try! realm.write({
            gameToJoin.players.append(player)
        })
    }
    
    func updateGameWithDataFromHost(gameToUpdate: Game, player: Player? = nil) -> Game {
        
        let realm = databaseManager.realm
//
//        let game = Game()
//        game.id = gameToUpdate.id
        
        try! realm.write({
//            game.letter = gameToUpdate.letter
//
//            if game.categories.isEmpty {
//                game.categories = gameToUpdate.categories
//            }
//
//            for playerUpdate in gameToUpdate.players {
//                let predicate = NSPredicate(format: "id = %@", argumentArray: [playerUpdate.id!])
//                let playerToUpdate = realm.objects(Player.self).filter(predicate).first
//
//                playerToUpdate?.name = playerUpdate.name
//            }
            
            if let player = player {
                if gameToUpdate.players.contains(player) {
                    gameToUpdate.players.first { $0.id == player.id }?.name = player.name
                }
            }
        })
        
        
        
        let dict = ["id": gameToUpdate.id!,
                    "letter": gameToUpdate.letter!,
                    "players": gameToUpdate.players,
                    "categories": gameToUpdate.categories] as [String : Any]
        databaseManager.updateGame(newGame: dict)
        return databaseManager.fetchGame(with: gameToUpdate.id!)
    }
    
    func getPlayers() -> [Player] {
        return databaseManager.fetchAllPlayers()
    }
    
    func updatePlayers(player: Player, name: String) -> Player {
        let dict = ["id": player.id!, "name": name]
        
        databaseManager.updatePlayer(newPlayer: dict)
        return databaseManager.fetchPlayer(with: player.id!)
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
    
    func retrievePlayerAnswers(player: Player) {
        let playersAnswers = fetchPlayersAnswers(with: player.id!)
        
//        let realm = databaseManager.realm
        
//        try! realm.write({
//            for answer in playersAnswers {
//                if !player.answers.contains(answer) {
//                    player.answers.append(answer)
//                }
//            }
//        })
        let dict = ["id": player.id!, "answers": playersAnswers] as [String : Any]
        databaseManager.updatePlayer(newPlayer: dict)
    }
    
    func fetchPlayersAnswers(with playersID: String) -> [Answer] {
        var foundAnswers = [Answer]()
        let answers = databaseManager.fetchAllAnswers()
        
        for answer in answers {
            if answer.playerID == playersID {
                foundAnswers.append(answer)
            }
        }
        return foundAnswers
    }
    
    func saveAnswer(categoryID: String, word: String, player: Player) {
        let newAnswer = Answer(word: word, categoryID: categoryID, playerID: player.id!)
        databaseManager.createAnswer(newAnswer: newAnswer)
    }
    
    func cleanAnswers() {
        databaseManager.deleteAllAnswers()
    }
    
    func cleanPlayers() {
        databaseManager.deleteAllPlayers()
    }
    
    func calculatePoints(firstPlayer: Player) {
        let players = databaseManager.fetchAllPlayers()
        let secondPlayer = players.first { $0.name != firstPlayer.name}!
        
        
        print("Second player: ", secondPlayer)
        
        let firstPlayerAnswers = firstPlayer.answers
        let secondPlayerAnswers = secondPlayer.answers
        
        var firstPlayerPoints = 0
        var secondPlayerPoints = 0
        
        var count = 0
        
        while (count < firstPlayerAnswers.count && count < secondPlayerAnswers.count) {
            /// 5 points each if the answers were the same
            if firstPlayerAnswers[count] == secondPlayerAnswers[count] {
                firstPlayerPoints += 5
                secondPlayerPoints += 5
            } else {
                firstPlayerPoints += 10
                secondPlayerPoints += 10
            }
            count += 1
        }
        
        let realm = try! Realm()
        
        try! realm.write({
            firstPlayer.points = firstPlayerPoints
            secondPlayer.points = secondPlayerPoints
        })
        
        let dict1 = ["id": firstPlayer.id!, "points": firstPlayerPoints] as [String : Any]
        let dict2 = ["id": secondPlayer.id!, "points": secondPlayerPoints] as [String : Any]
        databaseManager.updatePlayer(newPlayer: dict1)
        databaseManager.updatePlayer(newPlayer: dict2)
    }
    
    func findOutTheWinner(firstPlayer: Player, secondPlayer: Player) -> String? {
//        let firstPlayer = game.players[0]
//        let secondPlayer = game.players[1]
        
        if firstPlayer.points > secondPlayer.points {
            return "The winner is \(firstPlayer.name!)"
        } else if firstPlayer.points < secondPlayer.points {
            return "The winner is \(secondPlayer.name!)"
        } else {
            return "It was a draw"
        }
    }
}
