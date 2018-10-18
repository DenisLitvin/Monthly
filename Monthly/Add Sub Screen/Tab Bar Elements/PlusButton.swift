//
//  PlusButton.swift
//  Monthly
//
//  Created by Denis Litvin on 10/13/18.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import UIKit

class PlusButton: TabBarButton {
        override init() {
            super.init()
            
            clip.enable()
            animate = false
            selectedImage = #imageLiteral(resourceName: "addButton")
            deselectedImage = #imageLiteral(resourceName: "addButton")
            setImage(#imageLiteral(resourceName: "addButton"), for: .normal)
//            clip.wantsSize = CGSize(width: 50, height: 50)
        }
    
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
}
