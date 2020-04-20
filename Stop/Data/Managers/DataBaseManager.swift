//
//  DataBaseManager.swift
//  Stop
//
//  Created by Marcos Vicente on 09.04.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit
import RealmSwift

class DataBaseManager {
    
    let realm = try! Realm()
    
//    MARK: - CATEGORIES
    func createCategory(newCategory: Category) {
        try! realm.write({
            realm.add(newCategory)
        })
    }
    
    func fetchCategories() -> [Category] {
        let result = realm.objects(Category.self)
        
        var categories = [Category]()
        for category in result {
            categories.append(category)
        }
        return categories
    }
    
    func updateCategory(newCategory: [String: Any]) {
        try! realm.write({
            realm.create(Category.self, value: newCategory, update: .modified)
        })
    }
    
    func deleteCategory(category: Category) {
        try! realm.write({
            realm.delete(category)
        })
    }
    
//    MARK: - GAME
    
    func createGame(newGame: Game) {
        try! realm.write({
            realm.add(newGame)
        })
    }
    
    func fetchAllGames() -> [Game] {
        let result = realm.objects(Game.self)
        
        var games = [Game]()
        for game in result {
            games.append(game)
        }
        return games
    }
    
    func fetchGame(with ID: String) -> Game {
        var foundGame = Game()
        let games = fetchAllGames()
        
        for game in games {
            if game.id == ID {
                foundGame = game
            }
        }
        return foundGame
    }
    
    func updateGame(newGame: [String: Any]) {
        try! realm.write({
            realm.create(Game.self, value: newGame, update: .modified)
        })
    }
    
//    MARK: - PLAYER
    
    func createPlayer(newPlayer: Player) {
        try! realm.write({
            realm.add(newPlayer)
        })
    }
    
    func fetchAllPlayers() -> [Player] {
        let result = realm.objects(Player.self)
        
        var players = [Player]()
        for player in result {
            players.append(player)
        }
        return players
    }
    
    func fetchPlayer(with ID: String) -> Player {
        var foundPlayer = Player()
        let players = fetchAllPlayers()
        
        for player in players {
            if player.id == ID {
                foundPlayer = player
            }
        }
        return foundPlayer
    }
    
    func updatePlayer(newPlayer: [String: Any]) {
        try! realm.write({
            realm.create(Player.self, value: newPlayer, update: .modified)
        })
    }
    
    func deleteAllPlayers(){
        let players = realm.objects(Player.self)
        
        try! realm.write {
            realm.delete(players)
        }
    }
    
//    MARK: - ANSWERS
    
    func createAnswer(newAnswer: Answer) {
        try! realm.write({
            realm.add(newAnswer, update: .modified)
        })
    }
    
    func fetchAllAnswers() -> [Answer] {
        let result = realm.objects(Answer.self)
        
        var answers = [Answer]()
        for answer in result {
            answers.append(answer)
        }
        return answers
    }
    
    func updateAnswer(newAnswer: [String: Any]) {
        try! realm.write({
            realm.create(Answer.self, value: newAnswer, update: .modified)
        })
    }
    
    func deleteAllAnswers(){
        let answers = realm.objects(Answer.self)
        
        try! realm.write {
            realm.delete(answers)
        }
    }
}
