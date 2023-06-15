//
//  MBBackgroundView.swift
//  MBProgressHUD
//
//  Created by Daniel Chick on 6/1/23.
//  Copyright © 2023 Matej Bukovinski. All rights reserved.
//

import UIKit

public enum MBProgressHUDBackgroundStyle: Int {
    /// Solid color background
    case solidColor
    /// UIVisualEffectView or UIToolbar.layer background view
    case blur
}

public class MBBackgroundView: UIView {

    /**
     * The background style.
     * Defaults to .blur.
     */
    public var style: MBProgressHUDBackgroundStyle = .blur {
        didSet {
            updateForBackgroundStyle()
        }
    }
    
    /**
     * The blur effect style, when using KProgressHUDBackgroundStyle.blur.
     * Defaults to UIBlurEffectStyleLight.
     */
    public var blurEffectStyle: UIBlurEffect.Style = .light {
        didSet {
            updateForBackgroundStyle()
        }
    }

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
        color = UIColor(white: 0.8, alpha: 0.6)
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
        color = UIColor(white: 0.8, alpha: 0.6)
        effectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))

        super.init(coder: aDecoder)

        clipsToBounds = true
        addSubview(effectView)
        effectView.frame = bounds
        effectView.autoresizingMask = [.flexibleHeight, .flexibleWidth ]
        backgroundColor = color
        layer.allowsGroupOpacity = false
    }

    override
    public var intrinsicContentSize: CGSize {
        return CGSize.zero
    }
    
    func updateForBackgroundStyle() {
        effectView.removeFromSuperview()
        
        if style == .blur {
            let effect = UIBlurEffect(style: blurEffectStyle)
            let effectView = UIVisualEffectView(effect: effect)
            effectView.frame = bounds
            effectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            
            insertSubview(effectView, at: 0)
            backgroundColor = color
            layer.allowsGroupOpacity = false
            
            self.effectView = effectView
        } else {
            backgroundColor = color
        }
    }
    
    func updateViewsForColor() {
        backgroundColor = color
    }
}
