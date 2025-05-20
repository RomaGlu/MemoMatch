//
//  GameViewController.swift
//  MemoMatch
//
//  Created by Роман Глухарев on 13.05.25.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("GameViewController loaded")
    
        let skView = SKView(frame: view.bounds)
        skView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(skView)
        
        print("SKView manually created with size: \(skView.bounds.size.width) x \(skView.bounds.size.height)")
        
        // Start with the loading scene
        let loadingScene = LoadingScene(size: skView.bounds.size)
        loadingScene.scaleMode = .resizeFill
        
        // Present the loading scene
        skView.presentScene(loadingScene)
        
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsDrawCount = true
        
        print("Loading scene presented")
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
