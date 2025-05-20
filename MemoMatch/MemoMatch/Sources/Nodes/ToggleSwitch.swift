//
//  ToggleSwitch.swift
//  MemoMatch
//
//  Created by Роман Глухарев on 17.05.25.
//

import Foundation
import SpriteKit

class ToggleSwitch: SKNode {
    
    // MARK: - Properties
    private let background = SKShapeNode()
    private let thumb = SKShapeNode()
    private let label = SKLabelNode()
    
    private var isOn: Bool
    private var toggleType: ToggleType
    private let width: CGFloat = 60
    private let height: CGFloat = 30
    private let padding: CGFloat = 3
    
    enum ToggleType {
        case sound
        case vibration
        
        var title: String {
            switch self {
            case .sound:
                return "Sound Effects"
            case .vibration:
                return "Vibration"
            }
        }
    }
    
    // MARK: - Initialization
    init(toggleType: ToggleType, position: CGPoint) {
        self.toggleType = toggleType
        
        // Initialize with current setting
        switch toggleType {
        case .sound:
            self.isOn = GameSettings.shared.isSoundEnabled
        case .vibration:
            self.isOn = GameSettings.shared.isVibrationEnabled
        }
        
        super.init()
        
        self.position = position
        setupUI()
        updateVisuals()
        
        let notificationName: Notification.Name
        switch toggleType {
        case .sound:
            notificationName = .soundSettingChanged
        case .vibration:
            notificationName = .vibrationSettingChanged
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(settingChanged),
            name: notificationName,
            object: nil
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        isUserInteractionEnabled = true
        
        background.path = CGPath(roundedRect: CGRect(x: -width/2, y: -height/2, width: width, height: height),
                                cornerWidth: height/2, cornerHeight: height/2, transform: nil)
        background.lineWidth = 0
        addChild(background)
        
        thumb.path = CGPath(ellipseIn: CGRect(x: -height/2 + padding, y: -height/2 + padding,
                                           width: height - 2*padding, height: height - 2*padding), transform: nil)
        thumb.lineWidth = 0
        thumb.fillColor = .white
        addChild(thumb)

    }
    
    // MARK: - Visual Updates
    private func updateVisuals() {
        background.fillColor = isOn ? .green : .darkGray
        
        let thumbDestination = isOn ? width/2 - height/2 : -width/2 + height/2
        let moveAction = SKAction.moveTo(x: thumbDestination, duration: 0.2)
        moveAction.timingMode = .easeOut
        thumb.run(moveAction)
    }
    
    // MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let scaleDown = SKAction.scale(to: 0.95, duration: 0.1)
        run(scaleDown)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let scaleUp = SKAction.scale(to: 1.0, duration: 0.1)
        run(scaleUp)
        
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        let toggleRect = CGRect(x: -width/2, y: -height/2, width: width, height: height)
        if toggleRect.contains(touchLocation) {
            toggle()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        let scaleUp = SKAction.scale(to: 1.0, duration: 0.1)
        run(scaleUp)
    }
    
    // MARK: - Toggle Action
    func toggle() {
        isOn.toggle()
        
        switch toggleType {
        case .sound:
            GameSettings.shared.isSoundEnabled = isOn
            if isOn {
                playToggleSound()
            }
        case .vibration:
            GameSettings.shared.isVibrationEnabled = isOn
            if isOn {
                generateHapticFeedback()
            }
        }
        
        updateVisuals()
        
        if GameSettings.shared.isVibrationEnabled {
            generateHapticFeedback()
        }
    }
    
    @objc private func settingChanged() {
        switch toggleType {
        case .sound:
            isOn = GameSettings.shared.isSoundEnabled
        case .vibration:
            isOn = GameSettings.shared.isVibrationEnabled
        }
        
        updateVisuals()
    }
    
    // MARK: - Feedback Methods
    private func playToggleSound() {
        run(SKAction.playSoundFileNamed("toggle.wav", waitForCompletion: false))
    }
    
    private func generateHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }
}
