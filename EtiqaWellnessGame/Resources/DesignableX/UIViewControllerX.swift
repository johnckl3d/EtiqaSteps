//
//  ViewControllerX.swift
//  002 - Credit Card Checkout
//
//  Created by Mark Moeykens on 1/4/17.
//  Copyright © 2017 Moeykens. All rights reserved.
//

import UIKit

@IBDesignable
class UIViewControllerX: UIViewController {
    
    @IBInspectable var lightStatusBar: Bool = false
   
    //MARK : - IBOutlets
    
    //MARK : - Properties
    let languages = ["English", "Melayu", "Chinese", "Khmer"]
    var selectedLanguage:String = "English"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            if lightStatusBar {
                return UIStatusBarStyle.lightContent
            } else {
                return UIStatusBarStyle.default
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLanguage()
    }
    
    private func setupLanguage(){
        let defaults = UserDefaults.standard
        if let temp = defaults.string(forKey: LANG_DICT_KEY){
            
        }else{
            defaults.set(LANG_ENG, forKey: LANG_DICT_KEY)
        }
        if let lang = defaults.string(forKey: LANG_DICT_KEY) {
            if lang == LANG_BM{
                NotificationCenter.default.post(name: LANG_NOTIFICATION, object: nil, userInfo: [LANG_DICT_KEY: LANG_BM])
            }
            else if lang == LANG_CHN{
                NotificationCenter.default.post(name: LANG_NOTIFICATION, object: nil, userInfo: [LANG_DICT_KEY: LANG_CHN])
            }else if lang == LANG_KMR{
                NotificationCenter.default.post(name: LANG_NOTIFICATION, object: nil, userInfo: [LANG_DICT_KEY: LANG_KMR])
            }else{
                NotificationCenter.default.post(name: LANG_NOTIFICATION, object: nil, userInfo: [LANG_DICT_KEY: LANG_ENG])
            }
        }
    }
}
