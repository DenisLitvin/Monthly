//
//  CAGradientLayer.swift
//  Monthly
//
//  Created by Denis Litvin on 29.08.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import UIKit

extension CAGradientLayer {
    struct Elements {
        
        static var cellCategory: CALayer {
            let layer = CALayer()
            layer.contents = #imageLiteral(resourceName: "category").cgImage
            return layer
        }
        
        static var cellStat: CAGradientLayer {
            let layer = CAGradientLayer()
            layer.colors = [
                UIColor(red: 0/255, green: 122/255, blue: 203/255, alpha: 1).cgColor,
                UIColor(red: 23/255, green: 27/255, blue: 99/255, alpha: 1).cgColor
            ]
            layer.startPoint = CGPoint(x: 0, y: 0)
            layer.endPoint = CGPoint(x: 1, y: 1)
//            layer.locations = [0.3, 1]
            return layer
        }
        
        static var cellBackground: CAGradientLayer {
            let layer = CAGradientLayer()
            layer.colors = [
                UIColor(red: 25/255, green: 33/255, blue: 75/255, alpha: 1).cgColor,
                UIColor(red: 21/255, green: 41/255, blue: 90/255, alpha: 1).cgColor
            ]
            layer.startPoint = CGPoint(x: 0.0, y: 0.8)
            layer.endPoint = CGPoint(x: 1.0, y: 0.2)
            layer.locations = [0.3, 1]
            return layer
        }
        
        static var slider: CALayer {
            let layer = CALayer()
            layer.backgroundColor = UIColor(red: 31/255, green: 47/255, blue: 82/255, alpha: 0.7).cgColor
            return layer
        }
        
        static var tabBar: CAGradientLayer {
            let layer = CAGradientLayer()
            layer.colors = [
                UIColor(red: 39/255, green: 63/255, blue: 118/255, alpha: 0.7).cgColor,
                UIColor(red: 26/255, green: 33/255, blue: 77/255, alpha: 0.7).cgColor
            ]
            layer.locations = [-0.4, 1]
            return layer
        }

    }
}
