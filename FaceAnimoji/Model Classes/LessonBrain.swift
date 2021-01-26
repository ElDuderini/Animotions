//
//  LessonBrain.swift
//  FaceAnimoji
//
//  Created by Justin Peters on 1/25/21.
//  Copyright © 2021 ashutosh.dingankar. All rights reserved.
//

import Foundation

struct LessonBrain {
    
    var questionNumber = 0
    var score = 0
    
    let defaults = UserDefaults.standard
    
    var quiz = [
        Question(a: "Happy", q: "How do you feel when friends play with you?"),
        Question(a: "Sad", q: "How do you feel when you are lost?"),
        Question(a: "Surprize", q: "How do you feel when someone suddenly jumps in front of you?"),
        Question(a: "Joy", q: "How do you feel when you get a gift you really wanted for your birthday?"),
        Question(a: "Disgust", q: "How do you feel when you smell something bad?"),
        Question(a: "Fear", q: "How do you feel when you go to a scary place?"),
        Question(a: "Anger", q: "How do you feel when you get a toy taken away from you?"),
        Question(a: "Neutral", q: "How do you feel while you are waiting?")
    ]
    
    mutating func ShuffleQuestions() {
        quiz.shuffle()
    }
    
    func getQuestionText() -> String {
        return quiz[questionNumber].text
    }
    
    func getProgress() -> Float {
        return Float(questionNumber) / Float(quiz.count)
    }
    
    //mutating func getScore() -> Int {
      //  return score
    //}
    
     mutating func nextQuestion() {
        
        if questionNumber + 1 < quiz.count {
            questionNumber += 1
        } else {
            ShuffleQuestions()
            questionNumber = 0
        }
    }
    
    mutating func checkAnswer(userAnswer: String) -> Bool {
        if userAnswer == quiz[questionNumber].answer {
            score += 10
            defaults.setValue(defaults.integer(forKey: "points") + 10, forKey: "points")
            return true
        } else {
            return false
        }
    }
}
