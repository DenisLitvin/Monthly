
//
//  File.swift
//  Monthly
//
//  Created by Denis Litvin on 29.08.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture

import VisualEffectView

class PlusButton: TabBarButton {
//    override init() {
//        super.init()
//
//    }
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
}
    
class TabBarButton: UIButton {
    var disposeBag = DisposeBag()

    //OUTPUT
    var isOn = BehaviorSubject<Bool>.init(value: false)
    
    var selectedImage: UIImage? { willSet { changeImage() } }
    var deselectedImage: UIImage? { willSet { changeImage() } }
    var animate = true
    var concurrentButtons: [TabBarButton] = []
    
    init() {
        super.init(frame: .zero)
        imageView?.contentMode = .scaleAspectFit

        self.addTarget(self, action: #selector(didTouchUpInside), for: .touchUpInside)
        self.addTarget(self, action: #selector(didTouchDown), for: .touchDown)
        self.addTarget(self, action: #selector(didDragOutside), for: .touchDragOutside)
        isOn
            .subscribe(onNext: { _ in
                self.changeImage()
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
    
    private func changeImage () {
        let image = try! self.isOn.value() ? self.selectedImage : self.deselectedImage
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

class TabBarView: UIView {
    private let disposeBag = DisposeBag()
    
    private let viewModel = TabBarViewModel()
    private let height: CGFloat = 60
    
    private var tintLayer: CALayer!
    private var blurView: VisualEffectView!
    private let rowContainer = UIView()

    var searchButton: TabBarButton!
    var statButton: TabBarButton!
    var plusButton: TabBarButton!
    var filterButton: TabBarButton!
    var menuButton: TabBarButton!
    
//    var searchBar: UISearchBar!
    
    init() {
        super.init(frame: .zero)
        
        setUpViews()
        setUpLayout()
        setUpSelf()
        
        searchButton.isOn
            .subscribe(onNext: { isOn in
                if isOn {
                    Animator.showSearch(tabBar: self)
                }
                else {
                    Animator.hideSearch(tabBar: self)
                }
            })
            .disposed(by: disposeBag)

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func safeAreaInsetsDidChange() {
        setUpSelf()
    }
    
    //MARK: - PRIVATE
    private func setUpLayout() {
        addSubview(blurView)

        rowContainer.clip.enabled().withDistribution(.row)
        addSubview(rowContainer)
//        rowContainer.addSubview(searchBar)
//        searchBar.makeConstraints(for: .left, .right, .centerX, .centerY) { (make) in
//            make.pin(to: self.rowContainer.leftAnchor, const: UIScreen.main.bounds.width / 4)
//            make.pin(to: self.rowContainer.rightAnchor)
//            make.pin(to: self.rowContainer.centerXAnchor)
//            make.pin(to: self.rowContainer.centerYAnchor)
//        }
        searchButton.clip.aligned(v: .stretch, h: .stretch).insetLeft(20)
        rowContainer.addSubview(searchButton)
        statButton.clip.aligned(v: .stretch, h: .stretch).insetRight(10)
        rowContainer.addSubview(statButton)
        rowContainer.addSubview(plusButton)
        filterButton.clip.aligned(v: .stretch, h: .stretch).insetLeft(10)
        rowContainer.addSubview(filterButton)
        menuButton.clip.aligned(v: .stretch, h: .stretch).insetRight(20)
        rowContainer.addSubview(menuButton)

    }
    
    private func setUpViews() {
        
        blurView = {
            let blurView = VisualEffectView(frame: .zero)
            blurView.blurRadius = 8
            tintLayer = CAGradientLayer.Elements.tabBar
            blurView.contentView.layer.addSublayer(tintLayer)
            return blurView
        }()
        searchButton = {
           let view = TabBarButton()
            view.clip.enabled()
            view.deselectedImage = #imageLiteral(resourceName: "magnifier")
            view.selectedImage = #imageLiteral(resourceName: "magnifier_blue")
            return view
        }()
        statButton = {
            let view = TabBarButton()
            view.clip.enabled()
            view.deselectedImage = #imageLiteral(resourceName: "stat")
            view.selectedImage = #imageLiteral(resourceName: "stat_blue")
            return view
        }()
        plusButton = {
            let view = TabBarButton()
            view.clip.enabled()
            view.animate = false
            view.selectedImage = #imageLiteral(resourceName: "addButton")
            view.deselectedImage = #imageLiteral(resourceName: "addButton")
            view.setImage(#imageLiteral(resourceName: "addButton"), for: .normal)
            return view
        }()
        filterButton = {
            let view = TabBarButton()
            view.clip.enabled()
            view.deselectedImage = #imageLiteral(resourceName: "filter")
            view.selectedImage = #imageLiteral(resourceName: "filter_blue")
            return view
        }()
        menuButton = {
            let view = TabBarButton()
            view.clip.enabled()
            view.deselectedImage = #imageLiteral(resourceName: "menu")
            view.selectedImage = #imageLiteral(resourceName: "menu_blue")
            return view
        }()
        let concurrentButtons = [menuButton!, searchButton!, filterButton!, statButton!]
        concurrentButtons.forEach { $0.concurrentButtons = concurrentButtons }
    }
    
    private func setUpSelf() {
        clip.enabled()
        clipsToBounds = true
        
        let screenSize = UIScreen.main.bounds.size
        var height: CGFloat = 60

        if #available(iOS 11.0, *),
            self.safeAreaInsets.bottom > 0 {
            
            height += self.safeAreaInsets.bottom + 10
            let radius: CGFloat = 35
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            self.layer.cornerRadius = radius
            
            rowContainer.clip.verticallyAligned(.head).insetTop(13)
        }
        else {
            rowContainer.clip.verticallyAligned(.mid).insetTop(0)
        }
        
        let frame = CGRect(x: 0, y: screenSize.height - height, width: screenSize.width, height: height)
        self.frame = frame
        tintLayer.frame.size = frame.size
        blurView.frame.size = frame.size

    }
}
