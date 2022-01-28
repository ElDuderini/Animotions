//
//  NSAttributedStringExtension.swift
//  FaceAnimoji
//
//  Created by Aaron Easter on 11/5/21.
//  Copyright © 2021 ashutosh.dingankar. All rights reserved.
//

import Foundation

extension NSAttributedString {
    
    static func makeHyperLink(for path: String, in string: String, as substring: String) -> NSAttributedString {
        
        let nsString = NSString(string: string)
        let substringRange = nsString.range(of: substring)
        
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(.link, value: path, range: substringRange)
        
        return attributedString
    }
    
}
