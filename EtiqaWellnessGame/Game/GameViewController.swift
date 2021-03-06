//
//  GameViewController.swift
//  megajump
//
//  Created by Smurfy on 08/03/16.
//  Copyright (c) 2016 Smurfy. All rights reserved.
//

import UIKit
import SpriteKit
import CoreMotion

class GameViewController: UIViewController {
    
    
    let pedometer = CMPedometer()
    @IBOutlet weak var skView: SKView!
    var data: Data?
    var masterViewController: MasterViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        var test1 = Int(round(stepsCount!))
//        var test2 = Int(stepsCount!)
        //print("data1::\(data?.stepsCount)")
//        pedometer.startUpdates(from: Date(), withHandler: { (pedometerData, error) in
//            if let pedData = pedometerData{
//                print(pedData.numberOfSteps)
//                GameHandler.sharedInstance.pedoSteps = Int(pedData.numberOfSteps)
//
//                //self.stepsLabel.text = "Steps:\(pedData.numberOfSteps)"
//            } else {
//                GameHandler.sharedInstance.pedoSteps = 0
//            }
//        })
        super.viewWillAppear(animated)
        let scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFit
        scene.viewWillLoad(gameVC: self)
        skView.isPaused = false
        skView.presentScene(scene)
    }
    
    func onGameEndEvent(){
        skView.isPaused = true
        var scores = [GameHandler.sharedInstance.pedoSteps, GameHandler.sharedInstance.itemsCollected, GameHandler.sharedInstance.steps]
        let total = GameHandler.sharedInstance.pedoSteps + GameHandler.sharedInstance.itemsCollected + GameHandler.sharedInstance.steps
        var validScore = 0
        if total > 10000 {
            validScore = 10000
        }else{
            validScore = total
        }
        let multiLine = """
        Apple health steps: \(scores[2])
        Fruits: \(scores[1])
        Total score: \(total)
        Valid daily score: \(validScore)
        Monthly target score: 14265/300000
        """
        let alertController = UIAlertController(title: "summary", message: "\(multiLine)", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Play again", style: UIAlertActionStyle.default){ (action) in
            alertController.dismiss(animated: true, completion: nil)
            var scene = GameScene(size: self.skView.bounds.size)
            scene.scaleMode = .aspectFit
            scene.viewWillLoad(gameVC: self)
            self.skView.isPaused = false
            self.skView.presentScene(scene)
        }
        let cancelAction = UIAlertAction(title: "Leave game", style: UIAlertActionStyle.default){ (action) in
            self.performSegue(withIdentifier: "gameToMain", sender: self)
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override var shouldAutorotate: Bool{
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
}
