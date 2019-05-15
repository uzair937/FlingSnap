//
//  MainMenu.swift
//  SwiftGame
//
//  Created by Uzair on 04/05/2019.
//  Copyright © 2019 Uzair. All rights reserved.
//
import UIKit
import Foundation

class MainViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad() //load the view controller
    }
    
    override var shouldAutorotate: Bool {
        return false //don't rotate
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .portrait //remain portrait
        }
    }
}
