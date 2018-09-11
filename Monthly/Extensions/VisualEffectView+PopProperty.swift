//
//  VisualEffectView+PopProperty.swift
//  Monthly
//
//  Created by Denis Litvin on 10.09.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import Foundation
import pop
import VisualEffectView

extension VisualEffectView {
    static let popBlurRadius: POPAnimatableProperty =
    {
        let property = (POPAnimatableProperty.property(withName: "blurRadius", initializer: { prop in
            guard let prop = prop else {
                return
            }
            // read value
            prop.readBlock = { obj, values in
                guard let obj = obj as? VisualEffectView, let values = values else {
                    return
                }
                
                values[0] = obj.blurRadius
            }
            // write value
            prop.writeBlock = { obj, values in
                guard var obj = obj as? VisualEffectView, let values = values else {
                    return
                }
                
                obj.blurRadius = values[0]
            }
            // dynamics threshold
            prop.threshold = 0.01
        })) as! POPAnimatableProperty
        return property
    }()
}
