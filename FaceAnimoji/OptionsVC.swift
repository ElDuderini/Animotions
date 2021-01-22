//
//  OptionsVC.swift
//  FaceAnimoji
//
//  Created by Justin Peters on 1/21/21.
//  Copyright © 2021 ashutosh.dingankar. All rights reserved.
//

import UIKit

class OptionsVC: UIViewController {

    @IBOutlet weak var hapticToggle: UISwitch!
    
    @IBOutlet weak var audioToggle: UISwitch!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hapticToggle.isOn = defaults.bool(forKey: "hapticOn")
        
        audioToggle.isOn = defaults.bool(forKey: "audioOn")

        // Do any additional setup after loading the view.
    }
    
    @IBAction func ToggleAudio(){
        defaults.set(audioToggle.isOn, forKey: "audioOn")
        Feedback()
    }
    
    @IBAction func ToggleHaptic(){
        defaults.set(hapticToggle.isOn, forKey: "hapticOn")
        Feedback()
    }
    
    func Feedback(){
        if(defaults.bool(forKey: "audioOn")){
            print("Play Sound")
        }
        if(defaults.bool(forKey: "hapticOn")){
            print("Play Haptics")
        }
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
