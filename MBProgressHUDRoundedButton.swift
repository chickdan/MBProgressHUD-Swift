//
//  MBProgressHUDRoundedButton.swift
//  MBProgressHUD
//
//  Created by Daniel Chick on 6/1/23.
//  Copyright © 2023 Matej Bukovinski. All rights reserved.
//

import UIKit

public class MBProgressHUDRoundedButton: UIButton {

    // MARK: - - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = 1.0
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.borderWidth = 1.0
    }

    // MARK: - - Layout
    override
    public func layoutSubviews() {
        super.layoutSubviews()
        // Fully rounded corners
        self.layer.cornerRadius = ceil(self.bounds.height / 2)
    }

    override
    public var intrinsicContentSize: CGSize {
        // Only show if we have associated control events
        if allControlEvents.rawValue == 0 {
            return CGSize.zero
        }

        var size = super.intrinsicContentSize
        // Add some side padding
        size.width += 20
        return size
    }

    // MARK: - - Color
    override
    public func setTitleColor(_ color: UIColor?, for state: UIControl.State) {
        super.setTitleColor(color, for: state)
        // Update related colors
        if isHighlighted {
            isHighlighted = true
        }

        layer.borderColor = color?.cgColor
    }

    override
    public var isHighlighted: Bool {
        didSet {
            let baseColor = self.titleColor(for: .selected)
            backgroundColor = isHighlighted ? baseColor?.withAlphaComponent(0.1) : .clear
        }
    }
}
