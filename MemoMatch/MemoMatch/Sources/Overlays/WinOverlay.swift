import Foundation
import SpriteKit
import GameplayKit

class WinOverlay: SKNode {
    // MARK: - Properties
    private var background: SKSpriteNode!
    private var newGameButton: SKSpriteNode!
    private var menuButton: SKSpriteNode!
    private var youWinImage: SKSpriteNode!
    private var fireImage: SKSpriteNode!
    var timerLabel: SKLabelNode!
    var movesLabel: SKLabelNode!
    private var gameScene = GameScene()
    
    // MARK: - Initialization
    init(size: CGSize) {
        super.init()
        setupOverlay(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        if newGameButton.contains(convert(location, to: newGameButton.parent!)) {
            removeFromParent()
        }
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

        youWinImage = SKSpriteNode(imageNamed: "youWin")
        youWinImage.size = CGSize(width: 400, height: 400)
        youWinImage.position = CGPoint(x: 0, y: 100)
        panel.addChild(youWinImage)
        
        fireImage = SKSpriteNode(imageNamed: "fire")
        fireImage.size = CGSize(width: 300, height: 300)
        fireImage.position = CGPoint(x: 0, y: 200)
        panel.addChild(fireImage)
        
        // Close button
        newGameButton = SKSpriteNode(imageNamed: "undo")
        newGameButton.size = CGSize(width: 40, height: 40)
        newGameButton.position = CGPoint(x: -40, y: -150)
        panel.addChild(newGameButton)
        
        timerLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        timerLabel.text = "TIME: 00:00"
        timerLabel.fontSize = 14
        timerLabel.fontColor = .white
        timerLabel.position = CGPoint(x: 0, y: -125)
        timerLabel.zPosition = 1
        addChild(timerLabel)
        
        movesLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        movesLabel.text = "MOVIES: "
        movesLabel.fontSize = 18
        movesLabel.fontColor = .white
        movesLabel.position = CGPoint(x: 0, y: -100)
        movesLabel.zPosition = 1
        addChild(movesLabel)
        
        // Enable touch detection
        isUserInteractionEnabled = true
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
}

