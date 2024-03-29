//
//  LessonBrain.swift
//  FaceAnimoji
//
//  Created by Justin Peters on 1/25/21.
//  Copyright © 2021 ashutosh.dingankar. All rights reserved.
//

import Foundation

struct LessonBrain {
    
    //This struct is used to set up all the questions the students can answer
    
    var questionNumber = 0
    var score = 0
    
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
        
        Question(a: "Surprise", q: "How do you feel when someone suddenly jumps in front of you?"),
        Question(a: "Surprise", q: "How do you feel when you get a gift you weren't expecting?"),
        Question(a: "Surprise", q: "How do you feel when you get a good grade on an assignment you thought you failed?"),
        Question(a: "Surprise", q: "How do you feel when a friend comes over that you weren't expecting?"),
        
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
        Question(a: "Neutral", q: "How do you feel when you can't find something to do?"),
        Question(a: "Neutral", q: "How do you feel when there is nothing to watch on TV?"),
        
        Question(a: "Anxious", q: "How do you feel when you are at the dentist?"),
        Question(a: "Anxious", q: "How do you feel when you are on a airplane?"),
        Question(a: "Anxious", q: "How do you feel when you are at the doctor?"),
        Question(a: "Anxious", q: "How do you feel when you try something different?")
    ]
    
    //Shuffle the questions in the array of questions
    mutating func ShuffleQuestions() {
        quiz.shuffle()
    }
    
    //Get the text of the current question in the array
    func getQuestionText() -> String {
        return quiz[questionNumber].text
    }
    
    func getProgress() -> Float {
        return Float(questionNumber) / Float(quiz.count)
    }
    
    //Method used to progress to the next question. If all of the questions have been gone through, shuffel the array and reset the number used to progress through the array
    mutating func nextQuestion() {
        
        if questionNumber + 1 < quiz.count {
            questionNumber += 1
        } else {
            ShuffleQuestions()
            questionNumber = 0
        }
    }
    
    //Use this method to check to see if the user is responding to the question correctly. If so, then add to the users score
    mutating func checkAnswer(userAnswer: String) -> Bool {
        if userAnswer == quiz[questionNumber].answer {
            return true
        } else {
            return false
        }
    }
}
