//
//  GameScene.swift
//  SpaceDash
//
//  Created by Ariele Silva.
//  Copyright © 2020 MaristUser. All rights reserved.
//
// Project 1: Native App Game

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
  var GameStarted = Bool(false)
  var Dead = Bool(false)
  let starSound = SKAction.playSoundFileNamed("bonus.wav", waitForCompletion: false)
  
  var score = Int(0)
  var scoreLbl = SKLabelNode()
  var highscoreLbl = SKLabelNode()
  var taptoplayLbl = SKLabelNode()
  var restartBtn = SKSpriteNode()
  var pauseBtn = SKSpriteNode()
  var logoImg = SKSpriteNode()
  var obstPair = SKNode()
  var moveAndRemove = SKAction()
  
  // create rocketship animation
  let rocketshipAtlas = SKTextureAtlas(named: "player")
  var rocketshipSprites = Array<Any>()
  var rocketship = SKSpriteNode()
  var repeatActionRocketship = SKAction()
  
  override func didMove(to view: SKView) {
    createScene()
  }
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if GameStarted == false{
      GameStarted = true
      rocketship.physicsBody?.affectedByGravity = true
      createPauseBtn()
      logoImg.run(SKAction.scale(to: 0.5, duration: 0.3), completion: {
        self.logoImg.removeFromParent()
      })
      taptoplayLbl.removeFromParent()
      self.rocketship.run(repeatActionRocketship)
      
      // asteroid belt obstacles
      let spawn = SKAction.run({
        () in
        self.obstPair = self.createObstacles()
        self.addChild(self.obstPair)
      })
      let delay = SKAction.wait(forDuration: 1.5)
      let spawnDelay = SKAction.sequence([spawn, delay])
      let spawnDelayForever = SKAction.repeatForever(spawnDelay)
      self.run(spawnDelayForever)
      let distance = CGFloat(self.frame.width + obstPair.frame.width)
      let moveObst = SKAction.moveBy(x: -distance - 50, y: 0, duration: TimeInterval(0.008 * distance))
      let removeObst = SKAction.removeFromParent()
      moveAndRemove = SKAction.sequence([moveObst, removeObst])
      
      rocketship.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
      rocketship.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
    }
    else{
      if Dead == false{
        rocketship.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        rocketship.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
      }
    }
    for touch in touches{
      let loc = touch.location(in: self)
      if Dead == true{
        if restartBtn.contains(loc){
          if UserDefaults.standard.object(forKey: "highestScore") != nil {
            let hs = UserDefaults.standard.integer(forKey: "highestScore")
            if  hs < Int(scoreLbl.text!)!{
              UserDefaults.standard.set(scoreLbl.text, forKey: "highestScore")
            }
          }
          else{
            UserDefaults.standard.set(0, forKey: "highestScore")
          }
          restartScene()
        }
      }
      else{
        if pauseBtn.contains(loc){
          if self.isPaused == false{
            self.isPaused = true
            pauseBtn.texture = SKTexture(imageNamed: "play")
          }
          else{
            self.isPaused = false
            pauseBtn.texture = SKTexture(imageNamed: "pause")
          }
        }
      }
    }
  }
  
  override func update(_ currentTime: TimeInterval) {
    // called before each frame is rendered
    if GameStarted == true{
      if Dead == false{
        enumerateChildNodes(withName: "background", using: ({
          (node, error) in
          let spacebackground = node as! SKSpriteNode
          spacebackground.position = CGPoint(x: spacebackground.position.x - 2, y: spacebackground.position.y)
          if spacebackground.position.x <= -spacebackground.size.width{
            spacebackground.position = CGPoint(x: spacebackground.position.x + spacebackground.size.width * 2, y: spacebackground.position.y)
          }
        }))
      }
    }
  }
  func createScene(){
    self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    self.physicsBody?.categoryBitMask = CollisionBitMask.dzoneCategory
    self.physicsBody?.collisionBitMask = CollisionBitMask.rsCategory
    self.physicsBody?.contactTestBitMask = CollisionBitMask.rsCategory
    self.physicsBody?.isDynamic = false
    self.physicsBody?.affectedByGravity = false
    
    self.physicsWorld.contactDelegate = self
    self.backgroundColor = SKColor(red: 80.0/255.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1.0)
    // continuous moving background
    for i in 0..<2{
      let background = SKSpriteNode(imageNamed: "spacebackground")
      background.anchorPoint = CGPoint.init(x: 0, y: 0)
      background.position = CGPoint(x: CGFloat(i) * self.frame.width, y: 0)
      background.name = "background"
      background.size = (self.view?.bounds.size)!
      self.addChild(background)
    }
    // sets up the rocketship sprites
    rocketshipSprites.append(rocketshipAtlas.textureNamed("rocketship"))
    rocketshipSprites.append(rocketshipAtlas.textureNamed("rocketship2"))
    rocketshipSprites.append(rocketshipAtlas.textureNamed("rocketship3"))
    rocketshipSprites.append(rocketshipAtlas.textureNamed("rocketship4"))
    
    self.rocketship = createRS()
    self.addChild(rocketship)
    
    // animates rocketship
    let animateRS = SKAction.animate(with: self.rocketshipSprites as! [SKTexture], timePerFrame: 0.1)
    self.repeatActionRocketship = SKAction.repeatForever(animateRS)
    
    // displays score
    scoreLbl = createScore()
    self.addChild(scoreLbl)
    // displays highscore
    highscoreLbl = createHS()
    self.addChild(highscoreLbl)
    // displays tm
    tm()
    // tap to play
    taptoplayLbl = createTaptoplayLabel()
    self.addChild(taptoplayLbl)
  }
  func didBegin(_ contact: SKPhysicsContact) {
    let firstBody = contact.bodyA
    let secondBody = contact.bodyB
    
    if firstBody.categoryBitMask == CollisionBitMask.rsCategory && secondBody.categoryBitMask == CollisionBitMask.roidbeltCategory || firstBody.categoryBitMask == CollisionBitMask.roidbeltCategory && secondBody.categoryBitMask == CollisionBitMask.rsCategory || firstBody.categoryBitMask == CollisionBitMask.rsCategory && secondBody.categoryBitMask == CollisionBitMask.dzoneCategory || firstBody.categoryBitMask == CollisionBitMask.dzoneCategory && secondBody.categoryBitMask == CollisionBitMask.rsCategory{
      enumerateChildNodes(withName: "obstPair", using: ({
        (node, error) in
        node.speed = 0
        self.removeAllActions()
      }))
      if Dead == false{
        Dead = true
        createRestartBtn()
        pauseBtn.removeFromParent()
        self.rocketship.removeAllActions()
      }
    }
      else if firstBody.categoryBitMask == CollisionBitMask.rsCategory && secondBody.categoryBitMask == CollisionBitMask.starCategory{
        run(starSound)
        score += 1
        scoreLbl.text = "\(score)"
        secondBody.node?.removeFromParent()
      }
      else if firstBody.categoryBitMask == CollisionBitMask.starCategory && secondBody.categoryBitMask == CollisionBitMask.rsCategory{
        run(starSound)
        score += 1
        scoreLbl.text = "\(score)"
        firstBody.node?.removeFromParent()
      }
    }
    func restartScene(){
      self.removeAllChildren()
      self.removeAllActions()
      Dead = false
      GameStarted = false
      score = 0
      createScene()
    }
  }

