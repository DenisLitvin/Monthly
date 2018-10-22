//
//  CheckEdgeLessDisplay.swift
//  Monthly
//
//  Created by Denis Litvin on 10/21/18.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import UIKit

extension UIApplication {
    func isEdgelessDisplay() -> Bool {
        if #available(iOS 11.0, *) {
            return delegate!.window??.safeAreaInsets.top ?? 0 > 0
        } else {
            return false
        }
    }
}
