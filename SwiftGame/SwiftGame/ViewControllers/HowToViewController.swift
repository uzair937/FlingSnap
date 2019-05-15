//
//  MainMenu.swift
//  SwiftGame
//
//  Created by Uzair on 04/05/2019.
//  Copyright © 2019 Uzair. All rights reserved.
//
import UIKit
import Foundation

class HowToViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad() //load the view controller
    }
    
    override var shouldAutorotate: Bool { //don't rotate
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone { //remain portrait
            return .portrait
        } else {
            return .portrait
        }
    }
}
