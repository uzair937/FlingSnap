//
//  TabController.swift
//  SwiftGame
//
//  Created by Uzair on 12/05/2019.
//  Copyright © 2019 Uzair. All rights reserved.
//

import Foundation
import UIKit

class TabController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad() //initialise the tab view
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:))) //swiping left
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:))) //swiping right
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(leftSwipe) //activate when a swipe is done
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if sender.direction == .left {
            self.selectedIndex += 1 //go left in tab view
        }
        if sender.direction == .right {
            self.selectedIndex -= 1 //go right in tab view
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
