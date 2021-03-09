//
//  StatementVC.swift
//  FaceAnimoji
//
//  Created by Justin Peters on 3/8/21.
//  Copyright © 2021 ashutosh.dingankar. All rights reserved.
//

import UIKit

class StatementVC: UIViewController {

    var BaseFunc = BaseFunctions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Development is on hold for this feature till we get
    }
    
    @IBAction func backBtn(_ sender:UIButton){
        BaseFunc.Feedback()
        self.dismiss(animated: true, completion: nil)
    }
}
