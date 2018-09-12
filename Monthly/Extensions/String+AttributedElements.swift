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
        let attrStr = NSMutableAttributedString(string: self,
                                                attributes: [.kern: -0.6])
//        attrStr.addAttribute(.font,
//                             value: UIFont.dynamic(14, family: .proximaNovaCond),
//                             range: NSRange.init(location: 0, length: 1))
        return attrStr
    }
    
    func attributedForSliderPlaceholder() -> NSAttributedString {
        return NSAttributedString(string: self, attributes: [.foregroundColor: UIColor.Theme.grayedBlue,
                                                             .font: UIFont.dynamic(11, family: .proximaNova)])
    }

    func attributedForSliderText() -> NSAttributedString {
        return NSAttributedString(string: self.uppercased(), attributes: [.kern: 2])
    }
    
    func attributedForCategory() -> NSAttributedString {
        return NSAttributedString(string: self.uppercased(), attributes: [.kern: 2])
    }
    
    func attributedForDate() -> NSAttributedString {
        return NSAttributedString(string: self.uppercased(), attributes: [.kern: 0.9])
    }
}
