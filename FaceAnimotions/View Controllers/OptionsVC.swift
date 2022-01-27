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
    
    @IBOutlet weak var musicToggle: UISwitch!
    
    let defaults = UserDefaults.standard
    
    var baseFunc:BaseFunctions? = nil
    
    let particles = BaseFunctions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add particles behind interactive UI elements
        particles.setUpParticles(View: self.view, Leaves: false)
        //Add the background to the view
        baseFunc!.setUpBackground(view: self.view, imageName: "BackgroundPink")
        
        //Change the value of the toggles based on the values saved on the device
        hapticToggle.isOn = defaults.bool(forKey: "hapticOn")
        
        audioToggle.isOn = defaults.bool(forKey: "audioOn")
        
        musicToggle.isOn = defaults.bool(forKey: "musicOn")
    }
    
    //Toggle the ability for the application to use audio
    @IBAction func ToggleAudio(){
        defaults.set(audioToggle.isOn, forKey: "audioOn")
        baseFunc!.Feedback()
    }
    
    //Toggle the ability for the application to have haptics
    @IBAction func ToggleHaptic(){
        defaults.set(hapticToggle.isOn, forKey: "hapticOn")
        baseFunc!.Feedback()
    }
    
    @IBAction func ToggleMusic(){
        defaults.set(musicToggle.isOn, forKey: "musicOn")
        if(musicToggle.isOn){
            baseFunc!.StartMusic()
        }
        else{
            baseFunc!.StopMusic()
        }
    }
    
    @IBAction func Back(){
        self.dismiss(animated: true, completion: nil)
        baseFunc!.Feedback()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}
