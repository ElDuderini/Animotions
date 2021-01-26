//
//  OptionsVC.swift
//  FaceAnimoji
//
//  Created by Justin Peters on 1/21/21.
//  Copyright © 2021 ashutosh.dingankar. All rights reserved.
//

import UIKit
import AVFoundation

class OptionsVC: UIViewController {

    @IBOutlet weak var hapticToggle: UISwitch!
    
    @IBOutlet weak var audioToggle: UISwitch!
    
    let defaults = UserDefaults.standard
    
    var baseFunc = BaseFunctions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hapticToggle.isOn = defaults.bool(forKey: "hapticOn")
        
        audioToggle.isOn = defaults.bool(forKey: "audioOn")

        // Do any additional setup after loading the view.
    }
    
    @IBAction func ToggleAudio(){
        defaults.set(audioToggle.isOn, forKey: "audioOn")
        baseFunc.Feedback()
    }
    
    @IBAction func ToggleHaptic(){
        defaults.set(hapticToggle.isOn, forKey: "hapticOn")
        baseFunc.Feedback()
    }
    
    @IBAction func Back(){
        self.dismiss(animated: true, completion: nil)
        baseFunc.Feedback()
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
