//
//  PrivacyVC.swift
//  FaceAnimoji
//
//  Created by Brandon Benoit on 6/17/21.
//  Copyright © 2021 ashutosh.dingankar. All rights reserved.
//

import Foundation
import UIKit

class PrivacyVC: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTextView()
    }
    
    func updateTextView(){
        let path = "https://www.gimm.dev/privacy-policy-animotions"
        let text = textView.text ?? ""
        let attributedString = NSAttributedString.makeHyperLink(for: path, in: text, as: "HERE")
            textView.attributedText = attributedString
        textView.attributedText = attributedString
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
