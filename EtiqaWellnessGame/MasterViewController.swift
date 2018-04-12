/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation

import UIKit

class MasterViewController: UIViewController {
    
    
    
    //MARK : - IBActions
    @IBAction func didTapGame(_ sender: UIButtonX) {
        HealthKitSetupAssistant.authorizeHealthKit { (authorized, error) in
            guard authorized else {
                let baseMessage = "HealthKit Authorization Failed"
                if let error = error {
                    self.onGameAuthorizationFailedEvent(baseMessage: baseMessage, error: error as NSError)
                    
                    //print("\(baseMessage). Reason: \(error.localizedDescription)")
                }else{
                    self.onGameAuthorizationFailedEvent(baseMessage: baseMessage, error: error as! NSError)
                    
                    //print(baseMessage)
                }
                return
            }
            print("HealthKit Successfully Authorized")
            HealthKitServices.retrieveStepCount(completionHandler: { (stepsCount, error) in
                if error != nil {
                    print("error")
                }else{
                    print("total steps: \(stepsCount)")
                    let message = "you have walked \(stepsCount!) steps today"
                    self.onGameStartEvent(baseMessage: message)
                }
            })
            
        }
    }
    
    //MARK : - Private Functions
    private func onGameAuthorizationFailedEvent(baseMessage: String, error: NSError){
        let alertController = UIAlertController(title: baseMessage, message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func onGameStartEvent(baseMessage: String){
        let alertController = UIAlertController(title: baseMessage, message: "Earn more wellness points now!", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Start Game", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}


