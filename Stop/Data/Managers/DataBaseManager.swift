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
    
//    MARK: - CATEGORIES
    func createCategory(newCategory: Category) {
        let realm = try! Realm()
        try! realm.write({
            realm.add(newCategory)
        })
    }
    
    func fetchCategories() -> [Category] {
        let realm = try! Realm()
        let result = realm.objects(Category.self)
        
        var categories = [Category]()
        for category in result {
            categories.append(category)
        }
        return categories
    }
    
    func updateCategory(newCategory: Category) {
        let realm = try! Realm()
        try! realm.write({
            realm.add(newCategory, update: .modified)
        })
    }
    
    func deleteCategory(category: Category) {
        let realm = try! Realm()
        try! realm.write({
            realm.delete(category)
        })
    }
    
//    MARK: - GAME
    
    func createGame(newGame: Game) {
        let realm = try! Realm()
        try! realm.write({
            realm.add(newGame)
        })
    }
    
    func fetchAllGames() -> [Game] {
        let realm = try! Realm()
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
    
    func updateGame(newGame: Game) {
        let realm = try! Realm()
        try! realm.write({
            realm.add(newGame, update: .modified)
        })
    }
    
//    MARK: - PLAYER
    
    func createPlayer(newPlayer: Player) {
        let realm = try! Realm()
        try! realm.write({
            realm.add(newPlayer)
        })
    }
    
    func fetchPlayers() -> [Player] {
        let realm = try! Realm()
        let result = realm.objects(Player.self)
        
        var players = [Player]()
        for player in result {
            players.append(player)
        }
        return players
    }
    
    func updatePlayer(newPlayer: Player) {
        let realm = try! Realm()
        try! realm.write({
            realm.add(newPlayer, update: .modified)
        })
    }
}
