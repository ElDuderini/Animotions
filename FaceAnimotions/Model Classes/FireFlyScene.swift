//
//  ParticleScene.swift
//  FaceAnimoji
//
//  Created by Justin Peters on 4/20/21.
//  Copyright © 2021 ashutosh.dingankar. All rights reserved.
//

import Foundation
import SpriteKit

class FireFlyScene:SKScene {
    
    //Did move starts when the particle system is spawned in
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        setupParticleEmitter()
    }
    
    //Spawn the particle in the sprite view
    private func setupParticleEmitter(){
        let particleEmitter = SKEmitterNode(fileNamed: "Fireflies")
        particleEmitter?.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(particleEmitter!)
    }
}
