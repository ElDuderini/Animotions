//
//  BaseFunctions.swift
//  FaceAnimoji
//
//  Created by Justin Peters on 1/25/21.
//  Copyright © 2021 ashutosh.dingankar. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class BaseFunctions {
    
    let defaults = UserDefaults.standard
    
    let hapticFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    var player : AVAudioPlayer?
    
    func Feedback(){
        if(defaults.bool(forKey: "audioOn")){
            playSound()
        }
        if(defaults.bool(forKey: "hapticOn")){
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
}
