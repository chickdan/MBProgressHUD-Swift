//
//  MBBarProgressView.swift
//  MBProgressHUD
//
//  Created by Daniel Chick on 6/1/23.
//  Copyright © 2023 Matej Bukovinski. All rights reserved.
//

import UIKit

public class MBBarProgressView: UIView {
    /**
     * Progress (0.0 to 1.0)
     */
    public var progress: Double {
        didSet {
            setNeedsDisplay()
        }
    }

    /**
     * Bar border line color. Defaults to .white
     */
    public var lineColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }

    /**
     * Bar background color. Defaults to .clear
     */
    public var progressRemainingColor: UIColor {
        didSet {
            setNeedsDisplay()
        }
    }

    /**
     * Bar progress color. Defaults to .white
     */
    public var progressColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }

    // MARK: - -  Lifecycle
    override init(frame: CGRect) {
        self.lineColor = .white
        self.progressColor = .white
        self.progressRemainingColor = .clear
        self.progress  = 0

        super.init(frame: frame)

        backgroundColor = .clear
        isOpaque = false
    }

    required init?(coder aDecoder: NSCoder) {
        self.lineColor = .white
        self.progressColor = .white
        self.progressRemainingColor = .clear
        self.progress  = 0

        super.init(coder: aDecoder)

        backgroundColor = .clear
        isOpaque = false
    }

    override
    public var intrinsicContentSize: CGSize {
        return CGSize(width: 120, height: 10)
    }

    override
    public func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()

        lineColor?.setStroke()
        progressRemainingColor.setFill()
        context?.setLineWidth(2)

        var radius = rect.size.height / 2 - 2

        let makePath = {
            context?.move(to: CGPoint(x: 2, y: rect.size.height/2))
            context?.addArc(tangent1End: CGPoint(x: 2, y: 2),
                            tangent2End: CGPoint(x: radius + 2, y: 2), radius: radius)
            context?.addLine(to: CGPoint(x: rect.size.width - radius - 2, y: 2))
            context?.addArc(tangent1End: CGPoint(x: rect.size.width - 2, y: 2),
                            tangent2End: CGPoint(x: rect.size.width - 2, y: rect.size.height / 2), radius: radius)
            context?.addArc(tangent1End: CGPoint(x: rect.size.width - 2, y: rect.size.height - 2),
                            tangent2End: CGPoint(x: rect.size.width - radius - 2, y: rect.size.height - 2), radius: radius)
            context?.addLine(to: CGPoint(x: radius + 2, y: rect.size.height - 2))
            context?.addArc(tangent1End: CGPoint(x: 2, y: rect.size.height - 2),
                            tangent2End: CGPoint(x: 2, y: rect.size.height/2), radius: radius)

        }
        // Draw background
        makePath()
        context?.fillPath()

        // Draw border
        makePath()
        context?.strokePath()

        progressColor?.setFill()
        radius -= 2
        let amount = CGFloat(progress) * rect.size.width

        if amount >= radius + 4 && amount <= (rect.size.width - radius - 4) {
            // Progress in the middle area
            context?.move(to: CGPoint(x: 4, y: rect.size.height/2))
            context?.addArc(tangent1End: CGPoint(x: 4, y: 4),
                            tangent2End: CGPoint(x: radius+4, y: 4), radius: radius)
            context?.addLine(to: CGPoint(x: amount, y: 4))
            context?.addLine(to: CGPoint(x: amount, y: radius + 4))

            context?.move(to: CGPoint(x: 4, y: rect.size.height/2))
            context?.addArc(tangent1End: CGPoint(x: 4, y: rect.size.height - 4),
                            tangent2End: CGPoint(x: radius+4, y: rect.size.height - 4), radius: radius)
            context?.addLine(to: CGPoint(x: amount, y: rect.size.height - 4))
            context?.addLine(to: CGPoint(x: amount, y: radius + 4))

            context?.fillPath()
        } else if amount > radius + 4 {
            // Progress in the right arc

            let x = amount - (rect.size.width - radius - 4)

            context?.move(to: CGPoint(x: 4, y: rect.size.height/2))
            context?.addArc(tangent1End: CGPoint(x: 4, y: 4),
                            tangent2End: CGPoint(x: radius+4, y: 4), radius: radius)
            context?.addLine(to: CGPoint(x: rect.size.width - radius - 4, y: 4))

            var angle = CGFloat(-acos(x/radius))
            context?.addArc(center: CGPoint(x: rect.size.width - radius - 4, y: rect.size.height/2),
                            radius: radius, startAngle: CGFloat.pi, endAngle: angle, clockwise: false)
            context?.addLine(to: CGPoint(x: amount, y: rect.size.height/2))
            context?.move(to: CGPoint(x: 4, y: rect.size.height/2))
            context?.addArc(tangent1End: CGPoint(x: 4, y: rect.size.height - 4),
                            tangent2End: CGPoint(x: radius + 4, y: rect.size.height - 4), radius: radius)
            context?.addLine(to: CGPoint(x: rect.size.width - radius - 4, y: rect.size.height - 4))
            angle = acos(x/radius)
            context?.addArc(center: CGPoint(x: rect.size.width - radius - 4, y: rect.size.height/2),
                            radius: radius, startAngle: -CGFloat.pi, endAngle: angle, clockwise: true)
            context?.addLine(to: CGPoint(x: amount, y: rect.size.height/2))
            context?.fillPath()

        } else if amount < radius + 4 && amount > 0 {
            // Progress is in the left arc
            context?.move(to: CGPoint(x: 4, y: rect.size.height/2))
            context?.addArc(tangent1End: CGPoint(x: 4, y: 4),
                            tangent2End: CGPoint(x: radius+4, y: 4), radius: radius)
            context?.addLine(to: CGPoint(x: radius + 4, y: rect.size.height/2))

            context?.move(to: CGPoint(x: 4, y: rect.size.height/2))
            context?.addArc(tangent1End: CGPoint(x: 4, y: rect.size.height - 4),
                            tangent2End: CGPoint(x: radius+4, y: rect.size.height - 4), radius: radius)
            context?.addLine(to: CGPoint(x: radius + 4, y: rect.size.height / 4))

            context?.fillPath()
        }
    }
}
