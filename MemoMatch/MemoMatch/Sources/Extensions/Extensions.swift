//
//  Extensions.swift
//  MemoMatch
//
//  Created by Роман Глухарев on 15.05.25.
//

import Foundation
import SpriteKit

extension SKSpriteNode {
    func addGoldenBorder() {
        let borderSize: CGFloat = 4.0
        let border = SKShapeNode(rectOf: CGSize(width: self.size.width + borderSize, height: self.size.height + borderSize), cornerRadius: 10)
        border.strokeColor = UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0) // Gold color
        border.lineWidth = borderSize
        border.zPosition = -0.1
        self.addChild(border)
    }
}
