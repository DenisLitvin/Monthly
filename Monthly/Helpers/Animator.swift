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
    
    static func slideDown(view: UIScrollView) {
        view.layer.pop_removeAllAnimations()
        let animation = POPSpringAnimation(propertyNamed: kPOPLayerTranslationY)
        animation?.toValue = max(0, view.contentOffset.y) + view.frame.height
        view.layer.pop_add(animation, forKey: "slideDown")
        animation?.completionBlock = { _, finished  in
            if finished {
//                view.isHidden = true
                //todo - fix 
            }
        }
    }
    
    static func slideUp(view: UIScrollView) {
        view.isHidden = false
        view.layer.pop_removeAllAnimations()
        let animation = POPSpringAnimation(propertyNamed: kPOPLayerTranslationY)
        animation?.toValue = 0.0
        view.layer.pop_add(animation, forKey: "slideUp")
    }
    
    static func stopAllAnimations(view: UIView) {
        view.layer.pop_removeAllAnimations()
        view.pop_removeAllAnimations()
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
        view.layer.pop_removeAllAnimations()

        let animation = POPBasicAnimation(propertyNamed: kPOPLayerTranslationY)
        animation?.toValue = view.frame.height
        animation?.duration = 0.3
        view.layer.pop_add(animation, forKey: "slideDown")
        animation?.completionBlock = { _,final in
            if final {
                view.isHidden = true
            }
        }
    }
    
    static func showTabBar(view: TabBarView) {
        view.isHidden = false
        view.layer.pop_removeAllAnimations()
        
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
        button.transform = CGAffineTransform(scaleX: 1, y: 1)
        mask?.pop_removeAllAnimations()
        button.titleView.pop_removeAllAnimations()
        
        let alphaAnim = POPSpringAnimation(propertyNamed: kPOPViewAlpha)
        alphaAnim?.toValue = 1
        button.titleView.pop_add(alphaAnim, forKey: "alpha")
        
        let anim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        anim?.toValue = NSValue(cgSize: CGSize(width: 4, height: 4))
        mask?.pop_add(anim, forKey: "scale")
    }
    
    static func hideSave(button: SaveButton) {
        let mask = button.layer.mask
        mask?.pop_removeAllAnimations()
        button.titleView.pop_removeAllAnimations()
        
        let alphaAnim = POPSpringAnimation(propertyNamed: kPOPViewAlpha)
        alphaAnim?.toValue = 0
        button.titleView.pop_add(alphaAnim, forKey: "alpha")
        
        let scaleAnim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnim?.toValue = NSValue(cgSize: CGSize(width: 1, height: 1))
        mask?.pop_add(scaleAnim, forKey: "scale")
        scaleAnim?.completionBlock = { _, finished in
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
            anim.completionBlock = { _, finished in
                if finished { makeAnimation() }
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
        tabBar.searchField.isHidden = false

        let views = [tabBar.menuButton, tabBar.sortButton, tabBar.plusButton, tabBar.statButton]
        let anim = POPSpringAnimation(propertyNamed: kPOPLayerSubtranslationX)
        anim?.toValue = UIScreen.main.bounds.width
        views.forEach { view in
            view?.layer.pop_removeAnimation(forKey: "translation")
            view?.layer.pop_add(anim, forKey: "translation")
        }
        let searchFieldAnim = POPSpringAnimation(propertyNamed: kPOPShapeLayerStrokeEnd)
        searchFieldAnim?.toValue = 1
        let layer = tabBar.searchField.layer.sublayers!.filter { $0 is CAShapeLayer }.first!
        layer.pop_removeAnimation(forKey: "stroke")
        layer.pop_add(searchFieldAnim, forKey: "stroke")
        }
    
    static func hideSearch(tabBar: TabBarView) {
        let views = [tabBar.menuButton, tabBar.sortButton, tabBar.plusButton, tabBar.statButton]
        let subviewsAnim = POPSpringAnimation(propertyNamed: kPOPLayerSubtranslationX)
        subviewsAnim?.toValue = 0
        views.forEach { view in
            view?.layer.pop_removeAnimation(forKey: "translation")
            view?.layer.pop_add(subviewsAnim, forKey: "translation")
        }
        
        let strokeAnim = POPSpringAnimation(propertyNamed: kPOPShapeLayerStrokeEnd)
        strokeAnim?.toValue = 0
        let layer = tabBar.searchField.layer.sublayers!.filter { $0 is CAShapeLayer }.first!
        layer.pop_removeAnimation(forKey: "stroke")
        layer.pop_add(strokeAnim, forKey: "stroke")
        strokeAnim?.completionBlock = { _,finished in
            if finished {
                tabBar.searchField.isHidden = true
            }
        }
    }
}
