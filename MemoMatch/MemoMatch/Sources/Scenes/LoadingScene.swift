//
//  LoadingScene.swift
//  MemoMatch
//
//  Created by Роман Глухарев on 16.05.25.
//

import Foundation
import SpriteKit

class LoadingScene: SKScene {
    
    private var fireNode: SKSpriteNode!
    private var isLoading = true
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        setupFireAnimation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.isLoading = false
            self.transitionToMenuScene()
        }
    }
    
    private func setupFireAnimation() {
        if let fireImage = UIImage(named: "fire") {
            fireNode = SKSpriteNode(imageNamed: "fire")
            print("\(fireImage.scale)")
        } else {
            fireNode = SKSpriteNode(color: .orange, size: CGSize(width: 70, height: 90))
            let texturePath = Bundle.main.path(forResource: "fire", ofType: "png")
            print("\(String(describing: texturePath?.debugDescription))")
        }
        
        fireNode.position = CGPoint(x: size.width / 2, y: -fireNode.size.height/2)
        fireNode.name = "fire"
        fireNode.alpha = 0.8
        addChild(fireNode)
        print("Fire node added at position: \(fireNode.position)")
        
        let fireEmitter = createFireEmitter()
        fireEmitter.position = CGPoint(x: fireNode.position.x, y: fireNode.position.y - 20)
        fireEmitter.zPosition = -1
        addChild(fireEmitter)
            
        let moveAction = SKAction.run { [weak self, weak fireEmitter] in
            guard let self = self, let fireNode = self.fireNode, let emitter = fireEmitter else { return }
            emitter.position = CGPoint(x: fireNode.position.x, y: fireNode.position.y - 20)
        }
        let wait = SKAction.wait(forDuration: 0.05) // Update position 20 times per second
        let sequence = SKAction.sequence([wait, moveAction])
        fireEmitter.run(.repeatForever(sequence))
        
        animateFire()
        
        let loadingLabel = SKLabelNode(text: "Loading...")
        loadingLabel.fontName = "AvenirNext-Bold"
        loadingLabel.fontSize = 24
        loadingLabel.fontColor = .white
        loadingLabel.position = CGPoint(x: size.width / 2, y: size.height - 100)
        addChild(loadingLabel)
        
        let fadeAction = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.4, duration: 0.8),
            SKAction.fadeAlpha(to: 1.0, duration: 0.8)
        ])
        loadingLabel.run(.repeatForever(fadeAction))
    }
    
    private func createFireEmitter() -> SKEmitterNode {
        let emitter = SKEmitterNode()
        
        // Basic emitter properties
        emitter.particleBirthRate = 80
        emitter.numParticlesToEmit = -1
        emitter.particleLifetime = 1.2
        emitter.particleLifetimeRange = 0.4
        emitter.emissionAngle = .pi / 2
        emitter.emissionAngleRange = 0.25
        emitter.particleSpeed = 60
        emitter.particleSpeedRange = 20
        emitter.particleAlpha = 0.8
        emitter.particleAlphaRange = 0.2
        emitter.particleAlphaSpeed = -0.15
        emitter.particleScale = 1.0
        emitter.particleScaleRange = 0.3
        emitter.particleScaleSpeed = -0.2
        emitter.particlePosition = .zero
        emitter.particlePositionRange = CGVector(dx: 40, dy: 10)
        
        return emitter
    }
    
    private func animateFire() {
        // Move fire from bottom to top with some oscillation for a more natural effect
        let moveUp = SKAction.moveTo(y: size.height + fireNode.size.height/2, duration: 5.0)
        
        // Add some horizontal oscillation for a more natural fire movement
        let oscillateRight = SKAction.moveBy(x: 15, y: 0, duration: 0.3)
        let oscillateLeft = SKAction.moveBy(x: -15, y: 0, duration: 0.3)
        let oscillate = SKAction.sequence([oscillateRight, oscillateLeft, oscillateRight, oscillateLeft])
        
        // Scale variation
        let scaleUp = SKAction.scale(by: 1.1, duration: 0.5)
        let scaleDown = SKAction.scale(by: 0.9, duration: 0.5)
        let scaleAction = SKAction.sequence([scaleUp, scaleDown])
        
        // Combine actions
        let group = SKAction.group([moveUp, .repeatForever(oscillate), .repeatForever(scaleAction)])
        
        // Run the animation on the fire node
        fireNode.run(group)
    }
    
    private func transitionToMenuScene() {
        let menuScene = MenuScene(size: self.size)
        menuScene.scaleMode = .resizeFill

        let transition = SKTransition.fade(withDuration: 1.0)
        view?.presentScene(menuScene, transition: transition)
    }
}
