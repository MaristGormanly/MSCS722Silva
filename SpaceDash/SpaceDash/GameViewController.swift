//
//  GameViewController.swift
//  SpaceDash
//
//  Created by Ariele Silva.
//  Copyright © 2020 MaristUser. All rights reserved.
//
// Project 1: Native App Game

import UIKit
import SpriteKit
//import GameplayKit

class GameViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let scene = GameScene(size: view.bounds.size)
    let skView = view as! SKView
    skView.showsFPS = false
    skView.showsNodeCount = false
    skView.ignoresSiblingOrder = false
    scene.scaleMode = .resizeFill
    skView.presentScene(scene)
    
  }

  override var shouldAutorotate: Bool {
      return false
  }

  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
      if UIDevice.current.userInterfaceIdiom == .phone {
          return .allButUpsideDown
      } else {
          return .all
      }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  override var prefersStatusBarHidden: Bool {
      return true
  }
}
