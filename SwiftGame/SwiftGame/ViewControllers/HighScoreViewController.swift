//
//  MainMenu.swift
//  SwiftGame
//
//  Created by Uzair on 04/05/2019.
//  Copyright © 2019 Uzair. All rights reserved.
//
import UIKit

import Foundation
class HighScoreViewController : UIViewController {
    
    var scoreLabel = UILabel(frame: CGRect(x: 5, y: 330, width: 320, height: 20)) //labels manually declared to make it easier to edit them
    var normalName = UILabel(frame: CGRect(x: 5, y: 360, width: 320, height: 20))
    var normalLabel = UILabel(frame: CGRect(x: 5, y: 380, width: 320, height: 20))
    var hardName = UILabel(frame: CGRect(x: 5, y: 400, width: 320, height: 20))
    var hardLabel = UILabel(frame: CGRect(x: 5, y: 420, width: 320, height: 20))
    let highScore = UserDefaults.standard.integer(forKey: "Normal") //normal mode integer key
    let hardScore = UserDefaults.standard.integer(forKey: "Hard") //hard mode integer key
    var nName = String() //normal mode name
    var hName = String() //hard mode name
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        setName() //done here so the text box appears when a game ends as it didn't work in viewDidLoad()
        saveScore() //saves the score as soon as it appears
    }
    
    override func viewDidLoad() {
        readFile() //read the name file for the high score

        scoreLabel.textColor = UIColor.green //values set for every label
        scoreLabel.textAlignment = .center
        
        normalName.textColor = UIColor.yellow
        normalName.textAlignment = .center
        
        normalLabel.textColor = UIColor.yellow
        normalLabel.textAlignment = .center
        
        hardName.textColor = UIColor.red
        hardName.textAlignment = .center

        hardLabel.textColor = UIColor.red
        hardLabel.textAlignment = .center
        
        scoreLabel.text = "Your Score: \(GameViewController.score)" //concatenates score with text
        normalName.text = "Name: \(nName)" //concatenates name with text
        normalLabel.text = "Highest Score (Normal): \(highScore)"
        //hardName.text = "Name: \(hName)"
        hardLabel.text = "Highest Score (Hard Mode): \(hardScore)"
        
        self.view.addSubview(scoreLabel) //adds each label as a subview
        self.view.addSubview(normalName)
        self.view.addSubview(normalLabel)
        self.view.addSubview(hardName)
        self.view.addSubview(hardLabel)
    }
    
    override var shouldAutorotate: Bool {
        return false //want it to stay portrait
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait //portrait only
        } else {
            return .portrait
        }
    }
    
    func saveScore() {
        if !OptionViewController.hardMode && highScore < GameViewController.score { //if it's not in hard mode and the score is higher than the stored score
            UserDefaults.standard.set(GameViewController.score, forKey: "Normal")
            normalLabel.text = "Highest Score (Normal): \(highScore)"
            GameViewController.score = 0
        } else if OptionViewController.hardMode && hardScore < GameViewController.score { //if it is in hard mode
            UserDefaults.standard.set(GameViewController.score, forKey: "Hard")
            hardLabel.text = "Highest Score (Hard Mode): \(hardScore)"
            GameViewController.score = 0
        }
    }
    
    @IBAction func resetScore(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure?", message: "Clicking OK will erase the high score.", preferredStyle: .alert) //warning for resetting score
        let yes = UIAlertAction(title: "Yes", style: .default, handler: { (ACTION) -> Void in //action for clicking yes
            UserDefaults.standard.removeObject(forKey: "Normal")
            UserDefaults.standard.removeObject(forKey: "Hard")
            self.writeFile(Name: "")
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (ACTION) -> Void in
            print("Cancelled")
        }
        alert.addAction(yes) //adds each button action
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil) //presents the alert
    }
    
    func setName() {
        if highScore < GameViewController.score || hardScore < GameViewController.score {
            let alert = UIAlertController(title: "What is your name?", message: "Enter your name here: ", preferredStyle: .alert)
            
            //the confirm action taking the inputs
            let confirm = UIAlertAction(title: "Enter", style: .default) { (_) in
                if !OptionViewController.hardMode {
                    let name = alert.textFields?[0].text //gets text field from the alert box
                    self.normalName.text = "Name: " + name!
                    self.writeFile(Name: name!) //writes the name to a text file
                } else {
                    let name = alert.textFields?[0].text
                    self.hardName.text = "Name: " + name!
                    self.writeFile(Name: name!) //writes the name to a text file
                }
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in } //the cancel action
            
            alert.addTextField { (textField) in
                textField.placeholder = "Enter Name" //adding text fields to the alert box
            }
            
            alert.addAction(confirm) //adding the action to dialog box
            alert.addAction(cancel)
            
            self.present(alert, animated: true, completion: nil) //finally presents the alert box
        } else {
            print("High score didn't get beat")
        }
    }
    
    func writeFile(Name: String) {
        var fileName = String()
        if OptionViewController.hardMode { //checks game mode and writes to appropriate file
            fileName = "hardNames"
        } else {
            fileName = "normalNames"
        }
        
        let docDirUrl = try! FileManager.default.url(
            for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true
        )
        
        let fileUrl = docDirUrl.appendingPathComponent(fileName).appendingPathExtension("txt") //txt file
        
        print("file Path: \(fileUrl.path)") //path for file
        
        let outStr = Name
        
        do {
            try outStr.write(to: fileUrl, atomically: true, encoding: String.Encoding.utf8) //writes string to file
        } catch let error as NSError {
            print("failed to write to URL")
            print(error)
        }
    }
    
    func readFile() {
        //let fileName1 = "hardNames"
        var fileName2 = String()

        if OptionViewController.hardMode { //checks game mode
            fileName2 = "hardNames"
        } else {
            fileName2 = "normalNames"
        }
        
        let docDirUrl = try! FileManager.default.url(
            for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true
        )
        
        //let fileUrl1 = docDirUrl.appendingPathComponent(fileName1).appendingPathExtension("txt")
        let fileUrl2 = docDirUrl.appendingPathComponent(fileName2).appendingPathExtension("txt")
        
        do {
            //hName = try String(contentsOf: fileUrl1)
            nName = try String(contentsOf: fileUrl2)
        } catch let error as NSError {
            print("failed to read file")
            print(error)
        }
    }
}
