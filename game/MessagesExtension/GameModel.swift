//
//  GameModel.swift
//  game
//
//  Created by yesway on 2016/10/20.
//  Copyright © 2016年 joker. All rights reserved.
//

import Foundation
import Messages


struct GameModel {
    /// 战舰的位置
    let shipLocations: [Int]
    /// 游戏是否已经结束
    var isComplete: Bool
    
    var gamerStyle: GamerStyle = .Player
}

enum GamerStyle {
    case Player
    case Creater
}

extension GameModel {
    func encode() -> URL {
        let baseURL = "www.shinobicontrols.com/battleship"
        
        guard var components = URLComponents(string: baseURL) else {
            fatalError("Invalid base url")
        }
        
        var items = [URLQueryItem]()
        
        // Location
        let locationItems = shipLocations.map {
            location in
            URLQueryItem(name: "Ship_Location", value: String(location))
        }
        
        items.append(contentsOf: locationItems)
        
        // Game Complete
        let complete = isComplete ? "1" : "0"
        
        let completeItem = URLQueryItem(name: "Is_Complete", value: complete)
        items.append(completeItem)
        
        components.queryItems = items
        
        guard let url = components.url else {
            fatalError("Invalid URL components")
        }
        
        return url
    }
}

extension GameModel {
    init(from url: URL, gamer: GamerStyle) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let componentItems = components.queryItems else {
                fatalError("Invalid message url")
        }
        
        gamerStyle = gamer
        
        // Naïvely retrieve the battleship cell location from the URL
        shipLocations = componentItems.filter({ $0.name == "Ship_Location" }).map({ Int($0.value!)! })
        
        // Even more naïvely retrieve game completion stat
        let completeQueryItem = componentItems.filter({ $0.name == "Is_Complete" }).first!
        isComplete = completeQueryItem.value! == "1"
    }
}
