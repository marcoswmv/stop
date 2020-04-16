//
//  Game.swift
//  Stop
//
//  Created by Marcos Vicente on 10.04.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit
import RealmSwift

class Game: Object, Codable {
    
//    MARK: -Before the game
    @objc dynamic var id: String? = nil
    @objc dynamic var letter: String? = nil
    
    var players = List<Player>()
    var categories = List<Category>()
    
//    MARK: -After the game
    @objc dynamic var winner: String? = nil
    @objc dynamic var total: String? = nil
    
    var answers = List<Answer>()

    convenience init(id: String) {
        self.init()
        self.id = id
    }
    
    required init() {
        super.init()
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    
//    MARK: - CODABLE (Json)
    
    enum CodingKeys: String, CodingKey {
        case id
        case letter
        case winner
        case total
        case additionalInfo
    }
    
    enum AdditionalInfoKeys: RealmCollectionValue, CodingKey {
        case players
        case categories
        case answers
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(String.self, forKey: .id)
        letter = try values.decode(String.self, forKey: .letter)
        winner = try values.decode(String.self, forKey: .letter)
        total = try values.decode(String.self, forKey: .letter)
        
        let collections = try values.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .additionalInfo)
        
        players = try collections.decode(List<Player>.self, forKey: .players)
        categories = try collections.decode(List<Category>.self, forKey: .categories)
        answers = try collections.decode(List<Answer>.self, forKey: .answers)
    }
    
    func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try values.encode(id, forKey: .id)
        try values.encode(letter, forKey: .letter)
        try values.encode(winner, forKey: .winner)
        try values.encode(total, forKey: .total)
        
        var collections = values.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .additionalInfo)
        try collections.encode(players, forKey: .players)
        try collections.encode(categories, forKey: .categories)
        try collections.encode(answers, forKey: .answers)
    }
    
}
