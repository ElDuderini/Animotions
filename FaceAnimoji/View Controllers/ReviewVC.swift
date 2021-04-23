//
//  ReviewVC.swift
//  FaceAnimoji
//
//  Created by Justin Peters on 3/8/21.
//  Copyright © 2021 ashutosh.dingankar. All rights reserved.
//

import UIKit

class ReviewVC: UIViewController {
    
    var BaseFunc = BaseFunctions()

    //Just spawn in particles and background
    override func viewDidLoad() {
        super.viewDidLoad()
        BaseFunc.setUpParticles(View: self.view, Leaves: false)
        BaseFunc.setUpBackground(view: self.view, imageName: "BackgroundPink")
    }
    
    @IBAction func backBtn(_ sender:UIButton){
        BaseFunc.Feedback()
        self.dismiss(animated: true, completion: nil)
    }
}
