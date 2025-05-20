import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // MARK: - Properties
    weak var viewController: UIViewController?
    private var cardNodes: [CardNode] = []
    private var firstSelectedCard: CardNode?
    private var secondSelectedCard: CardNode?
    private var canFlipCards = true
    
    private var timeElapsed: TimeInterval = 0
    private var timerLabel: SKLabelNode!
    private var scoreLabel: SKLabelNode!
    private var matchesFound = 0
    private var movesDone = 0
    private var timer: Timer?
    
    private var pauseButton: SKSpriteNode!
    private var backButton: SKSpriteNode!
    private var resetButton: SKSpriteNode!
    
    private var settingsButton: SKSpriteNode!
    
    // Card grid configuration
    private let gridWidth = 4
    private let gridHeight = 5
    private let cardSize = CGSize(width: 60, height: 60)
    private let spacing: CGFloat = 20
    
    // Theme colors
    private let headerColor = UIColor(red: 0.6, green: 0.1, blue: 0.1, alpha: 1.0)
    
    // MARK: - Lifecycle Methods
    override func didMove(to view: SKView) {
        setupBackground()
        setupHeader()
        setupCards()
        setupControls()
        startTimer()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        for card in cardNodes where card.contains(location) {
            handleCardTap(card)
        }
        
        if pauseButton.contains(location) {
            handlePauseButtonTap()
        } else if backButton.contains(location) {
            handleBackButtonTap()
        } else if resetButton.contains(location) {
            handleResetButtonTap()
        } else if settingsButton.contains(location) {
            handleSettingsButtonTap()
        }
    }
    
    // MARK: - Setup Methods
    private func setupBackground() {
        
        // Add image to background
        let backgroundImage = SKSpriteNode(imageNamed: "BG_2")
        backgroundImage.size = self.size
        backgroundImage.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        backgroundImage.zPosition = -0.9
        backgroundImage.alpha = 0.3
        addChild(backgroundImage)
    }
    
    private func setupHeader() {
        // Header background
        let headerBackground = SKSpriteNode(color: headerColor, size: CGSize(width: self.size.width - 20, height: 60))
        headerBackground.position = CGPoint(x: self.size.width / 2, y: self.size.height - 125)
        headerBackground.zPosition = 1
        addChild(headerBackground)
        
        // Add border to header
        headerBackground.addGoldenBorder()
        
        // Settings button
        settingsButton = SKSpriteNode(imageNamed: "settings")
        settingsButton.size = CGSize(width: 40, height: 40)
        settingsButton.position = CGPoint(x: 40, y: self.size.height - 50)
        settingsButton.zPosition = 1
        addChild(settingsButton)
        
        // Score label
        scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        scoreLabel.text = "MOVIES: 0"
        scoreLabel.fontSize = 22
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: self.size.width / 4, y: self.size.height - 125)
        scoreLabel.zPosition = 1
        addChild(scoreLabel)
        
        // Timer label
        timerLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        timerLabel.text = "TIME: 00:00"
        timerLabel.fontSize = 22
        timerLabel.fontColor = .white
        timerLabel.position = CGPoint(x: 3 * self.size.width / 4, y: self.size.height - 125)
        timerLabel.zPosition = 1
        addChild(timerLabel)
    }
    
    private func setupCards() {
        var cardTypes = ["card1", "card2", "card3", "card4", "card5", "card6", "card7", "card8", "card9", "card10"]
        
        // Duplicate cards for pairs
        cardTypes += cardTypes
        
        if gridWidth * gridHeight > cardTypes.count {
            let extraNeeded = gridWidth * gridHeight - cardTypes.count
            cardTypes += Array(cardTypes.prefix(extraNeeded))
        }
        
        cardTypes = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: cardTypes) as! [String]
        
        let totalWidth = CGFloat(gridWidth) * (cardSize.width + spacing) - spacing
        let totalHeight = CGFloat(gridHeight) * (cardSize.height + spacing) - spacing
        
        let startX = (self.size.width - totalWidth) / 2 + cardSize.width / 2
        let startY = (self.size.height - totalHeight) / 2 + cardSize.height / 2
        
        var index = 0
        for row in 0..<gridHeight {
            for col in 0..<gridWidth {
                if index < cardTypes.count {
                    let cardType = cardTypes[index]
                    
                    let x = startX + CGFloat(col) * (cardSize.width + spacing)
                    let y = startY + CGFloat(gridHeight - 1 - row) * (cardSize.height + spacing)
                    
                    let card = CardNode(type: cardType, size: cardSize)
                    card.position = CGPoint(x: x, y: y)
                    card.zPosition = 1
                    addChild(card)
                    cardNodes.append(card)
                    
                    index += 1
                }
            }
        }
    }
    
    private func setupControls() {
        let controlsY = cardSize.height / 2 + 40
        
        // Pause button
        pauseButton = SKSpriteNode(imageNamed: "pause")
        pauseButton.size = CGSize(width: 50, height: 50)
        pauseButton.position = CGPoint(x: self.size.width / 4 - 30, y: controlsY)
        pauseButton.zPosition = 2
        addChild(pauseButton)
        
        // Back button
        backButton = SKSpriteNode(imageNamed: "back")
        backButton.size = CGSize(width: 50, height: 50)
        backButton.position = CGPoint(x: self.size.width / 2, y: controlsY)
        backButton.zPosition = 2
        addChild(backButton)
        
        // Reset button
        resetButton = SKSpriteNode(imageNamed: "redo")
        resetButton.size = CGSize(width: 50, height: 50)
        resetButton.position = CGPoint(x: 3 * self.size.width / 4 + 30, y: controlsY)
        resetButton.zPosition = 2
        addChild(resetButton)
    }
    
    // MARK: - Game Logic
    private func handleCardTap(_ card: CardNode) {
        // Ignore taps if cards can't be flipped now or card is already face up
        guard canFlipCards, !card.isFaceUp else { return }
        
        card.flip()
        
        // Process the card selection
        if firstSelectedCard == nil {
            firstSelectedCard = card
        } else {
            secondSelectedCard = card
            canFlipCards = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.checkForMatch()
            }
        }
    }
    
    private func checkForMatch() {
        guard let firstCard = firstSelectedCard, let secondCard = secondSelectedCard else { return }
        
        if firstCard.cardType == secondCard.cardType {
            // Match found
            matchesFound += 1
            movesDone += 1
            scoreLabel.text = "MOVIES: \(movesDone)"
            
            run(SKAction.playSoundFileNamed("match_sound.mp3", waitForCompletion: false))
            
            // Visual effect for matched cards
            let scaleUp = SKAction.scale(to: 1.1, duration: 0.1)
            let scaleDown = SKAction.scale(to: 1.0, duration: 0.1)
            let fadeAlpha = SKAction.fadeAlpha(to: 0.7, duration: 0.2)
            let sequence = SKAction.sequence([scaleUp, scaleDown, fadeAlpha])
            
            firstCard.run(sequence)
            secondCard.run(sequence)
            
            // Check if game is complete
            if matchesFound == cardNodes.count / 2 {
                gameComplete()
            }
        } else {
            // No match, flip cards back
            firstCard.flip()
            secondCard.flip()
            movesDone += 1
            scoreLabel.text = "MOVIES: \(movesDone)"
            run(SKAction.playSoundFileNamed("no_match_sound.mp3", waitForCompletion: false))
        }
        
        // Reset selected cards
        firstSelectedCard = nil
        secondSelectedCard = nil
        canFlipCards = true
    }
    
    private func gameComplete() {
        // Stop the timer
        timer?.invalidate()
        
        // Show settings overlay
        let winOverlay = WinOverlay(size: self.size)
        winOverlay.zPosition = 20
        winOverlay.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        winOverlay.movesLabel.text = "MOVIES: \(movesDone)"
        winOverlay.timerLabel.text = "Time elapsed: \(timeElapsed)"
        addChild(winOverlay)
    }
    
    // MARK: - Control Button Handlers
    private func handlePauseButtonTap() {
        
        if isPaused {
            // Resume game
            isPaused = false
            canFlipCards = true
            startTimer()
            childNode(withName: "pauseOverlay")?.removeFromParent()
        } else {
            // Pause game
            isPaused = true
            timer?.invalidate()
            canFlipCards = false
            // Show pause overlay
            let overlay = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.7), size: self.size)
            overlay.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
            overlay.zPosition = 10
            overlay.name = "pauseOverlay"
            
            let pauseLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
            pauseLabel.text = "PAUSED"
            pauseLabel.fontSize = 40
            pauseLabel.fontColor = .white
            pauseLabel.position = CGPoint(x: 0, y: 0)
            overlay.addChild(pauseLabel)
            
            addChild(overlay)
        }
        removeFromParent()
    }
    
    private func handleBackButtonTap() {
        // Return to menu scene
        let transition = SKTransition.fade(withDuration: 0.5)
        let menuScene = MenuScene(size: self.size)
        self.view?.presentScene(menuScene, transition: transition)
    }
    
    func handleResetButtonTap() {
        // Reset game
        timer?.invalidate()
        let transition = SKTransition.fade(withDuration: 0.3)
        let newGameScene = GameScene(size: self.size)
        self.view?.presentScene(newGameScene, transition: transition)
    }
    
    private func handleSettingsButtonTap() {
        // Show settings overlay
        let settingsOverlay = SettingsOverlay(size: self.size)
        settingsOverlay.zPosition = 20
        settingsOverlay.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        addChild(settingsOverlay)
    }
    
    // MARK: - Timer Methods
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.timeElapsed += 1
            self.updateTimerDisplay()
        }
    }
    
    private func updateTimerDisplay() {
        let minutes = Int(timeElapsed) / 60
        let seconds = Int(timeElapsed) % 60
        timerLabel.text = String(format: "TIME: %02d:%02d", minutes, seconds)
    }
}
