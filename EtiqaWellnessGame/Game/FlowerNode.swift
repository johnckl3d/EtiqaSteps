//
//  FlowerNode.swift
//  megajump
//
//  Created by Smurfy on 09/03/16.
//  Copyright © 2016 Smurfy. All rights reserved.
//

import SpriteKit

enum ItemType:Int {
    case vege = 0
    case basketball = 1
     case waterBottle = 2
     case carrots = 3
     case apple = 4
}

class FlowerNode: GenericNode {

    var flowerType:ItemType!
    
    override func collisionWithPlayer(player: SKNode) -> Bool {
        player.physicsBody?.velocity = CGVector(dx: player.physicsBody!.velocity.dx , dy: 400)
          GameHandler.sharedInstance.itemsCollected += 1
//        if flowerType == ItemType.basketball{
//            GameHandler.sharedInstance.itemsCollected += 200
//        } else if flowerType == ItemType.waterBottle{
//            GameHandler.sharedInstance.itemsCollected += 100
//        }else if flowerType == ItemType.carrots{
//            GameHandler.sharedInstance.itemsCollected += 50
//        }else if flowerType == ItemType.apple{
//            GameHandler.sharedInstance.itemsCollected += 20
//        }
//        else if flowerType == ItemType.vege{
//            GameHandler.sharedInstance.itemsCollected += 10
//        }
        //GameHandler.sharedInstance.itemsCollected += (flowerType == ItemType.basketball ? 20: 100)
        //GameHandler.sharedInstance.itemsCollected += (flowerType == ItemType.vege ? 1: 5)
        self.removeFromParent()
        
        return true
    }
}
