//
//  NSAttributedString+theme.swift
//  Monthly
//
//  Created by Denis Litvin on 25.08.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import UIKit

extension String {
    
    func attributedForAmount() -> NSAttributedString {
        let attrStr = NSMutableAttributedString(string: "$ \(self)",
                                                attributes: [.kern: -0.6])
        attrStr.addAttribute(.foregroundColor, value: UIColor.Theme.gray, range: NSRange.init(location: 0, length: 1))
        return attrStr
    }
        
    func attributedForDate() -> NSAttributedString {
        return NSAttributedString(string: self.uppercased(), attributes: [.kern: 0.9])
    }
}
