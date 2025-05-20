//
//  CardNode.swift
//  MemoMatch
//
//  Created by Роман Глухарев on 15.05.25.
//

import Foundation
import SpriteKit

class CardNode: SKSpriteNode {
    // MARK: - Properties
    let cardType: String
    private let faceTexture: SKTexture
    private let backTexture: SKTexture
    
    var isFaceUp = false
    
    // MARK: - Initialization
    init(type: String, size: CGSize) {
        self.cardType = type
        self.faceTexture = SKTexture(imageNamed: "\(type)")
        self.backTexture = SKTexture(imageNamed: "card0")
        
        super.init(texture: backTexture, color: .clear, size: size)
        
        addGoldenBorder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Card Actions
    func flip() {
        isFaceUp.toggle()
        
        let firstHalfFlip = SKAction.scaleX(to: 0.0, duration: 0.15)
        let secondHalfFlip = SKAction.scaleX(to: 1.0, duration: 0.15)
        
        let setTexture = SKAction.run { [weak self] in
            guard let self = self else { return }
            self.texture = self.isFaceUp ? self.faceTexture : self.backTexture
        }
        
        let flipSequence = SKAction.sequence([firstHalfFlip, setTexture, secondHalfFlip])
        run(flipSequence)
    }
}
