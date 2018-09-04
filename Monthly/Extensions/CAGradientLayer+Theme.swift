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
        
        static var cellCategory: CAGradientLayer {
            let layer = CAGradientLayer()
            layer.colors = [
                UIColor(red: 27/255, green: 97/255, blue: 204/255, alpha: 1).cgColor,
                UIColor(red: 14/255, green: 153/255, blue: 211/255, alpha: 1).cgColor
            ]
            layer.startPoint = CGPoint(x: 0.0, y: 1)
            layer.endPoint = CGPoint(x: 0.8, y: 0.0)
            return layer
        }
        
        static var cellBackground: CAGradientLayer {
            let layer = CAGradientLayer()
            layer.colors = [
                UIColor(red: 24/255, green: 35/255, blue: 65/255, alpha: 1).cgColor,
                UIColor(red: 33/255, green: 44/255, blue: 76/255, alpha: 1).cgColor
            ]
            layer.startPoint = CGPoint(x: 0.0, y: 0.8)
            layer.endPoint = CGPoint(x: 1.0, y: 0.2)
            return layer
        }
        
        static var slider: CAGradientLayer {
            let layer = CAGradientLayer()
            layer.colors = [
                UIColor(red: 41/255, green: 56/255, blue: 101/255, alpha: 0.7).cgColor,
                UIColor(red: 47/255, green: 90/255, blue: 136/255, alpha: 0.7).cgColor
            ]
            layer.startPoint = CGPoint(x: 0.0, y: 0.8)
            layer.endPoint = CGPoint(x: 1.0, y: 0.2)
            return layer
        }
        
        static var tabBar: CAGradientLayer {
            let layer = CAGradientLayer()
            layer.colors = [
                UIColor(red: 49/255, green: 61/255, blue: 88/255, alpha: 0.7).cgColor,
                UIColor(red: 7/255, green: 18/255, blue: 40/255, alpha: 0.7).cgColor
            ]
            layer.locations = [-0.4, 1]
            return layer
        }

    }
}
