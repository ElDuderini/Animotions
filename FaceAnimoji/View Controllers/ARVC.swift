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

class ARVC: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet weak var emoteLable: UILabel!
    var contentNode: SCNNode? = nil
    
    var player : AVAudioPlayer?
    
    var morphs: [SCNGeometry] = []
    let morpher = SCNMorpher()
    var analysis = ""
    var selectedScene = ""
    var fullSceneName = ""
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var baseFunc:BaseFunctions? = nil
    var lessonQuestions = LessonBrain()
    var mainMenu = MainMenuVC()
    
    var totalQuestions = 0
    var beginTime = clock()
    var beginTimePerQuestion = clock()
    
    var timePerQuestion = [Double]()
    
    var student:StudentData? = nil
    
    var canCheckAwnser = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(baseFunc!.defaults.bool(forKey: "musicOn")){
            baseFunc!.StopMusic()
        }
        
        //Log the starting time when the user opens this screen, for both the session and per question
        beginTime = clock()
        beginTimePerQuestion = clock()
        //Clear out data from the last session
        timePerQuestion.removeAll()
        
        //Randomize the questions the user awnsers
        lessonQuestions.ShuffleQuestions()
        
        //Populate the questionText label
        self.emoteLable.text = lessonQuestions.getQuestionText()
        
        // Set ViewController as ARSCNView's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        //sceneView.showsStatistics = true
        
        //Get the mask the user is using, it is used to load scenes
        selectedScene = student!.lastUsedMask!
        
        //Establish which scene will be used
        fullSceneName = "art.scnassets/" + selectedScene + ".scn"
        
        // Create a new scene
        let scene = SCNScene(named: fullSceneName)!
        
        // Access scene's rootNode
        contentNode = scene.rootNode
        
        //Set up the array of SCNodes
        var childNodes: [SCNNode]?
        
        //Populate sceneNodes
        childNodes = self.contentNode?.childNodes
        
        //Unify normals of each node to make the mesh smooth
        for child in childNodes!{
            child.morpher?.unifiesNormals = true
        }
        
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
    
    //Reset the face tracking on the user
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
    
    //This method is used to check to see what the current expression the user is making for each frame
    func expression(anchor: ARFaceAnchor){
        let smileLeft = anchor.blendShapes[.mouthSmileLeft]
        let smileRight = anchor.blendShapes[.mouthSmileRight]
        let frownLeft = anchor.blendShapes[.mouthFrownLeft]
        let frownRight = anchor.blendShapes[.mouthSmileRight]
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
        else if ((frownLeft?.decimalValue ?? 0.0) + (frownRight?.decimalValue ?? 0.0)) > 0.1 && mouthOpen?.decimalValue ?? 0.0 < 0.2 && ((browDownLeft?.decimalValue ?? 0.0) + (browDownRight?.decimalValue ?? 0.0)) > 0.1 {
            self.analysis = "Sad"
        }
        else if ((noseSneerLeft?.decimalValue ?? 0.0) + (noseSneerRight?.decimalValue ?? 0.0)) > 0.6{
            self.analysis = "Disgust"
        }
        else if ((browDownLeft?.decimalValue ?? 0.0) + (browDownRight?.decimalValue ?? 0.0)) > 0.4{
            self.analysis = "Anger"
        }
        else if mouthPoggers?.decimalValue ?? 0.0 > 0.8 && browInnerUp?.decimalValue ?? 0.0 > 0.5{
            self.analysis = "Poggers"
        }
        else if ((eyeWideLeft?.decimalValue ?? 0.0) + (eyeWideRight?.decimalValue ?? 0.0)) > 0.8 && browInnerUp?.decimalValue ?? 0.0 > 0.5 &&  mouthOpen?.decimalValue ?? 0.0 < 0.2{
            self.analysis = "Surprise"
        }
        else if ((eyeWideLeft?.decimalValue ?? 0.0) + (eyeWideRight?.decimalValue ?? 0.0)) > 0.8 && browInnerUp?.decimalValue ?? 0.0 > 0.5 && mouthOpen?.decimalValue ?? 0.0 > 0.5{
            self.analysis = "Fear"
        }
        else if((frownLeft?.decimalValue ?? 0.0) + (frownRight?.decimalValue ?? 0.0)) > 0.1 && mouthOpen?.decimalValue ?? 0.0 < 0.2 && browInnerUp?.decimalValue ?? 0.0 > 0.5 {
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
    
    //This method is called each frame while the scene is being rendered
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        guard let faceAnchor = anchor as? ARFaceAnchor
        else { return }
        
        //Get the players current expression
        expression(anchor: faceAnchor)
        
        //If the user is making the face that the prompt asks for, then add to the array for the average time of responce, add points, go to the next question, and provide audio/haptic feedback
        if(lessonQuestions.checkAnswer(userAnswer: analysis) && canCheckAwnser){
            totalQuestions += 1
            let timeForResponse = Double(clock() - beginTimePerQuestion) / Double(CLOCKS_PER_SEC)
            timePerQuestion.append(timeForResponse)
            beginTimePerQuestion = clock()
            lessonQuestions.nextQuestion()
            baseFunc!.Feedback()
            let addedPoints = student!.points + 10
            student!.setValue(addedPoints, forKey: "points")
            
            OperationQueue.main.addOperation{
                self.emoteLable.text = self.lessonQuestions.getQuestionText()
            }
            
            //This is put into the code to prevent the app from checking for an expression right after the prior one was made. It is a one second delay and then the expressions can be checked
            canCheckAwnser = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                self.canCheckAwnser = true
            }
        }
        
        DispatchQueue.main.async {
            let blendShapes = faceAnchor.blendShapes
            
            // This will only work correctly if the shape keys are given the exact same name as the blendshape names
            //Changes the mesh based on the blendshapes the user is producing
            for (key, value) in blendShapes {
                if var fValue = value as? Float{
                    var childNodes: [SCNNode]?
                    
                    childNodes = self.contentNode?.childNodes
                    
                    //This updates each node in the scene when the face is split up into multiple objects
                    for child in childNodes!{
                        if(key.rawValue == "mouthFrown_L" || key.rawValue == "mouthFrown_R"){
                            fValue = fValue * 5;
                        }
                        child.morpher?.setWeight(CGFloat(fValue), forTargetNamed: key.rawValue)
                    }
                }
            }
        }
    }
    
    //When the user leaves the scene, then see if has answered a question. If the user hasn't, dont save the session
    @IBAction func backBtn(){
        if(totalQuestions != 0){
            saveSessionData()
        }
        self.dismiss(animated: true, completion: nil)
        baseFunc!.Feedback()
        
        if(baseFunc!.defaults.bool(forKey: "musicOn")){
            baseFunc!.StartMusic()
        }
    }
    
    //If the user pressed the screenshot button, call a screenshot method in another script
    @IBAction func cameraPress(sender: UIButton){
        baseFunc!.Feedback()
        let image = baseFunc!.screenShot(sceneView: sceneView)!
        baseFunc!.imageAlert(image: image, viewController: self)
    }
    
    //Save the data you produced in this session
    func saveSessionData(){
        let newEntry = LessonData(context: self.context)
        
        newEntry.setValue(totalQuestions, forKeyPath: "questionsAnswered")
        newEntry.setValue(Date(), forKey: "sessionDate")
        newEntry.setValue(student!, forKey: "student")
        
        let timeInController = Double(clock() - beginTime) / Double(CLOCKS_PER_SEC)
        newEntry.setValue(timeInController, forKey: "timeSpent")
        
        
        let totalTime = timePerQuestion.reduce(0, +)
        let avgTimeSpentPerQuestion = totalTime / Double(timePerQuestion.count)
        newEntry.setValue(avgTimeSpentPerQuestion, forKey: "avgTimeForResponse")
        
        do {
            try self.context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
