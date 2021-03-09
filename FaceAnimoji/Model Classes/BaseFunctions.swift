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
import ARKit
import SceneKit

class BaseFunctions {
    
    //Improve UI imagepopup
    
    //This is a class that has various functions that can be utilized in various view controllers
    
    let defaults = UserDefaults.standard
    
    let hapticFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    var player : AVAudioPlayer?
    
    //Function called that checks userDefaults to play a sound and haptic feedback
    func Feedback(){
        if(defaults.bool(forKey: "audioOn")){
            playSound()
        }
        if(defaults.bool(forKey: "hapticOn")){
            hapticFeedback.impactOccurred()
        }
    }
    
    //Play the sound that is retrived from resources
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
    
    //Function to allow the user to screenshot the ARSCN the user is currently seeing so that the UI doesn't show up in the screenshot. It returns an image just in the case for a new feature that could be developed on
    open func screenShot(sceneView:ARSCNView) -> UIImage?{
        
        let screenshotImage : UIImage? = sceneView.snapshot()
        
        if let image = screenshotImage{
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        
        return screenshotImage
    }
    
    open func imageAlert(image:UIImage, viewController:UIViewController){
        let alert = UIAlertController(title: "Screenshot saved", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        let imgViewTitle = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 40))
        imgViewTitle.image = image
        alert.view.addSubview(imgViewTitle)
        
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    //Set up the background of a viewController by using a UIview and name of the image
    func setUpBackground(view: UIView, imageName:String){
        
        let background = UIImage(named: imageName)
        
        var imageView:UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = UIView.ContentMode.scaleToFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
    }
}
