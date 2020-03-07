//
//  GameElements.swift
//  SpaceDash
//
//  Created by Ariele Silva.
//  Copyright © 2020 MaristUser. All rights reserved.
//
// Project 1: Native App Game

import Foundation
import SpriteKit

struct CollisionBitMask{
  static let rsCategory:UInt32 = 0x1 << 0
  static let roidbeltCategory:UInt32 = 0x1 << 1
  static let starCategory:UInt32 = 0x1 << 2
  static let dzoneCategory:UInt32 = 0x1 << 3
}
extension GameScene{
  func createRS() -> SKSpriteNode{
    // 1
    let rocketship = SKSpriteNode(texture: SKTextureAtlas(named: "player").textureNamed("rocketship"))
    rocketship.size = CGSize(width: 75, height: 100)
    rocketship.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
    // 2
    rocketship.physicsBody = SKPhysicsBody(circleOfRadius: rocketship.size.width / 2)
    rocketship.physicsBody?.linearDamping = 1.1
    rocketship.physicsBody?.restitution = 0
    // 3
    rocketship.physicsBody?.categoryBitMask = CollisionBitMask.rsCategory
    rocketship.physicsBody?.collisionBitMask = CollisionBitMask.roidbeltCategory | CollisionBitMask.dzoneCategory
    rocketship.physicsBody?.contactTestBitMask = CollisionBitMask.roidbeltCategory | CollisionBitMask.starCategory | CollisionBitMask.dzoneCategory
    // 4
    rocketship.physicsBody?.affectedByGravity = false
    rocketship.physicsBody?.isDynamic = true
    
    return rocketship
  }
  // menu buttons
  // restart button
  func createRestartBtn(){
    restartBtn = SKSpriteNode(imageNamed: "restart")
    restartBtn.size = CGSize(width: 100, height: 100)
    restartBtn.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
    restartBtn.zPosition = 6
    restartBtn.setScale(0)
    self.addChild(restartBtn)
    restartBtn.run(SKAction.scale(to: 1.0, duration: 0.3))
  }
  // pause button
  func createPauseBtn(){
    pauseBtn = SKSpriteNode(imageNamed: "pause")
    pauseBtn.size = CGSize(width: 40, height: 40)
    pauseBtn.position = CGPoint(x: self.frame.width - 30, y: 30)
    pauseBtn.zPosition = 6
    self.addChild(pauseBtn)
  }
  // score
  func createScore() -> SKLabelNode{
    let scoreLbl = SKLabelNode()
    scoreLbl.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 2.6)
    scoreLbl.text = "\(score)"
    scoreLbl.zPosition = 5
    scoreLbl.fontSize = 50
    scoreLbl.fontName = "CenturyGothic-Bold"
    
    let scoreBackground = SKShapeNode()
    scoreBackground.position = CGPoint(x: 0, y: 0)
    scoreBackground.path = CGPath(roundedRect: CGRect(x: CGFloat(-50), y: CGFloat(-30), width: CGFloat(100), height: CGFloat(100)), cornerWidth: 50, cornerHeight: 50, transform: nil)
    let scoreColor = UIColor(red: CGFloat(0.0 / 255.0), green: CGFloat(0.0 / 255.0), blue: CGFloat(0.0/255.0), alpha: CGFloat(0.2))
    scoreBackground.strokeColor = UIColor.clear
    scoreBackground.fillColor = scoreColor
    scoreBackground.zPosition = -1
    scoreLbl.addChild(scoreBackground)
    return scoreLbl
  }
  // highscore
  func createHS() -> SKLabelNode{
    let highscoreLbl = SKLabelNode()
    highscoreLbl.position = CGPoint(x: self.frame.width - 80, y: self.frame.height - 22)
    if let highestScore = UserDefaults.standard.object(forKey: "highestScore"){
      highscoreLbl.text = "Highest Score: \(highestScore)"
    }
    else{
      highscoreLbl.text = "Highest Score: 0"
    }
    highscoreLbl.zPosition = 5
    highscoreLbl.fontSize = 15
    highscoreLbl.fontName = "CenturyGothic-Bold"
    return highscoreLbl
  }
  // gametitle tm (i wish i could trademark it hahaha)
  func tm(){
    logoImg = SKSpriteNode()
    logoImg = SKSpriteNode(imageNamed: "spacedash")
    logoImg.size = CGSize(width: 272, height: 65)
    logoImg.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 100)
    logoImg.setScale(0.5)
    self.addChild(logoImg)
    logoImg.run(SKAction.scale(to: 1.0, duration: 0.3))
  }
  //
  func createTaptoplayLabel() -> SKLabelNode{
    let taptoplayLbl = SKLabelNode()
      taptoplayLbl.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 100)
      taptoplayLbl.text = "Tap anywhere to play!"
      taptoplayLbl.fontColor = UIColor.white
      taptoplayLbl.zPosition = 5
      taptoplayLbl.fontSize = 20
      taptoplayLbl.fontName = "CenturyGothic-Bold"
      return taptoplayLbl
    }
  func createObstacles() -> SKNode{
    let starNode = SKSpriteNode(imageNamed: "star")
    starNode.size = CGSize(width: 40, height: 40)
    starNode.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2)
    starNode.physicsBody = SKPhysicsBody(rectangleOf: starNode.size)
    starNode.physicsBody?.affectedByGravity = false
    starNode.physicsBody?.isDynamic = false
    starNode.physicsBody?.categoryBitMask = CollisionBitMask.starCategory
    starNode.physicsBody?.collisionBitMask = 0
    starNode.physicsBody?.contactTestBitMask = CollisionBitMask.rsCategory
    starNode.color = SKColor.yellow
    
    obstPair = SKNode()
    obstPair.name = "obstPair"
    
    let topObst = SKSpriteNode(imageNamed: "asteroidbelt")
    let bottomObst = SKSpriteNode(imageNamed: "asteroidbelt")
    
    topObst.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 + 420)
    bottomObst.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 - 420)
    
    topObst.setScale(0.5)
    bottomObst.setScale(0.5)
    // top obstacle
    topObst.physicsBody = SKPhysicsBody(rectangleOf: topObst.size)
    topObst.physicsBody?.categoryBitMask = CollisionBitMask.roidbeltCategory
    topObst.physicsBody?.collisionBitMask = CollisionBitMask.rsCategory
    topObst.physicsBody?.contactTestBitMask = CollisionBitMask.rsCategory
    topObst.physicsBody?.isDynamic = false
    topObst.physicsBody?.affectedByGravity = false
    // bottom obstacle
    bottomObst.physicsBody = SKPhysicsBody(rectangleOf: bottomObst.size)
    bottomObst.physicsBody?.categoryBitMask = CollisionBitMask.roidbeltCategory
    bottomObst.physicsBody?.collisionBitMask = CollisionBitMask.rsCategory
    bottomObst.physicsBody?.contactTestBitMask = CollisionBitMask.rsCategory
    bottomObst.physicsBody?.isDynamic = false
    bottomObst.physicsBody?.affectedByGravity = false
    
    topObst.zRotation = CGFloat.pi
    
    obstPair.addChild(topObst)
    obstPair.addChild(bottomObst)
    obstPair.zPosition = 1
    
    // difficulty placement
    let randomPos = random(min: -200, max: 200)
    obstPair.position.y = obstPair.position.y + randomPos
    obstPair.addChild(starNode)
    obstPair.run(moveAndRemove)
    return obstPair
  }
  func random() -> CGFloat{
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
  }
  func random(min : CGFloat, max : CGFloat) -> CGFloat{
    return random() * (max - min) + min
  }
}
