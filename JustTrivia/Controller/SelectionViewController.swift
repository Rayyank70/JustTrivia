//
//  ViewController.swift
//  JustTrivia
//
//  Created by Rayyan Kahloon on 2021-12-24.
//

import UIKit

class SelectionViewController: UIViewController {

    @IBOutlet weak var difficultyPickerView: UIPickerView!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var playersTextField: UITextField!
    @IBOutlet weak var roundsTextField: UITextField!
    
    var userInformation: [String : Any?] = ["numberOfPlayers": nil, "numberOfRounds": nil, "category": "General Knowledge", "difficulty": "Easy"]
    let categoryInformation = ["General Knowledge", "History", "Science & Nature", "Sports", "Geography", "Politics", "Art", "Anime"]
    let difficultyInformation = ["Easy", "Medium", "Hard"]
    
    var questionManager: QuestionManager! = QuestionManager()
    var questionModel: QuestionModel?
    
    let group = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        difficultyPickerView.delegate = self
        categoryPickerView.delegate = self
        playersTextField.delegate = self
        roundsTextField.delegate = self
        
        difficultyPickerView.dataSource = self
        categoryPickerView.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        playersTextField.resignFirstResponder()
        roundsTextField.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMainController" {
            let destinationVC = segue.destination as! MainViewController
            destinationVC.questionModel = self.questionModel
        }
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        if shouldPerformSegueWithIdentifier(identifier: "toMainController", sender: nil) {
            performSegue(withIdentifier: "toMainController", sender: self)
        }
    }
    
    func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        
        if identifier == "toMainController" {
            if userInformation.values.contains(where: {($0 == nil) || ($0 as! String == "")}) {
                
                let alert = UIAlertController(title: "Invalid Input", message: "Please enter a valid number for players and number of rounds", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)}))
                
                self.present(alert, animated: true, completion: nil)
                
                return false
            }
        }
        
        let numberOfPlayers: Int = Int.init(userInformation["numberOfPlayers"] as! String)!
        let numberOfRounds: Int = Int.init(userInformation["numberOfRounds"] as! String)!

        group.enter()
        
        questionManager.delegate = self
        questionManager.getQuestions(numberOfPlayers: numberOfPlayers, numberOfRounds: numberOfRounds, category: userInformation["category"] as! String, difficulty: userInformation["difficulty"] as! String)
        
        group.wait()
        
        return true
    }
}

//MARK: -UITextFieldDelegate

extension SelectionViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        playersTextField.endEditing(true)
        return true
    }
    
    // Decides what happens after keyboard returns
    func textFieldDidEndEditing(_ textField: UITextField) {
        userInformation[textField.accessibilityIdentifier!] = textField.text
    }
    
    // Decides if the keyboard should return
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    // What the textField should allow
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        if string.count == 0 {
              return true
            }
        
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
      
        switch textField {
            case playersTextField:
                return (prospectiveText.rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789")) != nil) &&
                    prospectiveText.count == 1
                
            case roundsTextField:
                return (prospectiveText.rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789")) != nil) &&
                    prospectiveText.count <= 2
            default:
                return true
        }
    }
}

//MARK: -UIPickerViewDelegate

extension SelectionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // Return number of columns per row
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // Return the number of rows in the pickerView
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.accessibilityIdentifier == "category") {
            return categoryInformation.count
        }
        return difficultyInformation.count
    }
    // Calls this to find the name of each element
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        if (pickerView.accessibilityIdentifier == "category") {
            return NSAttributedString(string: categoryInformation[row], attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
        }
        return NSAttributedString(string: difficultyInformation[row], attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        userInformation["category"] = categoryInformation[row]
    }
}

//MARK: -QuestionManagerDelegate

extension SelectionViewController: QuestionManagerDelegate {
    func questionRequestReturned(questionModel: QuestionModel) {
        self.questionModel = questionModel
        group.leave()
    }
}
