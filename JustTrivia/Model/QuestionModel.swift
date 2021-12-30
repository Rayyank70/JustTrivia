//
//  QuestionModel.swift
//  JustTrivia
//
//  Created by Rayyan Kahloon on 2021-12-27.
//

import UIKit

struct QuestionModel {
    var questions: [Question]
    var currentQuestion = 0
    
    func getLength() -> Int {
        return questions.count
    }
    
    mutating func checkAnswer(_ sender: UIButton) {
        let answer = sender.currentTitle
        let solution = questions[currentQuestion].correctAnswer
        
        if answer == solution {
            sender.backgroundColor = UIColor.green
        }
        else {
            sender.backgroundColor = UIColor.red
        }
    }
    
    mutating func increment() {
        self.currentQuestion += 1
        if currentQuestion >= questions.count {
            self.currentQuestion = 0
        }
    }
}

struct Question {
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]
}
