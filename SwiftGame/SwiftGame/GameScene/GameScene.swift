//
//  GameScene.swift
//  SwiftGame
//
//  Created by Uzair on 02/05/2019.
//  Copyright © 2019 Uzair. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    var gameController : GameViewController!
    var ship : SKSpriteNode! //each node is being declared
    var al1 : SKSpriteNode!
    var al2 : SKSpriteNode!
    var fe1 : SKSpriteNode!
    var fe2 : SKSpriteNode!
    var cu1 : SKSpriteNode!
    var cu2 : SKSpriteNode!
    var o1 : SKSpriteNode!
    var o2 : SKSpriteNode!
    var he1 : SKSpriteNode!
    var he2 : SKSpriteNode!
    var store1 = [SKNode]()
    var store2 = [SKNode]()
    
    var timeLabel = SKLabelNode() //new labels that don't exist yet
    var scoreLabel = SKLabelNode()
    
    var release = false //the rocket isn't launched by default
    var startPosition : CGPoint! //where the rocket starts
    var originalPosition : CGPoint! //where the rocket respawns
    var timeLeft = 45 //time for normal game
    var trackDead = 0 //checks all elements and images are gone
    
    override func didMove(to view: SKView) {
        scene?.scaleMode = .aspectFit //fit screen
        physicsWorld.contactDelegate = self //physics world is set to this scene
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame) //the border is now a solid wall
        GameViewController.score = 0
        createShip() //creates the ship
        createElements() //creates the elements and images
        
        timeLabel.position = CGPoint(x: 400, y: -260) //position of timer
        timeLabel.fontColor = SKColor.yellow
        timeLabel.fontSize = 30
        timeLabel.zPosition = 4 //puts it on top of everything
        addChild(timeLabel)
        startTimer()
        
        scoreLabel.position = CGPoint(x: 400, y: 260) //position of score
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.fontColor = SKColor.yellow
        scoreLabel.fontSize = 40
        scoreLabel.text = "Score: 0"
        scoreLabel.zPosition = 4 //puts it on top of everything
        addChild(scoreLabel)
        
        if OptionViewController.music { //if music enables
            playMusic()
        }
        if OptionViewController.hardMode { //if in hard mode
            timeLeft = 30
        }
    }
    
    override func update(_ currentTime: TimeInterval) { //constantly checks as time goes on
        if action(forKey: "countdown") == nil { //check if there's still time left
            alertBox(_title: "Time up!", _message: "You ran out of time!")
        }
        if trackDead >= 10 { //check all elements and images are dead
            alertBox(_title: "Game Over", _message: "You destroyed everything!")
        }
    }
    
    func startTimer() {
        let wait = SKAction.wait(forDuration: 1) //1 sec interval
        let block = SKAction.run({ //run action block
            [unowned self] in
            
            if self.timeLeft > 0 { //check if there's time left
                self.timeLeft -= 1 //decrement
                self.timeLabel.text = "Time left: \(self.timeLeft)" //update label
            } else {
                self.removeAction(forKey: "countdown") //stop countdown
                self.alertBox(_title: "Time up!", _message: "You ran out of time. :(") //time is up
            }
        })
        let sequence = SKAction.sequence([wait,block]) //executes sequence every second
        run(SKAction.repeatForever(sequence), withKey: "countdown") //repeats until else block
    }
    
    func respawnShip() {
        addChild(ship) //adds ship back to SKView
        ship.position = originalPosition //sets its position
        ship.zRotation = 0 //make sure it isnt vertical
        release = false //not released yet
        createShip() //creates a new ship
    }
    
    func createShip() {
        ship = childNode(withName: "ship") as? SKSpriteNode //as? for conditional cast instead of as! for forced cast
        originalPosition = ship.position //remembers original position
        startPosition = ship.position //ship position keeps changing so two variables for it
        let emitter = SKEmitterNode(fileNamed: "Fire.sks")! //fire effect
        emitter.targetNode = self.scene
        emitter.emissionAngle = ship.position.x + 45 //makes it appear as if fire is coming out the rear
        emitter.position.x = -45 //sends the origin of the fire to the rear
        ship.addChild(emitter) //keeps it attached to the ship
        ship.physicsBody!.contactTestBitMask = ship.physicsBody!.collisionBitMask //collision detection
    }
    
    func createElements() { //sets all the nodes to the scene elements and images
        al1 = childNode(withName: "al1") as? SKSpriteNode
        fe1 = childNode(withName: "fe1") as? SKSpriteNode
        cu1 = childNode(withName: "cu1") as? SKSpriteNode
        he1 = childNode(withName: "he1") as? SKSpriteNode
        o1 = childNode(withName: "o1") as? SKSpriteNode
        al2 = childNode(withName: "al2") as? SKSpriteNode
        fe2 = childNode(withName: "fe2") as? SKSpriteNode
        cu2 = childNode(withName: "cu2") as? SKSpriteNode
        he2 = childNode(withName: "he2") as? SKSpriteNode
        o2 = childNode(withName: "o2") as? SKSpriteNode
    }
    
    func randomiseSprites() { //randomly moves the elements and images around
        al1.position = getRNG()
        fe1.position = getRNG()
        cu1.position = getRNG()
        he1.position = getRNG()
        o1.position = getRNG()
        al2.position = getRNG()
        fe2.position = getRNG()
        cu2.position = getRNG()
        he2.position = getRNG()
        o2.position = getRNG()
    }
    
     func getRNG() -> CGPoint { //randomly generates a number and returns it
        let height = CGFloat(500.0)
        let width = CGFloat(220.0)
        let RNG = CGPoint(x:CGFloat(arc4random()).truncatingRemainder(dividingBy: height), y: CGFloat(arc4random()).truncatingRemainder(dividingBy: width))
        print(RNG)
        return RNG
    }
    
    func clearLists() { //clears the arrays ready for next pair of values
        store1.removeAll()
        store2.removeAll()
    }
    
    func collisionDetection(ship: SKNode, element: SKNode) { //run every time the ship collides with something
        if element.name == "ground" && timeLeft > 1 { //die if it's the ground that gets hit
            destroy(node: ship)
            self.setScore(result: false)
            alertBox(_title: "Game Over.", _message: "You crashed!")
        }
        
        if store1.isEmpty || store2.isEmpty { //if either is empty
            if store1.isEmpty { //store first element in this array
                if element.name == "al1" || element.name == "fe1" || element.name == "cu1" || element.name == "he1" || element.name == "o1" {
                    destroy(node: element) //destroys ship and element
                    destroy(node: ship)
                    store1.append(element) //adds to array
                    trackDead += 1
                    if checkAnswer() {
                        gameController.makeToast(controller: gameController, message: "Correct!", dur: 1.0)
                    }
                    self.run(SKAction.wait(forDuration: 1.0)) {
                        self.respawnShip() //respawns after 1 sec
                    }
                }
            }
            if store2.isEmpty { //store second element in this array
                if element.name == "al2" || element.name == "fe2" || element.name == "cu2" || element.name == "he2" || element.name == "o2" {
                    destroy(node: element) //destroys ship and element
                    destroy(node: ship)
                    store2.append(element) //adds to array
                    trackDead += 1
                    if checkAnswer() {
                        gameController.makeToast(controller: gameController, message: "Correct!", dur: 1.0)
                    }
                    self.run(SKAction.wait(forDuration: 1.0)) {
                        self.respawnShip() //respawns after 1 sec
                    }
                }
            }
        } else { //this block never actually gets hit but does no harm
            destroy(node: element) //if it doesn't match any of that criteria just destroy the element and ship
            destroy(node: ship)
            if checkAnswer() {
                gameController.makeToast(controller: gameController, message: "Correct!", dur: 1.0)
            }
        }
    }
    
    func alertBox(_title: String, _message: String) { //alert box to end the game
        self.view?.isPaused = true
        let alertController = UIAlertController(title: _title, message: _message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (ACTION) -> Void in
            self.gameController.gameOver() //ends the game only when OK is pressed
        }))
        self.gameController.present(alertController, animated: true, completion: nil) //presents it via GameViewController can't be displayed in this class
    }
    
    func checkAnswer() -> Bool { //returns true or false based on array values
        if !store1.isEmpty && !store2.isEmpty {
            if store1[0].isEqual(to: al1) && store2[0].isEqual(to: al2) //if the element matches the image
                || store1[0].isEqual(to: fe1) && store2[0].isEqual(to: fe2)
                || store1[0].isEqual(to: cu1) && store2[0].isEqual(to: cu2)
                || store1[0].isEqual(to: he1) && store2[0].isEqual(to: he2)
                || store1[0].isEqual(to: o1) && store2[0].isEqual(to: o2) {
                clearLists() //clear for new pair
                setScore(result: true) //increments score
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate) //vibrate
                return true
            } else {
                clearLists() //clear for new pair
                gameController.makeToast(controller: gameController, message: "Incorrect.", dur: 1.0)
                setScore(result: false) //decrements score
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate) //vibrate
                return false
            }
        } else {
            return false
        }
    }
    
    func destroy(node: SKNode) {
        let explosion = SKEmitterNode(fileNamed: "Explosion")! //nodes destroyed will explode
        explosion.position = node.position
        addChild(explosion)
        playSound(named: "Explode")
        node.removeAllChildren() //removes node children
        node.removeFromParent() //removes the node itself

        self.run(SKAction.wait(forDuration: 0.5)) {
            explosion.removeFromParent() //disappears after 0.5 secs
        }
    }
    
    func setScore(result: Bool) {
        if (result) {
            GameViewController.score += 1
        } else {
            GameViewController.score -= 1
        }
        self.scoreLabel.text = "Score: \(GameViewController.score)" //sets the score label
    }
    
    func playMusic() {
        let music = SKAudioNode(fileNamed: "Sounds/Music.mp3") //play this MP3 file on loop
        self.addChild(music)
    }
    
    func playSound(named: String) { //plays a sound by file name
        if OptionViewController.sound {
            let fileName = "Sounds/\(named).wav"
            let sound = SKAudioNode(fileNamed: fileName)
            //sound.autoplayLooped = false; //this is removed and replaced with wait as it stopped the sound working completely
            self.addChild(sound)
            self.run(SKAction.wait(forDuration: 0.9)) {
                sound.removeFromParent() //remove the child to stop looped playback
            }
        } else {
            return
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) { //if any nodes collide
        if release { //if ship has been released
            guard let node1 = contact.bodyA.node else {return}
            guard let node2 = contact.bodyB.node else {return}
            
            if node1.name == "ship" {
                collisionDetection(ship: node1, element: node2)
            } else if node2.name == "ship" {
                collisionDetection(ship: node2, element: node1) //makes sure nodes are always correct as bodyA and bodyB keep changing
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { //when screen is touched
        if !release {
            if OptionViewController.hardMode {
                randomiseSprites() //randomises all sprites only for hard mode
            }
            if let touch = touches.first {
                let touchLoc = touch.location(in: self) //gets touch location
                let touchStart = nodes(at: touchLoc) //finds node at that location such as ship
                var sprite = [SKSpriteNode]() //sprite array for sprites that are found
                
                if !touchStart.isEmpty { //if a node is found
                    for node in touchStart { //check each node
                        let nodes = node as! SKSpriteNode //turn node into a SpriteKitNode
                        sprite.append(nodes) //add it to the array
                    }
                    for spriteName in sprite { //iterates through the array
                        if spriteName == ship { //if it's a ship
                            ship.position = touchLoc //set ship position to the touch location
                        }
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) { //when the touch is moved on screen
        if !release {
            if let touch = touches.first { //same as previous method
                let touchLoc = touch.location(in: self)
                let touchStart = nodes(at: touchLoc)
                var sprite = [SKSpriteNode]()
                
                if !touchStart.isEmpty {
                    for node in touchStart {
                        let nodes = node as! SKSpriteNode
                        sprite.append(nodes)
                    }
                    for spriteName in sprite {
                        if spriteName == ship {
                            if touchLoc.x > -460 { //if the ship is dragged passed the boundary
                                ship.position.x = -460 //stop it going further than that point
                                ship.position.y = touchLoc.y //sets vertical position to match touch
                            } else {
                                ship.position = touchLoc //lets the ship to touch location
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { //when the touch is released
        if !release {
            if let touch = touches.first { //same as previous two methods
                let touchLoc = touch.location(in: self)
                let touchStart = nodes(at: touchLoc)
                var sprite = [SKSpriteNode]()
                
                if !touchStart.isEmpty {
                    for node in touchStart {
                        let nodes = node as! SKSpriteNode
                        sprite.append(nodes)
                    }
                    for spriteName in sprite {
                        if spriteName == ship {
                            playSound(named: "Launch") //play launch sound
                            let dx = startPosition.x - touchLoc.x //sets parameters for impulse
                            let dy = startPosition.y - touchLoc.y
                            let impulse = CGVector(dx: dx*10, dy: dy*10) //impulse will accelerate the ship in a direction
                            ship.physicsBody?.applyImpulse(impulse) //applies it to the ship
                            release = true //ship is now released
                        }
                    }
                }
            }
        }
    }
    
    func shake() {
        if release {
            ship.removeAllChildren() //respawns ship if it gets stuck by shaking phone
            ship.removeFromParent()
            respawnShip()
        }
    }
}


