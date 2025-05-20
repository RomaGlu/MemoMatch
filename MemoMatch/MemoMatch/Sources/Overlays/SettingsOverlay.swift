//
//  SettingsOverlay.swift
//  MemoMatch
//
//  Created by Роман Глухарев on 15.05.25.
//

import Foundation
import SpriteKit
import GameplayKit

class SettingsOverlay: SKNode {
    // MARK: - Properties
    private var background: SKSpriteNode!
    private var closeButton: SKSpriteNode!
    
    // MARK: - Initialization
    init(size: CGSize) {
        super.init()
        
        setupOverlay(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupOverlay(size: CGSize) {
        background = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.8), size: size)
        background.position = .zero
        addChild(background)
        
        // Settings panel
        let panel = SKSpriteNode(color: UIColor(red: 0.6, green: 0.1, blue: 0.1, alpha: 1.0), size: CGSize(width: 300, height: 400))
        panel.position = .zero
        panel.addGoldenBorder()
        addChild(panel)
        
        // Settings title
        let title = SKLabelNode(fontNamed: "AvenirNext-Bold")
        title.text = "SETTINGS"
        title.fontSize = 30
        title.fontColor = .white
        title.position = CGPoint(x: 0, y: 150)
        panel.addChild(title)
        
        // Close button
        closeButton = SKSpriteNode(imageNamed: "close")
        closeButton.size = CGSize(width: 40, height: 40)
        closeButton.position = CGPoint(x: 120, y: 150)
        panel.addChild(closeButton)
        
        // Add settings options
        setupSettingsOptions(panel: panel)
        
        // Enable touch detection
        isUserInteractionEnabled = true
    }
    
    private func setupSettingsOptions(panel: SKSpriteNode) {
        // Sound toggle
        let soundLabel = SKLabelNode(fontNamed: "AvenirNext-Regular")
        soundLabel.text = "Sound Effects"
        soundLabel.fontSize = 20
        soundLabel.fontColor = .white
        soundLabel.horizontalAlignmentMode = .left
        soundLabel.position = CGPoint(x: -100, y: 80)
        panel.addChild(soundLabel)
        
        // Vibration toggle
        let vibrationLabel = SKLabelNode(fontNamed: "AvenirNext-Regular")
        vibrationLabel.text = "Vibrations"
        vibrationLabel.fontSize = 20
        vibrationLabel.fontColor = .white
        vibrationLabel.horizontalAlignmentMode = .left
        vibrationLabel.position = CGPoint(x: -100, y: 30)
        panel.addChild(vibrationLabel)
        
        // Difficulty selector
        let difficultyLabel = SKLabelNode(fontNamed: "AvenirNext-Regular")
        difficultyLabel.text = "Difficulty"
        difficultyLabel.fontSize = 20
        difficultyLabel.fontColor = .white
        difficultyLabel.horizontalAlignmentMode = .left
        difficultyLabel.position = CGPoint(x: -100, y: -20)
        panel.addChild(difficultyLabel)
        
        let soundToggle = ToggleSwitch(
                    toggleType: .sound,
                    position: CGPoint(x: 100, y: 80)
                )
                addChild(soundToggle)
                
                // Add vibration toggle
                let vibrationToggle = ToggleSwitch(
                    toggleType: .vibration,
                    position: CGPoint(x: 100, y: 30)
                )
                addChild(vibrationToggle)
        
        // Difficulty buttons
        let easyButton = createButton(text: "Easy", isSelected: true)
        easyButton.position = CGPoint(x: -60, y: -60)
        panel.addChild(easyButton)
        
        let mediumButton = createButton(text: "Medium", isSelected: false)
        mediumButton.position = CGPoint(x: 30, y: -60)
        panel.addChild(mediumButton)
        
        let hardButton = createButton(text: "Hard", isSelected: false)
        hardButton.position = CGPoint(x: 100, y: -60)
        panel.addChild(hardButton)
    }
    
    private func createButton(text: String, isSelected: Bool) -> SKNode {
        let buttonNode = SKNode()
        
        let background = SKSpriteNode(color: isSelected ? .orange : .darkGray, size: CGSize(width: 80, height: 30))
        buttonNode.addChild(background)
        
        let label = SKLabelNode(fontNamed: "AvenirNext-Regular")
        label.text = text
        label.fontSize = 16
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        buttonNode.addChild(label)
        
        return buttonNode
    }
    
    // MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        if closeButton.contains(convert(location, to: closeButton.parent!)) {
            removeFromParent()
        }
    }
}
