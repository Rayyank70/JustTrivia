//
//  QuestionData.swift
//  JustTrivia
//
//  Created by Rayyan Kahloon on 2021-12-27.
//

import UIKit

struct QuestionData: Decodable {
    let response_code: Int
    let results: [Result]
}

struct Result: Decodable {
    let category: String
    let type: String
    let difficulty: String
    let question: String
    let correct_answer: String
    var incorrect_answers: [String]
}
