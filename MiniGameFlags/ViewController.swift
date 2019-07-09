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
        
        title = countries[correctAnswer].uppercased()
    }
    
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var alertTitle: String
        
        // If correct button is clicked
        if sender.tag == correctAnswer {
            alertTitle = "Correct"
            score += 1
        } else {
            alertTitle = "Wrong"
            score -= 1
        }
        
        // An object that displays an alert message to the user.
        let ac = UIAlertController(title: alertTitle, message: "Your score is \(score)", preferredStyle: .alert)
        
        // An action that can be taken when the user taps a button in an alert.
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        
        // Present alert
        self.present(ac, animated: true)
    }
    

}

