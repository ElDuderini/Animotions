//
//  Question.swift
//  FaceAnimoji
//
//  Created by Justin Peters on 1/25/21.
//  Copyright © 2021 ashutosh.dingankar. All rights reserved.
//

import Foundation

struct Question {
    let text: String
    let answer: String
    
    init(a: String, q: String) {
        text = q
        answer = a
    }
}
