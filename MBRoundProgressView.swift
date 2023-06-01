//
//  MBRoundProgressView.swift
//  MBProgressHUD
//
//  Created by Daniel Chick on 6/1/23.
//  Copyright © 2023 Matej Bukovinski. All rights reserved.
//

import UIKit

class MBRoundProgressView: UIView {
    var progress: CGFloat {
        didSet {
            setNeedsDisplay()
        }
    }
    var progressTintColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    var backgroundTintColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }

    /**
     * Display mode - false = round or true = annular. Defaults to round.
     */
    var isAnnular: Bool {
        didSet {
            setNeedsDisplay()
        }
    }

    // MARK: - -  Lifecycle
    override init(frame: CGRect) {
        self.progress               = 0
        self.progressTintColor      = .white
        self.backgroundTintColor    = UIColor.white.withAlphaComponent(0.1)
        self.isAnnular              = false

        super.init(frame: frame)

        backgroundColor             = .clear
        isOpaque                    = false
    }
    required init?(coder aDecoder: NSCoder) {
        self.progress               = 0
        self.progressTintColor      = .white
        self.backgroundTintColor    = UIColor.white.withAlphaComponent(0.1)
        self.isAnnular              = false

        super.init(coder: aDecoder)

        backgroundColor             = .clear
        isOpaque                    = false
    }

    // MARK: - - Drawing
    override func draw(_ rect: CGRect) {

        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        if isAnnular {
            // Draw background
            let lineWidth: CGFloat = 2.0
            let processBackgroundPath = UIBezierPath()
            processBackgroundPath.lineWidth = lineWidth
            processBackgroundPath.lineCapStyle = .butt
            let radius = (bounds.size.width - lineWidth)/2
            let startAngle = -CGFloat.pi / 2 // 90 degrees
            var endAngle = 2 * CGFloat.pi + startAngle
            processBackgroundPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            backgroundTintColor?.set()
            processBackgroundPath.stroke()
            // Draw progress
            let processPath = UIBezierPath()
            processPath.lineCapStyle = .square
            processPath.lineWidth = lineWidth
            endAngle = progress * 2 * CGFloat.pi + startAngle
            processPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            progressTintColor?.set()
            processPath.stroke()
        } else {
            let lineWidth: CGFloat = 2
            let allRect = self.bounds
            let circleRect = allRect.insetBy(dx: lineWidth/2, dy: lineWidth/2)

            let context = UIGraphicsGetCurrentContext()

            // Draw background
            progressTintColor?.setStroke()
            backgroundTintColor?.setFill()
            context?.setLineWidth(lineWidth)
            context?.strokeEllipse(in: circleRect)

            // Draw progress
            let center = CGPoint(x: allRect.size.width / 2, y: allRect.size.height / 2)
            let startAngle = -CGFloat.pi/2
            let processPath = UIBezierPath()
            processPath.lineCapStyle = .butt
            processPath.lineWidth = lineWidth * 2
            let radius = bounds.width / 2 - processPath.lineWidth / 2
            let endAngle = progress * 2 * CGFloat.pi + startAngle
            processPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            // Ensure that we don't get color overlaping when _progressTintColor alpha < 1.f.
            context?.setBlendMode(.copy)
            progressTintColor?.set()
            processPath.stroke()
        }
    }
}
