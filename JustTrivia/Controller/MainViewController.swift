//
//  ViewController.swift
//  JustTrivia
//
//  Created by Rayyan Kahloon on 2021-12-24.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var questionTextArea: UILabel!
    @IBOutlet weak var optionA: UIButton!
    @IBOutlet weak var optionB: UIButton!
    @IBOutlet weak var optionC: UIButton!
    @IBOutlet weak var optionD: UIButton!

    var questionModel: QuestionModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }

    @objc func updateUI() {
        if questionModel.currentQuestion < questionModel.getLength() {
            questionTextArea.text = questionModel.questions[questionModel.currentQuestion].question
        }
        
        var options = [questionModel.questions[questionModel.currentQuestion].correctAnswer,
                       questionModel.questions[questionModel.currentQuestion].incorrectAnswers[0],
                       questionModel.questions[questionModel.currentQuestion].incorrectAnswers[1],
                       questionModel.questions[questionModel.currentQuestion].incorrectAnswers[2]
                      ]
        options.shuffle()
        
        optionA.setTitle(options[0], for: UIControl.State.normal)
        optionB.setTitle(options[1], for: UIControl.State.normal)
        optionC.setTitle(options[2], for: UIControl.State.normal)
        optionD.setTitle(options[3], for: UIControl.State.normal)
        
        optionA.backgroundColor = UIColor.clear
        optionB.backgroundColor = UIColor.clear
        optionC.backgroundColor = UIColor.clear
        optionD.backgroundColor = UIColor.clear
        
        progressBar.progress = Float(questionModel.currentQuestion) / Float(questionModel.getLength())
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        questionModel.checkAnswer(sender)
        questionModel.increment()
        
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateUI), userInfo: nil, repeats: false)
    }
}

