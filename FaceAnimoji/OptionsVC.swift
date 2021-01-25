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
    
    let hapticFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    var player : AVAudioPlayer?
    
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
            playSound()
        }
        if(defaults.bool(forKey: "hapticOn")){
            print("Play Haptics")
            hapticFeedback.impactOccurred()
        }
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "confirmSound", withExtension: ".wav") else {return}
        
        do{
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error{
            print(error.localizedDescription)
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
