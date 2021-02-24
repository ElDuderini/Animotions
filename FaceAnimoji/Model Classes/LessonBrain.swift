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
    
   // let defaults = UserDefaults.standard
    
    var quiz = [
        Question(a: "Happy", q: "How do you feel when you play with your friends?"),
        Question(a: "Happy", q: "How do you feel when you eat something yummy?"),
        Question(a: "Happy", q: "How do you feel when you play with your favorite toys?"),
        Question(a: "Happy", q: "How do you feel when you hear your favorite song?"),
        Question(a: "Happy", q: "How do you feel when you get a compliment?"),
        
        Question(a: "Sad", q: "How do you feel when someone hurts your feelings?"),
        Question(a: "Sad", q: "How do you feel when you drop your favorite toy and it breaks?"),
        Question(a: "Sad", q: "How do you feel when your friend can not play with you?"),
        Question(a: "Sad", q: "How do you feel when you miss being with someone?"),
        Question(a: "Sad", q: "How do you feel when you have to leave a place you like?"),
        
        Question(a: "Surprize", q: "How do you feel when someone suddenly jumps in front of you?"),
        Question(a: "Surprize", q: "How do you feel when you get a gift you weren't expecting?"),
        Question(a: "Surprize", q: "How do you feel when you get a good grade on an assingment you thought you failed?"),
        Question(a: "Surprize", q: "How do you feel when a friend comes over that you weren't expecting?"),
        
        //scrap joy for now
        //Question(a: "Joy", q: "How do you feel when you get a gift you really wanted for your birthday?"),
        
        Question(a: "Disgust", q: "How do you feel when you smell something bad?"),
        Question(a: "Disgust", q: "How do you feel when something tastes bad?"),
        Question(a: "Disgust", q: "How do you feel when you hear a gross story?"),
        Question(a: "Disgust", q: "How do you feel when someone does something gross?"),
        Question(a: "Disgust", q: "How do you feel when you touch a gross bug?"),
        
        Question(a: "Fear", q: "How do you feel when you go to a scary place?"),
        Question(a: "Fear", q: "How do you feel when you encounter something you are afraid of?"),
        Question(a: "Fear", q: "How do you feel when you get lost in a new place and can't find your friends?"),
        Question(a: "Fear", q: "How do you feel when you see a big animal like a bear?"),
        
        Question(a: "Anger", q: "How do you feel when you get a toy taken away from you?"),
        Question(a: "Anger", q: "How do you feel when someone pushes you?"),
        Question(a: "Anger", q: "How do you feel when you see a friend being bullied?"),
        Question(a: "Anger", q: "How do you feel when someone says something mean to you?"),
        
        Question(a: "Neutral", q: "How do you feel while you are waiting?"),
        Question(a: "Neutral", q: "How do you feel when nothing is happening?"),
        Question(a: "Neutral", q: "How do you feel you can't find something to do?"),
        Question(a: "Neutral", q: "How do you feel when there is nothing to watch on TV?"),
        
        Question(a: "Anxious", q: "How do you feel when you are at the dentist?"),
        Question(a: "Anxious", q: "How do you feel when you are on a airplane?"),
        Question(a: "Anxious", q: "How do you feel when you are at the doctor?"),
        Question(a: "Anxious", q: "How do you feel when you try something different?"),
        
        //Add Anxious
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
    
     mutating func nextQuestion() {
        
        if questionNumber + 1 < quiz.count {
            questionNumber += 1
        } else {
            ShuffleQuestions()
            questionNumber = 0
        }
    }
    
    mutating func checkAnswer(userAnswer: String, studentData: StudentData) -> Bool {
        if userAnswer == quiz[questionNumber].answer {
            score += 10
            let addedPoints = studentData.points + 10
            studentData.setValue(addedPoints, forKey: "points")
            //defaults.setValue(defaults.integer(forKey: "points") + 10, forKey: "points")
            return true
        } else {
            return false
        }
    }
}
