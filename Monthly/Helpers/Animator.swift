//
//  Animator.swift
//  Monthly
//
//  Created by Denis Litvin on 26.08.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import UIKit
import VisualEffectView
import pop

class Animator {
    
    static func slideDown(view: UIView) {
        view.pop_removeAllAnimations()
        let animation = POPSpringAnimation(propertyNamed: kPOPLayerTranslationY)
        animation?.toValue = view.frame.height
        view.layer.pop_add(animation, forKey: "slideDown")
        animation?.completionBlock = { _, finished  in
            if finished {
                view.isHidden = true
            }
        }
    }
    
    static func slideUp(view: UIView, initial: Bool = false) {
        view.isHidden = false
        view.pop_removeAllAnimations()
        let animation = POPSpringAnimation(propertyNamed: kPOPLayerTranslationY)
        animation?.toValue = 0.0
        view.layer.pop_add(animation, forKey: "slideUp")
    }
    
    static func stopAllAnimations(view: UIView) {
        view.layer.pop_removeAllAnimations()
    }
    
    static func decayY(view: UIView, velocity: CGFloat) {
        view.layer.pop_removeAnimation(forKey: "decay")
        let anim = POPDecayAnimation(propertyNamed: kPOPLayerTranslationY)
        anim?.velocity = velocity
        view.layer.pop_add(anim, forKey: "decay")
    }
    
    static func presentCells(_ cells: [UIView]) {
        let cells = cells.sorted { $0.frame.origin.y < $1.frame.origin.y }
        for cell in cells {
            cell.alpha = 0
            cell.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height / 3)
        }
        for i in 0 ..< cells.count {
            let cell = cells[i]
            UIView.animate(withDuration: 0.4 + (Double(i) * 0.1),
                           delay: 0, usingSpringWithDamping: 0.9,
                           initialSpringVelocity: 0.5,
                           options: .curveEaseIn,
                           animations: {
                            
                            cell.transform = .identity
                            cell.alpha = 1
            })
        }
    }
    
    static func showBlur(view: VisualEffectView) {
        view.isHidden = false
        view.pop_removeAllAnimations()
        
        let animation = POPBasicAnimation()
        animation.toValue = 9
        animation.duration = 0.3
        animation.property = VisualEffectView.popBlurRadius
        view.pop_add(animation, forKey: "blurRadius")
    }
    
    static func hideBlur(view: VisualEffectView) {
        view.pop_removeAllAnimations()
        
        let animation = POPBasicAnimation()
        animation.toValue = 0
        animation.duration = 0.3
        animation.property = VisualEffectView.popBlurRadius
        view.pop_add(animation, forKey: "blurRadius")
        animation.completionBlock = { _, finished  in
            if finished {
                view.isHidden = true
            }
        }
    }
    
    static func hideTabBar(view: TabBarView) {
        view.plusButton.isHidden = true
        let animation = POPBasicAnimation(propertyNamed: kPOPLayerTranslationY)
        animation?.toValue = view.frame.height
        animation?.duration = 0.3
        view.layer.pop_add(animation, forKey: "slideDown")
    }
    
    static func showTabBar(view: TabBarView) {
        let animation = POPBasicAnimation(propertyNamed: kPOPLayerTranslationY)
        animation?.toValue = 0.0
        animation?.duration = 0.3
        view.layer.pop_add(animation, forKey: "slideUp")
        animation?.completionBlock = { _, finished in
            if finished {
                view.plusButton.isHidden = false
            }
        }
    }
    
    static func showSave(button: SaveButton) {
        let mask = button.layer.mask
        button.isHidden = false
        button.alpha = 1
        mask?.pop_removeAllAnimations()
        button.titleView.pop_removeAllAnimations()
        
        let alphaAnim = POPSpringAnimation(propertyNamed: kPOPViewAlpha)
        alphaAnim?.toValue = 1
        button.titleView.pop_add(alphaAnim, forKey: "alpha")
        
        let animX = POPSpringAnimation(propertyNamed: kPOPLayerScaleX)
        animX?.toValue = 4
        
        let animY = POPSpringAnimation(propertyNamed: kPOPLayerScaleY)
        animY?.toValue = 4
        
        mask?.pop_add(animX, forKey: "scaleX")
        mask?.pop_add(animY, forKey: "scaleY")
    }
    
    static func hideSave(button: SaveButton) {
        let mask = button.layer.mask
        mask?.pop_removeAllAnimations()
        button.titleView.pop_removeAllAnimations()
        
        let alphaAnim = POPSpringAnimation(propertyNamed: kPOPViewAlpha)
        alphaAnim?.toValue = 0
        button.titleView.pop_add(alphaAnim, forKey: "alpha")
        
        let animX = POPSpringAnimation(propertyNamed: kPOPLayerScaleX)
        animX?.toValue = 1
        
        let animY = POPSpringAnimation(propertyNamed: kPOPLayerScaleY)
        animY?.toValue = 1
        
        mask?.pop_add(animX, forKey: "scaleX")
        mask?.pop_add(animY, forKey: "scaleY")
        animX?.completionBlock = { _, finished in
            if finished {
                let anim = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
                anim?.toValue = 0
                anim?.duration = 0.1
                button.pop_add(anim, forKey: "alpha")
            }
        }
    }
    
    static func scaleUp(view: UIView) {
        let makeAnimation = {
            let anim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
            anim?.dynamicsMass = 1.5
            anim?.dynamicsFriction = 30
            anim?.dynamicsTension = 1000
            anim?.toValue = CGPoint(x: 1, y: 1)
            view.layer.pop_add(anim, forKey: "scale")
        }
        if let anim = view.layer.pop_animation(forKey: "scale") as? POPBasicAnimation {
            anim.completionBlock = { _, _ in
                makeAnimation()
            }
        }
        else { makeAnimation() }
    }
    
    static func scaleDown(view: UIView) {
        view.pop_removeAllAnimations()
        let anim = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
        anim?.duration = 0.05
        anim?.toValue = CGPoint(x: 0.7, y: 0.7)
        view.layer.pop_add(anim, forKey: "scale")
    }
    
    static func showSearch(tabBar: TabBarView) {
        let views = [tabBar.menuButton, tabBar.filterButton, tabBar.plusButton, tabBar.statButton]
        let anim = POPSpringAnimation(propertyNamed: kPOPLayerSubtranslationX)
        anim?.toValue = UIScreen.main.bounds.width
        views.forEach { view in
            view?.layer.pop_removeAnimation(forKey: "translation")
            view?.layer.pop_add(anim, forKey: "translation")
        }
    }
    
    static func hideSearch(tabBar: TabBarView) {
        let views = [tabBar.menuButton, tabBar.filterButton, tabBar.plusButton, tabBar.statButton]
        let anim = POPSpringAnimation(propertyNamed: kPOPLayerSubtranslationX)
        anim?.toValue = 0
        views.forEach { view in
            view?.layer.pop_removeAnimation(forKey: "translation")
            view?.layer.pop_add(anim, forKey: "translation")
        }
    }
}
