
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
import RxKeyboard

import VisualEffectView

class TabBarView: UIView {
    var disposeBag = DisposeBag()
    
    private var viewModel: TabBarViewModel!
    private let height: CGFloat = 60
    
    private var tintLayer: CALayer!
    private var blurView: VisualEffectView!
    private let rowContainer = UIView()
    
    var searchButton: TabBarButton!
    var statButton: TabBarButton!
    var plusButton: TabBarButton!
    var filterButton: TabBarButton!
    var menuButton: TabBarButton!
    var searchField: SearchTextField!
    
    init() {
        super.init(frame: .zero)
        
        setUpViews()
        setUpLayout()
        setUpSelf()
        setUpBindings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func safeAreaInsetsDidChange() {
        setUpSelf()
    }
    
    //MARK: - PRIVATE
    private func setUpBindings() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { height in
                self.transform = CGAffineTransform(translationX: 0, y: -height)
            })
            .disposed(by: disposeBag)
        
        searchField.done
            .map { _ in false }
            .bind(to: self.searchButton.isOn)
            .disposed(by: disposeBag)
        
        searchButton.isOn
            .subscribe(onNext: { isOn in
                if isOn {
                    self.searchField.becomeFirstResponder()
                    Animator.showSearch(tabBar: self)
                }
                else {
                    //todo
                    self.searchField.text = ""
                    self.searchField.resignFirstResponder()
                    Animator.hideSearch(tabBar: self)
                }
            })
            .disposed(by: disposeBag)

    }
    
    private func setUpLayout() {
        addSubview(blurView)
        
        rowContainer.clip.enable().withDistribution(.row)
        addSubview(rowContainer)
        addSubview(searchField)
        searchButton.clip.aligned(v: .stretch, h: .stretch).insetLeft(20)
        rowContainer.addSubview(searchButton)
        statButton.clip.aligned(v: .stretch, h: .stretch)
        rowContainer.addSubview(statButton)
        rowContainer.addSubview(plusButton)
        filterButton.clip.aligned(v: .stretch, h: .stretch)
        rowContainer.addSubview(filterButton)
        menuButton.clip.aligned(v: .stretch, h: .stretch).insetRight(20)
        rowContainer.addSubview(menuButton)
    }
    
    private func setUpViews() {
        blurView = {
            let blurView = VisualEffectView(frame: .zero)
            blurView.blurRadius = 5
            tintLayer = CAGradientLayer.Elements.tabBar
            blurView.contentView.layer.addSublayer(tintLayer)
            return blurView
        }()
        searchField = SearchTextField()
        searchButton = {
            let view = TabBarButton()
            view.clip.enable()
            view.deselectedImage = #imageLiteral(resourceName: "magnifier")
            view.selectedImage = #imageLiteral(resourceName: "magnifier_blue")
            return view
        }()
        statButton = {
            let view = TabBarButton()
            view.clip.enable()
            view.deselectedImage = #imageLiteral(resourceName: "stat")
            view.selectedImage = #imageLiteral(resourceName: "stat_blue")
            return view
        }()
        plusButton = {
            let view = TabBarButton()
            view.clip.enable()
            view.animate = false
            view.selectedImage = #imageLiteral(resourceName: "addButton")
            view.deselectedImage = #imageLiteral(resourceName: "addButton")
            view.setImage(#imageLiteral(resourceName: "addButton"), for: .normal)
            return view
        }()
        filterButton = {
            let view = TabBarButton()
            view.clip.enable()
            view.deselectedImage = #imageLiteral(resourceName: "filter")
            view.selectedImage = #imageLiteral(resourceName: "filter_blue")
            return view
        }()
        menuButton = {
            let view = TabBarButton()
            view.clip.enable()
            view.deselectedImage = #imageLiteral(resourceName: "menu")
            view.selectedImage = #imageLiteral(resourceName: "menu_blue")
            return view
        }()
        let concurrentButtons = [menuButton!, searchButton!, filterButton!, statButton!]
        concurrentButtons.forEach { $0.concurrentButtons = concurrentButtons }
    }
    
    private func setUpSelf() {
        clip.enable()
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

extension TabBarView: MVVMBinder {
    func set(viewModel: TabBarViewModel) {
        self.disposeBag = DisposeBag()
        self.viewModel = viewModel
        setUpBindings()
    }
}
