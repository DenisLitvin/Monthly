
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
import VisualEffectView

class PlusButton: TwoStatedButton {
    
    override init() {
        super.init()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    
class TwoStatedButton: UIButton {
    //OUTPUT
    var isOn = BehaviorSubject<Bool>.init(value: false)
    
    
    init() {
        super.init(frame: .zero)
        self.addTarget(self, action: #selector(didTouchUpInside), for: .touchUpInside)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func reverseState() {
        isOn.onNext(!(try! isOn.value()))
    }
    @objc private func didTouchUpInside() {
        reverseState()
    }
}

class TabBarView: UIView {
    private let disposeBag = DisposeBag()
    private let viewModel = TabBarViewModel()
    private let height: CGFloat = 60
    
    private var tintLayer: CALayer!
    private var blurView: VisualEffectView!
    private let rowContainer = UIView()

    var searchButton: TwoStatedButton!
    var statButton: TwoStatedButton!
    var plusButton: PlusButton!
    var filterButton: TwoStatedButton!
    var menuButton: TwoStatedButton!
    
    init() {
        super.init(frame: .zero)
        
        setUpViews()
        setUpLayout()
        setUpSelf()
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
        
        rowContainer.addSubview(searchButton)
        statButton.clip.insetLeft(40).insetRight(36)
        rowContainer.addSubview(statButton)
        rowContainer.addSubview(plusButton)
        filterButton.clip.insetLeft(36).insetRight(45)
        rowContainer.addSubview(filterButton)
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
           let view = TwoStatedButton()
            view.clip.enabled()
            view.setImage(#imageLiteral(resourceName: "magnifier"), for: .normal)
            view.imageView?.contentMode = .scaleAspectFit
            return view
        }()
        statButton = {
            let view = TwoStatedButton()
            view.clip.enabled()
            view.setImage(#imageLiteral(resourceName: "stat"), for: .normal)
            view.imageView?.contentMode = .scaleAspectFit
            return view
        }()
        plusButton = {
            let view = PlusButton()
            view.clip.enabled()
            view.setImage(#imageLiteral(resourceName: "addButton"), for: .normal)
            view.imageView?.contentMode = .scaleAspectFit
            return view
        }()
        filterButton = {
            let view = TwoStatedButton()
            view.clip.enabled()
            view.setImage(#imageLiteral(resourceName: "filter"), for: .normal)
            view.imageView?.contentMode = .scaleAspectFit
            return view
        }()
        menuButton = {
            let view = TwoStatedButton()
            view.clip.enabled()
            view.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
            view.imageView?.contentMode = .scaleAspectFit
            return view
        }()
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
