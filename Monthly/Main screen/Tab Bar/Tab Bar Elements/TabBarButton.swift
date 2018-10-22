//
//  TabBarButotn.swift
//  Monthly
//
//  Created by Denis Litvin on 10/13/18.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class TabBarButton: UIButton {
    var disposeBag = DisposeBag()
    
    var isOn = BehaviorSubject<Bool>.init(value: false)
    
    var selectedImage: UIImage? { didSet { changeImage() } }
    var deselectedImage: UIImage? { didSet { changeImage() } }
    var animate = true
    var concurrentButtons: [TabBarButton] = []
    
    init() {
        super.init(frame: .zero)
        imageView?.contentMode = .scaleAspectFit
        
        self.addTarget(self, action: #selector(didTouchUpInside), for: .touchUpInside)
        self.addTarget(self, action: #selector(didTouchDown), for: .touchDown)
        self.addTarget(self, action: #selector(didDragOutside), for: .touchDragOutside)
        
        isOn.asObservable()
            .subscribe(onNext: { isOn in
                self.changeImage(isOn)
            })
            .disposed(by: disposeBag)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reverseState() {
        let current = try! isOn.value()
        concurrentButtons.forEach { $0.isOn.onNext(false) }
        isOn.onNext(!current)
    }
    
    private func changeImage(_ isOn: Bool = false) {
        let image = isOn ? self.selectedImage : self.deselectedImage
        self.setImage(image, for: .normal)
    }
    
    @objc private func didTouchUpInside() {
        reverseState()
        if animate { Animator.scaleUp(view: self) }
    }
    
    @objc private func didDragOutside() {
        if animate { Animator.scaleUp(view: self) }
    }
    
    @objc private func didTouchDown() {
        if animate { Animator.scaleDown(view: self) }
    }
}
