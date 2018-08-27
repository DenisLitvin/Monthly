//
//  ViewController.swift
//  Monthly
//
//  Created by Denis Litvin on 10.08.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import UIKit
import ClipLayout
import Pinner
import RxSwift
import RxCocoa

class Header: ClipCell, DataBinder {
    func set(data: Sub) {
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Footer: ClipCell, DataBinder {
    let title: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.clip.enabled()
        view.text = "fiaehf iae f iug i iu uigui ui  giuguiguigu iug igioaie"
        return view
    }()
    
    func set(data: Sub) {
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blue
        self.clip.withDistribution(.row)
        self.addSubview(title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MainVC: UIViewController, MVVMView {
    private let disposeBag = DisposeBag()
    
    let viewModel = MainVCViewModel()
    
    var addButton: UIButton!
    var newSubView: NewSubView!
    var collectionView: ClipCollectionView<SubCell, SubCell, Footer>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        setUpLayout()
        
        //view model
        viewModel.cellViewModels
            .subscribe(onNext: { (subModel) in
                self.collectionView.cellData = [subModel]
            })
            .disposed(by: disposeBag)
        
        viewModel.collectionUpdate
            .subscribe(onNext: { (update) in
                self.collectionView.performBatchUpdates({
                    self.collectionView.reloadItems(at: update.reloaded.map { IndexPath.init(row: $0, section: 0)} )
                    self.collectionView.deleteItems(at: update.deleted.map { IndexPath.init(row: $0, section: 0)} )
                    self.collectionView.insertItems(at: update.inserted.map { IndexPath.init(row: $0, section: 0)} )
                })
            })
            .disposed(by: disposeBag)
        
        viewModel.collectionReloadAllItems
            .subscribe(onNext: { self.collectionView.reloadData() })
            .disposed(by: disposeBag)
        
        //interactions

        addButton.rx.tap
            .subscribe(onNext: {
                UIApplication.shared.keyWindow?.addSubview(self.newSubView)
                self.newSubView.isHidden = false
//                self.newSubView.frame = self.view.convert(self.addButton.frame, to: UIApplication.shared.keyWindow)
                let mask = CALayer()
                mask.contents = #imageLiteral(resourceName: "mask").cgImage
                let frame = self.view.convert(self.addButton.frame, to: UIApplication.shared.keyWindow)
                mask.frame = CGRect(x: frame.midX, y: frame.midY, width: 0, height: 0)
                
                self.newSubView.layer.mask = mask
                self.newSubView.frame = UIScreen.main.bounds
                
                let oldBounds = CGRect(x: 0, y: 0, width: 0, height: 0)
                let amount = max(UIScreen.main.bounds.height, UIScreen.main.bounds.width)
                let newBounds = CGRect(x: 0, y: 0, width: amount * 2.5, height: amount * 2.5)
                
                let revealAnimation = CABasicAnimation(keyPath: "bounds")
                revealAnimation.timingFunction = CAMediaTimingFunction.init(controlPoints: 0.28, 0.36, 0.8, 0.28)
                revealAnimation.fromValue = oldBounds
                revealAnimation.toValue = newBounds
                revealAnimation.duration = 0.5

                self.newSubView.layer.mask?.add(revealAnimation, forKey: "m")
                self.newSubView.layer.mask?.bounds = newBounds

            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - PRIVATE
    private func setUpViews() {
        collectionView = {
            let cv = ClipCollectionView<SubCell, SubCell, Footer>.init(collectionViewLayout: UICollectionViewFlowLayout())
            cv.alwaysBounceVertical = true
            let layout = cv.collectionViewLayout as! UICollectionViewFlowLayout
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            cv.backgroundColor = UIColor.Theme.darkBlue
            
            //templocal
            cv.headerEnabled = false
            cv.footerData = [Sub()]
            cv.maxFooterSize.width = 100
            return cv
        }()
        addButton = {
            let button = UIButton()
            button.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
            return button
        }()
        newSubView = {
            let view = NewSubView(frame: .zero)
            view.isHidden = true
            return view
        }()
    }
    
    private func setUpLayout() {
        self.view.clip.enabled()
        
        collectionView.clip.enabled().aligned(v: .stretch, h: .stretch)
        view.addSubview(collectionView)
        
        view.addSubview(addButton)
        addButton.makeConstraints(for: .bottom, .trailing) { (make) in
            if #available(iOS 11.0, *) {
                let layoutGuide = self.view.safeAreaLayoutGuide
                make.pin(to: layoutGuide.bottomAnchor, const: -25)
                make.pin(to: layoutGuide.trailingAnchor, const: -20)
            }
            else {
                make.pin(to: self.view.bottomAnchor, const: -30)
                make.pin(to: self.view.trailingAnchor, const: -20)
            }
        }
    }
}

extension MainVC {
    @objc func injected() {
        print("INJECTED")
        UIApplication.shared.keyWindow?.rootViewController = AppDelegate.makeRootVC()
    }
}
