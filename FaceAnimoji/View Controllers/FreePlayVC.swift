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

class FreePlayVC: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    var contentNode: SCNNode? = nil
    
    var player : AVAudioPlayer?
    
    var morphs: [SCNGeometry] = []
    let morpher = SCNMorpher()
    var analysis = ""
    var selectedScene = "blue"
    var fullSceneName = ""
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var baseFunc = BaseFunctions()
    //var lessonQuestions = LessonBrain()
    var mainMenu = MainMenuVC()
    
    var correcntResponces : Double = 0
    
    var totalQuestions : Double = 0
    
    var beginTime = clock()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beginTime = clock()
        
        correcntResponces = 0
        totalQuestions = 0
        
        let defaults = UserDefaults.standard
        
        // Set ViewController as ARSCNView's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        if(!isKeyPresentInDefaults(key: "Face")){
            defaults.set("white", forKey: "Face")
        }
        
        selectedScene = defaults.string(forKey: "Face")!
        
        //Establish which scene will be used
        fullSceneName = "art.scnassets/" + selectedScene + ".scn"
        
        // Create a new scene
        let scene = SCNScene(named: fullSceneName)!
        
        // Access scene's rootNode
        contentNode = scene.rootNode
        
        
        var childNodes: [SCNNode]?
        
        childNodes = self.contentNode?.childNodes
        
        for child in childNodes!{
            child.morpher?.unifiesNormals = true
        }
    }
    
    func isKeyPresentInDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
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
        let frownLeft = anchor.blendShapes[.mouthFrownLeft]
        let frownRight = anchor.blendShapes[.mouthFrownRight]
        let browDownLeft = anchor.blendShapes[.browDownLeft]
        let browDownRight = anchor.blendShapes[.browDownRight]
        let browInnerUp = anchor.blendShapes[.browInnerUp]
        let eyeWideLeft = anchor.blendShapes[.eyeWideLeft]
        let eyeWideRight = anchor.blendShapes[.eyeWideRight]
        let noseSneerLeft = anchor.blendShapes[.noseSneerLeft]
        let noseSneerRight = anchor.blendShapes[.noseSneerRight]
        let mouthPoggers = anchor.blendShapes[.mouthFunnel]
        let mouthOpen = anchor.blendShapes[.jawOpen]
        
        if((smileLeft?.decimalValue ?? 0.0) + (smileRight?.decimalValue ?? 0.0)) > 0.9
            && mouthOpen?.decimalValue ?? 0.0 < 0.3{
            self.analysis = "Happy"
        }
        //        else if((smileLeft?.decimalValue ?? 0.0) + (smileRight?.decimalValue ?? 0.0)) > 0.9
        //                && mouthOpen?.decimalValue ?? 0.0 > 0.3{
        //            self.analysis = "Joy"
        //        }
        else if ((frownLeft?.decimalValue ?? 0.0) + (frownRight?.decimalValue ?? 0.0)) > 0.1 && mouthOpen?.decimalValue ?? 0.0 < 0.2 && ((browDownLeft?.decimalValue ?? 0.0) + (browDownRight?.decimalValue ?? 0.0)) > 0.6 {
            self.analysis = "Sad"
        }
        else if ((noseSneerLeft?.decimalValue ?? 0.0) + (noseSneerRight?.decimalValue ?? 0.0)) > 0.6{
            self.analysis = "Disgust"
        }
        else if ((browDownLeft?.decimalValue ?? 0.0) + (browDownRight?.decimalValue ?? 0.0)) > 0.6{
            self.analysis = "Anger"
        }
        else if mouthPoggers?.decimalValue ?? 0.0 > 0.8 && browInnerUp?.decimalValue ?? 0.0 > 0.5{
            self.analysis = "Poggers"
        }
        else if ((eyeWideLeft?.decimalValue ?? 0.0) + (eyeWideRight?.decimalValue ?? 0.0)) > 0.8 && browInnerUp?.decimalValue ?? 0.0 > 0.5 &&  mouthOpen?.decimalValue ?? 0.0 < 0.2{
            self.analysis = "Surprize"
        }
        else if ((eyeWideLeft?.decimalValue ?? 0.0) + (eyeWideRight?.decimalValue ?? 0.0)) > 0.8 && browInnerUp?.decimalValue ?? 0.0 > 0.5 && mouthOpen?.decimalValue ?? 0.0 > 0.5{
            self.analysis = "Fear"
        }
        else if((frownLeft?.decimalValue ?? 0.0) + (frownRight?.decimalValue ?? 0.0)) > 0.1 && mouthOpen?.decimalValue ?? 0.0 < 0.2 && ((browDownLeft?.decimalValue ?? 0.0) + (browDownRight?.decimalValue ?? 0.0)) < 0.2 {
            self.analysis = "Anxious"
        }
        else if((smileLeft?.decimalValue ?? 0.0) + (smileRight?.decimalValue ?? 0.0)) < 0.8
                && ((frownLeft?.decimalValue ?? 0.0) + (frownRight?.decimalValue ?? 0.0)) < 0.1 {
            self.analysis = "Neutral"
        }
        else{
            //If none of the emotions above are being made, then let the user know their expression is neutural
            self.analysis = " "
        }
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        guard let faceAnchor = anchor as? ARFaceAnchor
        else { return }
        
        expression(anchor: faceAnchor)
        
        DispatchQueue.main.async {
            let blendShapes = faceAnchor.blendShapes
            
            // This will only work correctly if the shape keys are given the exact same name as the blendshape names
            for (key, value) in blendShapes {
                if let fValue = value as? Float{
                    var childNodes: [SCNNode]?
                    
                    childNodes = self.contentNode?.childNodes
                    
                    for child in childNodes!{
                        // print(child.morpher?.weight(forTargetNamed: key.rawValue))
                        //  print(key.rawValue)
                        child.morpher?.setWeight(CGFloat(fValue), forTargetNamed: key.rawValue)
                    }
                }
            }
        }
    }
    
    @IBAction func backBtn(){
        if(totalQuestions != 0){
            saveSessionData()
        }
        self.dismiss(animated: true, completion: nil)
        baseFunc.Feedback()
    }
    
    @IBAction func awnserButton(sender: UIButton){
        totalQuestions += 1
        if analysis == sender.title(for: .normal){
            UserDefaults.standard.setValue(UserDefaults.standard.integer(forKey: "points") + 10, forKey: "points")
            correcntResponces += 1
            baseFunc.Feedback()
        }
    }
    
    func saveSessionData(){
        let newEntry = FreeplayData(context: self.context)
        
        newEntry.setValue(correcntResponces, forKeyPath: "questionsAnswered")
        newEntry.setValue(Date(), forKey: "sessionDate")
        
        let timeInController = Double(clock() - beginTime) / Double(CLOCKS_PER_SEC)
        newEntry.setValue(timeInController, forKey: "timeSpent")
        
        let percentRight = (correcntResponces/totalQuestions) * 100
        print(correcntResponces)
        print(totalQuestions)
        print(correcntResponces/totalQuestions)
        newEntry.setValue(percentRight, forKey: "sucessRate")
        
        do {
            try self.context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func cameraPress(sender: UIButton){
        baseFunc.Feedback()
        baseFunc.screenShot(sceneView: sceneView)
    }
}
