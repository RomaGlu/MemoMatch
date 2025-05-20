import Foundation
import SpriteKit
import SafariServices

class MenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        let backgroundImage = SKSpriteNode(imageNamed: "BG_1")
        backgroundImage.size = self.size
        backgroundImage.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        backgroundImage.zPosition = -0.9
        addChild(backgroundImage)
        
        let parallaxImage = SKSpriteNode(imageNamed: "parallax")
        parallaxImage.size = CGSize(width: 800, height: 800)
        parallaxImage.position = CGPoint(x: self.size.width / 2, y: self.size.height / 1.7)
        parallaxImage.zPosition = -0.9
        addChild(parallaxImage)
        
        let crownImage = SKSpriteNode(imageNamed: "crown")
        crownImage.size = CGSize(width: 400, height: 400)
        crownImage.position = CGPoint(x: self.size.width / 2, y: self.size.height / 1.3)
        crownImage.zPosition = -0.9
        addChild(crownImage)
        
        let playButton = SKSpriteNode(imageNamed: "play_button")
        playButton.name = "play"
        playButton.size = CGSize(width: 250, height: 75)
        playButton.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.5)
        playButton.zPosition = 2
        addChild(playButton)
        
        let privacyPolicyButton = SKSpriteNode(imageNamed: "privacy_button")
        privacyPolicyButton.name = "privacy"
        privacyPolicyButton.size = CGSize(width: 175, height: 50)
        privacyPolicyButton.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.3)
        privacyPolicyButton.zPosition = 2
        addChild(privacyPolicyButton)
    }
    
    private func createButton(text: String, position: CGPoint) -> SKNode {
        let buttonNode = SKNode()
        buttonNode.position = position
        
        let background = SKSpriteNode(color: UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0), size: CGSize(width: 200, height: 60))
        background.name = text
        background.addGoldenBorder()
        buttonNode.addChild(background)
        return buttonNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let nodes = self.nodes(at: location)
        for node in nodes {
            if node.name == "play" {
                let transition = SKTransition.fade(withDuration: 0.5)
                let gameScene = GameScene(size: self.size)
                self.view?.presentScene(gameScene, transition: transition)
                break
            } else if node.name == "privacy" {
                openPrivacyPolicyURL(URL: "https://www.google.com/search?sca_esv=a4b38bb1e8b0b431&sxsrf=AHTn8zokN5RwBUhzlOmiGCY9pzhOc-G72A:1747413175111&q=%D0%BA%D0%BE%D1%82%D0%B8%D0%BA%D0%B8&udm=2&fbs=ABzOT_DLDkiLLB_RVmAYJoJJvF89c_5rhhX09S3YP1g91pK-oLcodXZomCNyb-_9hLVMbdo6nRbGiCMiSkVcO5sb2Bhfv9yreOl1cDRxuGiW1zxyMHne8-Kz_5ubWWshdEwkJ6Hr929u0c0iFNpCZrvNs7A6FpIfha5eT1oOve6btT0UJx8-Y9qQ8zRS6v_l5fX41RnP02T0uSrlugXaiHzUhe63yPgvbnol312l6kZBRAmxh5AzEDHzD48B1xKz4NIzhefGD2GV&sa=X&ved=2ahUKEwjH_8-staiNAxW52AIHHakJMr0QtKgLegQIHhAB&biw=1440&bih=788&dpr=2")
                break
            }
        }
    }
    
    func openPrivacyPolicyURL(URL:String) {
        
        if let url = NSURL(string: URL) {
            let vc: UIViewController = (self.view?.window?.rootViewController)!
            let safariView = SFSafariViewController(url: url as URL)
            vc.present(safariView, animated: true, completion: nil)
        }
        
    }
    
}
