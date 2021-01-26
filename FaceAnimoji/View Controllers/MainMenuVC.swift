//
//  MainMenuVC.swift
//  FaceAnimoji
//
//  Created by Justin Peters on 1/19/21.
//  Copyright © 2021 ashutosh.dingankar. All rights reserved.
//

import UIKit
import AVFoundation

class MainMenuVC: UIViewController {

    let defaults = UserDefaults.standard
    
    var BaseFunc = BaseFunctions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if(!isKeyPresentInDefaults(key: "audioOn")){
            defaults.set(true, forKey: "audioOn")
        }
        
        if(!isKeyPresentInDefaults(key: "hapticOn")){
            defaults.set(true, forKey: "hapticOn")
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func ButtonPress(){
        BaseFunc.Feedback()
    }
    
    func isKeyPresentInDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
