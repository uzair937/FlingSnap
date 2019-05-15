//
//  MainMenu.swift
//  SwiftGame
//
//  Created by Uzair on 04/05/2019.
//  Copyright © 2019 Uzair. All rights reserved.
//
import UIKit
import Foundation

class OptionViewController : UIViewController {
    public static var hardMode = false //static as they need to remain value throughout application runtime
    public static var sound = true //also need to be accessible from other classes hence public
    public static var music = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func toggleHardMode(_ sender: Any) { //toggles the game mode
        if OptionViewController.hardMode {
            OptionViewController.hardMode = false
            makeToast(controller: self, message: "Hard Mode disabled", dur: 2.0)
        } else {
            OptionViewController.hardMode = true
            makeToast(controller: self, message: "Hard Mode enabled", dur: 2.0)
        }
    }
    
    @IBAction func toggleMusic(_ sender: Any) { //toggles the music playback
        if OptionViewController.music {
            OptionViewController.music = false
            makeToast(controller: self, message: "Music disabled", dur: 2.0)
        } else {
            OptionViewController.music = true
            makeToast(controller: self, message: "Music enabled", dur: 2.0)
        }
    }

    @IBAction func toggleSound(_ sender: Any) { //toggles the sound playback
        if OptionViewController.sound {
            OptionViewController.sound = false
            makeToast(controller: self, message: "Sound disabled", dur: 2.0)
        } else {
            OptionViewController.sound = true
            makeToast(controller: self, message: "Sound enabled", dur: 2.0)
        }
    }
    
    public func makeToast(controller: UIViewController, message: String, dur: Double) { //my own toast method to replicate Java/Android
        let toast = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        toast.view.alpha = 0.6
        toast.view.layer.cornerRadius = 15
        controller.present(toast, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + dur) { //displays it for dur amount of time
            toast.dismiss(animated: true)
        }
    }
    
    override var shouldAutorotate: Bool {
        return false //don't rotate
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait //remain portrait
        } else {
            return .portrait
        }
    }
}
