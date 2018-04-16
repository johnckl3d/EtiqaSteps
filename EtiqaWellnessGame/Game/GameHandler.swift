//
//  GameHandler.swift
//  megajump
//
//  Created by John Cheang on 08/04/2018.
//  Copyright © 2018 Smurfy. All rights reserved.
//

import Foundation

class GameHandler {
    var pedoSteps: Int
    var pedoStepsHighScore: Int
    var itemsCollected: Int
    var steps: Int
    
    var levelData: NSDictionary!
    
    static let sharedInstance = GameHandler()
    
    private init() {
        pedoSteps = 0
        pedoStepsHighScore = 0
        itemsCollected = 0
        steps = 0
        
        let defaults = UserDefaults.standard
        pedoStepsHighScore = defaults.integer(forKey: "pedoStepsHighScore")
        itemsCollected = defaults.integer(forKey: "flowers")
        steps = defaults.integer(forKey: "stepsCount")
        if let path = Bundle.main.path(forResource: "Level01", ofType: "plist"){
            if let level = NSDictionary(contentsOfFile: path){
                levelData = level
            }
        }
    }
    
    func saveGameStats() {
        pedoStepsHighScore = max(pedoSteps, pedoStepsHighScore)
        let defaults = UserDefaults.standard
        defaults.set(pedoStepsHighScore, forKey: "pedoStepsHighScore")
        defaults.set(itemsCollected, forKey: "flowers")
        defaults.synchronize()
    }
}
