//
//  GameScene.swift
//  megajump
//
//  Created by Smurfy on 08/03/16.
//  Copyright (c) 2016 Smurfy. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    //MARK : - Properties
    weak var gameViewController: GameViewController?
    var background: SKNode!
    var midground: SKNode!
    var foreground: SKNode!
    var hud: SKNode!
    var player: SKNode!
    var scaleFactor: CGFloat!
    var startButton = SKSpriteNode(imageNamed: "TapToStart")
    var endOfGamePosition = 0
    var motionManager = CMMotionManager()
    var queue = OperationQueue()
    var xAcceleration:CGFloat = 0.0
    
    var itemsCollected:SKLabelNode!
    var stepsLabel:SKLabelNode!
    var detectedStepsLabel:SKLabelNode!
    var nextStepsLabel:SKLabelNode!
    var playerMaxY:Int!
    var gameOver = false
    var currentMaxY:Int!
    
    var pedometer = CMPedometer()
    var timer = Timer()
    var timerInterval = 1.0
    var timeElapsed:TimeInterval = 1.0
    var numberOfSteps:Int! = 0
    var nextStepsTarget: [Int] = [1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000]
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize){
        
        super.init(size: size)
        
        backgroundColor = SKColor.white
        
        currentMaxY = 80
        GameHandler.sharedInstance.pedoSteps = 0
        gameOver = false
        
        endOfGamePosition = levelData!["EndOfLevel"] as! Int
        
        scaleFactor = self.size.width / 320
        background = createBackground()
        addChild(background)
        
        midground = createMidground()
        addChild(midground)
        
        foreground = SKNode()
        addChild(foreground)
        
        player = createPlayer()
        foreground.addChild(player)
        
        hud = SKNode()
        addChild(hud)
        startButton.position = CGPoint(x: self.size.width / 2, y: 180)
        hud.addChild(startButton)
        
        itemsCollected = SKLabelNode(fontNamed: "AmericanTypeWriter-Bold")
        itemsCollected.fontSize = 12
        itemsCollected.fontColor = SKColor.white
        itemsCollected.position = CGPoint(x: 10, y: self.size.height-80)
        itemsCollected.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        itemsCollected.text = "items collected: \(GameHandler.sharedInstance.itemsCollected)"
        hud.addChild(itemsCollected)
        
        stepsLabel = SKLabelNode(fontNamed: "AmericanTypeWriter-Bold")
        stepsLabel.fontSize = 12
        stepsLabel.fontColor = SKColor.white
        stepsLabel.position = CGPoint(x: 10, y: self.size.height-40)
        stepsLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        stepsLabel.text = "registered steps: \(GameHandler.sharedInstance.steps)"
        hud.addChild(stepsLabel)
        
        
        
        detectedStepsLabel = SKLabelNode(fontNamed: "AmericanTypeWriter-Bold")
        detectedStepsLabel.fontSize = 12
        detectedStepsLabel.fontColor = SKColor.white
        detectedStepsLabel.position = CGPoint(x: self.size.width-20, y: self.size.height-40)
        detectedStepsLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        
        detectedStepsLabel.text = "detected steps: 0"
        hud.addChild(detectedStepsLabel)
        
        nextStepsLabel = SKLabelNode(fontNamed: "AmericanTypeWriter-Bold")
        nextStepsLabel.fontSize = 12
        nextStepsLabel.fontColor = SKColor.white
        nextStepsLabel.position = CGPoint(x: self.size.width-20, y: self.size.height-80)
        nextStepsLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        
        nextStepsLabel.text = "next level: --"
        hud.addChild(nextStepsLabel)
        
        startTimer()
        
        generateLevel(val: 0)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -2)
        physicsWorld.contactDelegate  = self
        
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: queue) { (data, error) in
            if let accelerometerData = data {
                let acceleration = accelerometerData.acceleration
                self.xAcceleration = (CGFloat(acceleration.x) * 0.75 + (self.xAcceleration * 0.25))
            }
        }
    }
    
    private func startCountingSteps(){
        
    }
    
    func viewWillLoad(gameVC:GameViewController){
        gameViewController = gameVC
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var updateHUD = false
        var otherNode:SKNode!
        
        if contact.bodyA.node != player {
            otherNode = contact.bodyA.node
        }else{
            otherNode = contact.bodyB.node
        }
        
        updateHUD = (otherNode as! GenericNode).collisionWithPlayer(player: player)
        if updateHUD == true {
            itemsCollected.text = "items collected: \(GameHandler.sharedInstance.itemsCollected)"
        }
        (otherNode as! GenericNode).collisionWithPlayer(player: player)
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        foreground.enumerateChildNodes(withName: "PLATFORMNODE") { (node, stop) in
            let platform = node as! PlatformNode
            platform.shouldRemoveNode(playerY: self.player.position.y)
        }
        foreground.enumerateChildNodes(withName: "FLOWERNODE") { (node, stop) in
            let flower = node as! FlowerNode
            flower.shouldRemoveNode(playerY: self.player.position.y)
        }
        if player.position.y > 200 {
            background.position = CGPoint(x: 0, y: -((player.position.y - 200)/10))
            midground.position = CGPoint(x: 0, y: -((player.position.y - 200)/4))
            foreground.position = CGPoint(x: 0, y: -(player.position.y - 200))
        }
        
        //        if Int(player.position.y) > currentMaxY {
        //            GameHandler.sharedInstance.score += Int(player.position.y) - currentMaxY
        //            currentMaxY = Int(player.position.y)
        //            scoreLabel.text = "\(GameHandler.sharedInstance.score)"
        //        }
        
        if Int(player.position.y) > endOfGamePosition, gameOver == false{
            onGameEndEvent()
        }
        
        if Int(player.position.y) < currentMaxY - 800, gameOver == false {
            onGameEndEvent()
        }
    }
    
    
    private func onGameEndEvent(){
        pedometer.stopUpdates()
        player.physicsBody!.isDynamic = false
        gameOver = true
        GameHandler.sharedInstance.saveGameStats()
        itemsCollected.text = "items collected: \(GameHandler.sharedInstance.itemsCollected)"
        detectedStepsLabel.text = String(format:"detected steps: %i",GameHandler.sharedInstance.pedoSteps)
        gameViewController?.onGameEndEvent()
    }
    
    func onGameStartEvent(){
        let transition = SKTransition.fade(withDuration: 0.5)
        let gameScene = GameScene(size: self.size)
        self.view?.presentScene(gameScene, transition: transition)
    }
    
    override func didSimulatePhysics() {
        player.physicsBody?.velocity = CGVector(dx: xAcceleration * 400, dy: (player.physicsBody?.velocity.dy)!)
        if player.position.x < -20 {
            player.position = CGPoint(x: self.size.width + 20, y: player.position.y)
        }else if (player.position.x > self.size.width + 20) {
            player.position = CGPoint(x: -20, y: player.position.y)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if player.physicsBody!.isDynamic {
            return
        }
        //Start the pedometer
        pedometer = CMPedometer()
        pedometer.startUpdates(from: Date(), withHandler: { (pedometerData, error) in
            if let pedData = pedometerData{
                //print(pedData.numberOfSteps)
                self.numberOfSteps = Int(pedData.numberOfSteps)
                if self.numberOfSteps < 20 {
                    self.nextStepsLabel.text = "next level: 20"
                }
                else if self.numberOfSteps < 50 {
                    self.nextStepsLabel.text = "next level: 50"
                }
                else if self.numberOfSteps < 100 {
                    self.nextStepsLabel.text = "next level: 100"
                }
                else if self.numberOfSteps < 500 {
                    self.nextStepsLabel.text = "next level: 500"
                }
                else if self.numberOfSteps < 1000 {
                    self.nextStepsLabel.text = "next level: 1000"
                }
                else if self.numberOfSteps < 3000 {
                    self.nextStepsLabel.text = "next level: 3000"
                }
                else if self.numberOfSteps < 5000 {
                    self.nextStepsLabel.text = "next level: 5000"
                }
                else if self.numberOfSteps < 7000 {
                    self.nextStepsLabel.text = "next level: 7000"
                }
                else if self.numberOfSteps < 10000 {
                    self.nextStepsLabel.text = "next level: 10000"
                }
                else {
                    self.nextStepsLabel.text = "YOU HAVE ACHIEVED MAXIMUM WELLNESS!!"
                }
                //GameHandler.sharedInstance.pedoSteps = Int(pedData.numberOfSteps)
                
                //self.stepsLabel.text = "Steps:\(pedData.numberOfSteps)"
            } else {
                GameHandler.sharedInstance.pedoSteps = 0
            }
        })
        startButton.removeFromParent()
        player.physicsBody?.isDynamic = true
        player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 200))
    }
    
    func startTimer(){
        if timer.isValid { timer.invalidate() }
        timer = Timer.scheduledTimer(timeInterval: timerInterval,target: self,selector: #selector(timerAction(timer:)) ,userInfo: nil,repeats: true)
    }
    
    private func stopTimer(){
        timer.invalidate()
        displayPedometerData()
    }
    
    func displayPedometerData(){
        timeElapsed += 1.0
        //Number of steps
        if let numberOfSteps = self.numberOfSteps{
            detectedStepsLabel.text = String(format:"detected steps: %i",numberOfSteps)
        }
    }
    
    @objc func timerAction(timer:Timer){
        displayPedometerData()
    }
    
    func generateLevel(val value:Int){
        
        if let path = Bundle.main.path(forResource: "Level01", ofType: "plist"){
            if let level = NSDictionary(contentsOfFile: path){
                let levelData:NSDictionary = level
                if value == 1 {
                    let platforms = levelData["Platforms"] as! NSDictionary
                    let platformPatterns = platforms["Patterns"] as! NSDictionary
                    let platformPositions = platforms["Positions"] as! [NSDictionary]
                    
                    for platformPosition in platformPositions{
                        let x = platformPosition["x"] as! Float
                        let y = platformPosition["y"] as! Float
                        let pattern = platformPosition["pattern"] as! NSString
                        
                        let platformPattern = platformPatterns[pattern] as! [NSDictionary]
                        for platformPoint in platformPattern{
                            let xValue = platformPoint["x"] as! Float
                            let yValue = platformPoint["y"] as! Float
                            let type = PlatformType(rawValue: platformPoint["type"] as! Int)
                            let xPosition = CGFloat(xValue + x)
                            let yPosition = CGFloat(yValue + y)
                            
                            let platformNode = createPlatformAtPosition(position: CGPoint(x: xPosition, y: yPosition), ofType: type!)
                            foreground.addChild(platformNode)
                        }
                    }
                    
                    let flowers = levelData["Flowers"] as! NSDictionary
                    let flowerPatterns = flowers["Patterns"] as! NSDictionary
                    let flowerPositions = flowers["Positions"] as! [NSDictionary]
                    
                    for flowerPosition in flowerPositions{
                        let x = flowerPosition["x"] as! Float
                        let y = flowerPosition["y"] as! Float
                        let pattern = flowerPosition["pattern"] as! NSString
                        
                        let flowerPattern = flowerPatterns[pattern] as! [NSDictionary]
                        for flowerPoint in flowerPattern{
                            let xValue = flowerPoint["x"] as! Float
                            let yValue = flowerPoint["y"] as! Float
                            //var type = ItemType(rawValue: flowerPoint["type"] as! Int)
                            let rand = arc4random_uniform(5)
                            let type = ItemType(rawValue: Int(rand))
                            let xPosition = CGFloat(xValue + x)
                            let yPosition = CGFloat(yValue + y)
                            
                            let flowerNode = createFlowerAtPosition(position: CGPoint(x: xPosition, y: yPosition), ofType: type!)
                            foreground.addChild(flowerNode)
                        }
                    }
                }
            }
        }
        
        
    }
}
