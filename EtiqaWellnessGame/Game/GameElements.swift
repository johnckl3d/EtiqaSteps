//
//  GameElements.swift
//  megajump
//
//  Created by Smurfy on 08/03/16.
//  Copyright © 2016 Smurfy. All rights reserved.
//

import SpriteKit

extension GameScene {
    
    func createBackground () -> SKNode{
        let backgroundNode = SKNode()
        let spacing = 64 * scaleFactor
        
        for index in 0 ... 19 {
            let node = SKSpriteNode(imageNamed: String(format: "Background%02d", index + 1))
            node.setScale(scaleFactor)
            node.anchorPoint = CGPoint(x: 0.5, y: 0)
            node.position = CGPoint(x: self.size.width / 2, y: spacing * CGFloat(index))
            
            backgroundNode.addChild(node)
        }
        
        return backgroundNode
    }
    
    func createMidground () -> SKNode{
        let midgroundNode = SKNode()
        var anchor:CGPoint!
        var xPos:CGFloat!
        
        
        
        for index in 0 ... 9 {
            var name:String
            
            let randomNumber = arc4random() % 2
            
            if randomNumber > 0 {
                name = "cloudLeft"
                anchor = CGPoint (x: 0, y: 0.5)
                xPos = 0
            }else{
                name = "cloudRight"
                anchor = CGPoint (x: 1, y: 0.5)
                xPos = self.size.width
            }
            let node = SKSpriteNode(imageNamed: name)
            node.anchorPoint = anchor
            node.position = CGPoint(x: xPos, y: 500 * CGFloat(index))
            midgroundNode.addChild(node)
        }
        return midgroundNode
    }
    
    func createPlayer () -> SKNode {
        let playerNode = SKNode()
        playerNode.position = CGPoint(x: self.size.width / 2, y: 80)
        
        let sprite = SKSpriteNode(imageNamed: "player")
        playerNode.addChild(sprite)
        
        
        playerNode.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 2)
         //playerNode.physicsBody?.mass = 0.5
        playerNode.physicsBody?.isDynamic = false
        playerNode.physicsBody?.allowsRotation = false
        
        playerNode.physicsBody?.restitution = 1
        playerNode.physicsBody?.friction = 0
        playerNode.physicsBody?.angularDamping = 0
        playerNode.physicsBody?.linearDamping = 0
        
        playerNode.physicsBody?.usesPreciseCollisionDetection = true
        
        playerNode.physicsBody?.categoryBitMask = CollisionBitMask.Player
        
        playerNode.physicsBody?.collisionBitMask = 0
        playerNode.physicsBody?.contactTestBitMask = CollisionBitMask.Flower | CollisionBitMask.Brick
        
        
        return playerNode
    }
    
    func createPlatformAtPosition(position: CGPoint, ofType type:PlatformType) -> PlatformNode {
        let node = PlatformNode()
        let position = CGPoint(x: position.x * scaleFactor, y: position.y)
        node.position = position
        node.name = "PLATFORMNODE"
        node.platformType = type
        
        var sprite:SKSpriteNode
        
        if type == PlatformType.normalBrick  {
            sprite = SKSpriteNode(imageNamed: "Platform")
        }else{
            sprite = SKSpriteNode(imageNamed: "PlatformBreak")
        }
        node.addChild(sprite)
        
        node.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
        
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = CollisionBitMask.Brick
        node.physicsBody?.collisionBitMask = 0
        
        return node
    }
    
    func createFlowerAtPosition(position: CGPoint, ofType type:ItemType) -> FlowerNode {
        let node = FlowerNode()
        let position = CGPoint(x: position.x * scaleFactor, y: position.y)
        node.position = position
        node.name = "FLOWERNODE"
        node.flowerType = type
        
        var sprite:SKSpriteNode
//        case vege = 0
//        case basketball = 1
//        case waterBottle = 2
//        case carrots = 3
//        case apple = 4
        if type == ItemType.vege  {
            sprite = SKSpriteNode(imageNamed: "pinkHeart")
        }else if type == ItemType.apple{
            sprite = SKSpriteNode(imageNamed: "blueMelon")
        }else if type == ItemType.waterBottle{
            sprite = SKSpriteNode(imageNamed: "orangeSquare")
        }else if type == ItemType.carrots{
            sprite = SKSpriteNode(imageNamed: "pinkDiamond")
        }else {
            sprite = SKSpriteNode(imageNamed: "redTriangle")
        }
        node.addChild(sprite)
        node.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 2)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = CollisionBitMask.Flower
        node.physicsBody?.collisionBitMask = 0
        
        return node
    }
}
