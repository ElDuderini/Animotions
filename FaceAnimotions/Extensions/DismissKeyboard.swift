//
//  DismissKeyboard.swift
//  FaceAnimoji
//
//  Created by Justin Peters on 4/9/21.
//  Copyright © 2021 ashutosh.dingankar. All rights reserved.
//

import Foundation
import UIKit

//Code found on https://medium.com/@vvishwakarma/dismiss-hide-keyboard-when-touching-outside-of-uitextfield-swift-166d9d1efb68

extension UIViewController {
func dismissKeyboard() {
       let tap: UITapGestureRecognizer = UITapGestureRecognizer( target:     self, action:    #selector(UIViewController.dismissKeyboardTouchOutside))
       tap.cancelsTouchesInView = false
       view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboardTouchOutside() {
       view.endEditing(true)
    }
}
