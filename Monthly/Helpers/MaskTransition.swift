//
//  ViewTransitionManager.swift
//  Monthly
//
//  Created by Denis Litvin on 28.08.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import UIKit

class MaskTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var maskFrame: CGRect
    var duration = 0.4
    var presenting = true
    var originFrame = CGRect.zero
    
    init(maskFrame: CGRect) {
        self.maskFrame = maskFrame
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        containerView.addSubview(toView)
        
        let mask = CALayer()
        mask.contents = #imageLiteral(resourceName: "mask").cgImage
        mask.frame = CGRect(x: maskFrame.minX, y: maskFrame.minY, width: maskFrame.width, height: maskFrame.height)
        toView.layer.mask = mask
        
        let amount = max(UIScreen.main.bounds.height, UIScreen.main.bounds.width)
        let oldBounds = CGRect(x: 0, y: 0, width: maskFrame.width, height: maskFrame.height)
        let newBounds = CGRect(x: 0, y: 0, width: amount * 2.5, height: amount * 2.5)
        
        let anim = Animator.revealOpenAnimation(from: oldBounds, to: newBounds, with: duration)
        toView.layer.mask?.add(anim, forKey: "reveal")
        toView.layer.mask?.bounds = newBounds
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            transitionContext.completeTransition(true)
        }
    }
}
