//
//  QuestionManager.swift
//  JustTrivia
//
//  Created by Rayyan Kahloon on 2021-12-27.
//

import UIKit

protocol QuestionManagerDelegate {
    func questionRequestReturned(questionModel: QuestionModel)
}

struct QuestionManager {
    
    var delegate: QuestionManagerDelegate?
    let jsonURL: String = "https://opentdb.com/api.php?type=multiple&encode=base64&"
    
    func getQuestions(numberOfPlayers: Int, numberOfRounds: Int, category: String, difficulty: String) {
        let category = getCategory(category: category)
        let urlString = "\(jsonURL)amount=\(numberOfRounds * numberOfPlayers)&category=\(category)&difficulty=\(difficulty.lowercased())"
        
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    return
                }
                if let safeData = data {
                    if let questionModel = parseJSON(questionData: safeData) {
                        delegate?.questionRequestReturned(questionModel: questionModel)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(questionData: Data) -> QuestionModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(QuestionData.self, from: questionData)
            var questions: [Question] = []
                        
            for result in decodedData.results {
               
                
                var data = Data(base64Encoded: result.question)
                let question = String(data: data!, encoding: .utf8)
                
                data = Data(base64Encoded: result.correct_answer)
                let correctAnswer = String(data: data!, encoding: .utf8)
                
                var incorrectAnswers = result.incorrect_answers
                for i in 0..<incorrectAnswers.count {
                    data = Data(base64Encoded: incorrectAnswers[i])
                    incorrectAnswers[i] = String(data: data!, encoding: .utf8)!
                }
                
                let Question = Question(question: question!, correctAnswer: correctAnswer!, incorrectAnswers: incorrectAnswers)
                
                questions.append(Question)
            }
            
            return QuestionModel(questions: questions)
        }
        catch {
            return nil
        }
    }
    
    func getCategory(category: String) -> Int {
        let categories = ["General Knowledge": 9, "History": 23, "Science & Nature": 17, "Sports": 21, "Geography": 22, "Politics": 24, "Art": 25, "Anime": 31]
        return categories[category]!
    }
}
