//
//  ViewController.swift
//  FaceAnimoji
//
//  Created by ashutosh.dingankar on 9/30/19.
//  Copyright © 2019 ashutosh.dingankar. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet weak var emoteLable: UILabel!
    var contentNode: SCNNode? = nil
    //var contentNode: SCNNode? = nil
    
    var morphs: [SCNGeometry] = []
    let morpher = SCNMorpher()
    var analysis = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set ViewController as ARSCNView's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/facial-setup-final.scn")!

        // Access scene's rootNode
        contentNode = scene.rootNode

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // "Reset" to run the AR session for the first time.
        resetTracking()
    }
    
    func resetTracking() {
        guard ARFaceTrackingConfiguration.isSupported else { return }
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard anchor is ARFaceAnchor else { return nil }
        return contentNode
    }
    
    func expression(anchor: ARFaceAnchor){
        let smileLeft = anchor.blendShapes[.mouthSmileLeft]
        let smileRight = anchor.blendShapes[.mouthSmileRight]
        let cheekPuff = anchor.blendShapes[.cheekPuff]
        let tongue = anchor.blendShapes[.tongueOut]
        
        if((smileLeft?.decimalValue ?? 0.0) + (smileRight?.decimalValue ?? 0.0)) > 0.9{
            self.analysis = "You are smiling"
        }
        
        if cheekPuff?.decimalValue ?? 0.0 > 0.1{
            self.analysis = "Your cheeks are puffed"
        }
        
        if tongue?.decimalValue ?? 0.0 > 0.1 {
            self.analysis = "You are sticking your tongue out!"
        }
        
        
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        
        
        guard let faceAnchor = anchor as? ARFaceAnchor
            else { return }
        
        expression(anchor: faceAnchor)
        
        DispatchQueue.main.async {
            self.emoteLable.text = self.analysis
            let blendShapes = faceAnchor.blendShapes
            
            // This will only work correctly if the shape keys are given the exact same name as the blendshape names
            for (key, value) in blendShapes {
                if let fValue = value as? Float{                    self.contentNode?.childNodes[0].morpher?.setWeight(CGFloat(fValue), forTargetNamed: key.rawValue)
                }
            }
        }
        
    }
}
