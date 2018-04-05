//
//  NSView+Constraints.swift
//  RoadGraph
//
//  Created by Алексей on 06.04.2018.
//  Copyright © 2018 Алексей. All rights reserved.
//

import Foundation
import Cocoa

extension NSView {
    
    func equalWidthToSuperview(multiplier: CGFloat = 1.0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        guard let superview = self.superview else {
            preconditionFailure("`superview` was nil – call `addSubview(view: UIView)` before calling `equalWidthToSuperview` to fix this.")
        }
        let widthConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: superview, attribute: .width, multiplier: multiplier, constant: 0)
        superview.addConstraint(widthConstraint)
    }

}


