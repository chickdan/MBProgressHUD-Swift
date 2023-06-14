//
//  MBBackgroundView.swift
//  MBProgressHUD
//
//  Created by Daniel Chick on 6/1/23.
//  Copyright © 2023 Matej Bukovinski. All rights reserved.
//

import UIKit

class MBBackgroundView: UIView {

    /**
     * The background color or the blur tint color.
     */
    public var color: UIColor {
        didSet {
            backgroundColor = color
            if color == .clear {
                effectView.removeFromSuperview()
            } else {
                addSubview(effectView)
            }
        }
    }

    private var effectView: UIVisualEffectView

    // MARK: - -  Lifecycle
    override init(frame: CGRect) {
        if kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_8_0 {
            color = UIColor(white: 0.8, alpha: 0.6)
        } else {
            color = UIColor(white: 0.95, alpha: 0.6)
        }
        effectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))

        super.init(frame: frame)

        clipsToBounds = true
        addSubview(effectView)
        effectView.frame = bounds
        effectView.autoresizingMask = [.flexibleHeight, .flexibleWidth ]
        backgroundColor = color
        layer.allowsGroupOpacity = false
    }

    required init?(coder aDecoder: NSCoder) {
        if kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_8_0 {
            color = UIColor(white: 0.8, alpha: 0.6)
        } else {
            color = UIColor(white: 0.95, alpha: 0.6)
        }
        effectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))

        super.init(coder: aDecoder)

        clipsToBounds = true
        addSubview(effectView)
        effectView.frame = bounds
        effectView.autoresizingMask = [.flexibleHeight, .flexibleWidth ]
        backgroundColor = color
        layer.allowsGroupOpacity = false
    }

    override var intrinsicContentSize: CGSize {
        return CGSize.zero
    }
}
