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
import SpriteKit

class BaseFunctions {
    
    //This is a class that has various functions that can be utilized in various view controllers
    
    let defaults = UserDefaults.standard
    
    let hapticFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    var soundPlayer : AVAudioPlayer?
    
    var musicPlayer : AVAudioPlayer?
    
    var skView = SKView()
    
    //Function called that checks userDefaults to play a sound and haptic feedback
    func Feedback(){
        if(defaults.bool(forKey: "audioOn")){
            playSound()
        }
        if(defaults.bool(forKey: "hapticOn")){
            hapticFeedback.impactOccurred()
        }
    }
    
    func StartMusic(){
        
        guard let url = Bundle.main.url(forResource: "BGMusic", withExtension: ".wav") else {return}
        
        do{
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            musicPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            
            guard let player = musicPlayer else { return }
            
            player.play()
            player.numberOfLoops = 999999999
            
        } catch let error{
            print(error.localizedDescription)
        }
    }
    
    func StopMusic(){
        musicPlayer?.stop()
    }
    
    //Play the sound that is retrived from resources
    func playSound() {
        guard let url = Bundle.main.url(forResource: "confirmSound", withExtension: ".wav") else {return}
        
        do{
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            soundPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            
            guard let player = soundPlayer else { return }
            
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
    
    //A popup that shows up when the user takes a screenshot
    open func imageAlert(image:UIImage, viewController:UIViewController){
        let alert = UIAlertController(title: "Screenshot saved", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alert.addImage(image: image)
        
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
    
    //Spawn the sprite view in the view, settings up constraints
    func setUpParticles(View: UIView, Leaves: Bool){
        
        skView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = skView.topAnchor.constraint(equalTo: View.topAnchor, constant: 0)
        let leading = skView.leadingAnchor.constraint(equalTo: View.leadingAnchor, constant: 0)
        let trailing = skView.trailingAnchor.constraint(equalTo: View.trailingAnchor, constant: 0)
        let bottom = skView.bottomAnchor.constraint(equalTo: View.bottomAnchor, constant: 0)
        
        //This is needed so you can see the background image that is set up afterwards
        skView.allowsTransparency = true
        View.addSubview(skView)
        View.sendSubviewToBack(skView)
        NSLayoutConstraint.activate([top, leading, trailing, bottom])
        
        
        if(Leaves){
            initLeaves()
        }
        else{
            initFireFlies()
        }
    }
    
    //Spawn the fireflies particle into the sprite view
    private func initFireFlies(){
        let particleScene = FireFlyScene(size: CGSize(width: 1080, height: 1920))
        particleScene.scaleMode = .aspectFill
        particleScene.backgroundColor = .clear
        
        skView.presentScene(particleScene)
    }
    
    //Spawn the leaves particle into the sprite view
    private func initLeaves(){
        let particleScene = LeavesScenes(size: CGSize(width: 1080, height: 1920))
        particleScene.scaleMode = .aspectFill
        particleScene.backgroundColor = .clear
        
        skView.presentScene(particleScene)
    }
}
