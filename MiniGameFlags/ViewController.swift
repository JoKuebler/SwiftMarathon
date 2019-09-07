//
//  ViewController.swift
//  MiniGameFlags
//
//  Created by Jonas Kübler on 08.07.19.
//  Copyright © 2019 Jonas.K. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var buttonOne: UIButton!
    @IBOutlet var buttonTwo: UIButton!
    @IBOutlet var buttonThree: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var questionsAsked = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        buttonOne.layer.borderWidth = 1
        buttonTwo.layer.borderWidth = 1
        buttonThree.layer.borderWidth = 1
        askQuestion()
        
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        
        // Shuffle array of countries
        countries.shuffle()
        
        correctAnswer = Int.random(in: 0...2)
        
        // Set images to buttons
        buttonOne.setImage(UIImage(named: countries[0]), for: .normal)
        buttonTwo.setImage(UIImage(named: countries[1]), for: .normal)
        buttonThree.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = "\(countries[correctAnswer].uppercased()), Score: \(score)"
    }
    
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var alertTitle: String
        var alertMessage: String
        var actionTitle: String
        questionsAsked += 1
        
        // If correct button is clicked
        if sender.tag == correctAnswer {
            alertTitle = "Correct"
            alertMessage = "Well done!"
            score += 1
        } else {
            alertTitle = "Wrong"
            alertMessage = "You chose \(countries[sender.tag].capitalized)"
            score -= 1
        }
        
        // After 10 questions restart
        if questionsAsked == 10 {
            score = 0
            questionsAsked = 0
            actionTitle = "Play again"
        } else {
            actionTitle = "Continue"
        }
        
        // An object that displays an alert message to the user.
        let acOne = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        // An action that can be taken when the user taps a button in an alert.
        acOne.addAction(UIAlertAction(title: actionTitle, style: .default, handler: askQuestion))
        // Present alert
        self.present(acOne, animated: true)

    }
    

}

