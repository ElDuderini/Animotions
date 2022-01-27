//
//  LeavesScenes.swift
//  FaceAnimoji
//
//  Created by Justin Peters on 4/20/21.
//  Copyright © 2021 ashutosh.dingankar. All rights reserved.
//

import Foundation
import SpriteKit

class LeavesScenes:SKScene {
    
    //Array of leaf image names used for the array
    let leaves = ["Leaf1", "Leaf2", "Leaf3"]
    
    //Did move starts when the particle system is spawned in
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        setupParticleEmitter()
    }
    
    //Spawn the particle in the sprite view
    //Spawn 3 different particles for 3 different leaves
    private func setupParticleEmitter(){
        
        for leaf in leaves{
            let particleEmitter = SKEmitterNode(fileNamed: "Leaves")
            particleEmitter?.position = CGPoint(x: size.width / 2, y: size.height - 50)
            particleEmitter?.particleTexture = SKTexture(imageNamed: leaf)
            addChild(particleEmitter!)
        }
    }
}
