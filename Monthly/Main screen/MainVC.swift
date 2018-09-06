//
//  ViewController.swift
//  Monthly
//
//  Created by Denis Litvin on 10.08.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

import ClipLayout
import Pinner

import VisualEffectView

class SaveButton: TwoStatedButton {
    
    var titleView: UIView!
    
    override init() {
        super.init()
        
        let diameter: CGFloat = 45
        isHidden = true
        frame = CGRect(x: 0, y: 0, width: 160, height: diameter + 9)
//        clipsToBounds = true
//        layer.cornerRadius = 23
        let backgroundLayer = CALayer()
        backgroundLayer.contents = #imageLiteral(resourceName: "save_rect").cgImage
        backgroundLayer.frame.size = frame.size
        layer.addSublayer(backgroundLayer)
        
        let maskLayer = CALayer()
        maskLayer.contents = #imageLiteral(resourceName: "mask").cgImage
        maskLayer.frame = CGRect(x: (frame.width - diameter + 1.5) / 2, y: 5, width: diameter, height: diameter)
        self.layer.mask = maskLayer
        
        titleView = {
           let view = UILabel()
            view.isUserInteractionEnabled = false
            view.textAlignment = .center
            view.textColor = .white
            view.attributedText = NSAttributedString(string: "SAVE".localized(), attributes: [.kern: 4])
            view.font = UIFont.dynamic(14, family: .proximaNova).bolded
            return view
        }()
        
        addSubview(titleView)
        titleView.fillSuperview()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MainVC: UIViewController, MVVMView {
    private let disposeBag = DisposeBag()
    
    let viewModel = MainVCViewModel()
    
    var saveButton = SaveButton()
    var blurView = VisualEffectView(frame: UIScreen.main.bounds)
    var tabBarView = TabBarView()
    var sliderView = SliderView()
    var collectionView: ClipCollectionView<SubCell, SubCell, SubCell>!
    
    override func viewDidAppear(_ animated: Bool) {
        let window = UIApplication.shared.keyWindow
        
        window?.addSubview(blurView)
        blurView.isHidden = true
        window?.addSubview(sliderView)
        window?.addSubview(tabBarView)
        
        let frame = tabBarView.convert(tabBarView.plusButton.frame, to: window)
        let x = (UIScreen.main.bounds.width - saveButton.frame.width) / 2
        var y = frame.origin.y + 3.5
        if #available(iOS 11.0, *),
            self.view.safeAreaInsets.bottom > 0 {
            y += 9
        }
        saveButton.frame = CGRect(x: x, y: y, width: saveButton.frame.width, height: saveButton.frame.height)
        window?.addSubview(saveButton)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            Animator.presentCells(self.collectionView.visibleCells)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViews()
        setUpLayout()
    }
    
    func didSetDependencies() {
        setUpBindings()
    }
    
    //MARK: - PRIVATE
    private func setUpBindings() {
        
        //INPUT
        viewModel.cellViewModels
            .drive(onNext: { (subModel) in
                self.collectionView.cellData = [subModel]
            })
            .disposed(by: disposeBag)
        
        viewModel.collectionUpdateItems
            .drive(onNext: { (change) in
                self.collectionView.performBatchUpdates({
                    self.collectionView.reloadItems(at: change.updated)
                    self.collectionView.deleteItems(at: change.deleted)
                    self.collectionView.insertItems(at: change.inserted)
                })
            })
            .disposed(by: disposeBag)
        
        viewModel.collectionReloadAllItems
            .drive(onNext: {
                self.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        //VIEWS
        
        let present: () -> Void = {
            Animator.showSave(button: self.saveButton)
            Animator.hideTabBar(view: self.tabBarView)
            Animator.showBlur(view: self.blurView)
            Animator.slideUp(view: self.sliderView)
        }
        
        let hide: () -> Void = {
            Animator.hideSave(button: self.saveButton)
            Animator.showTabBar(view: self.tabBarView)
            Animator.hideBlur(view: self.blurView)
            Animator.slideDown(view: self.sliderView)
        }
        
        tabBarView.plusButton.isOn.asObservable()
            .subscribe(onNext: { isOn in
                if isOn {
                    present()
                }
                else {
                    hide()
                }
            })
            .disposed(by: disposeBag)
        
        saveButton.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                self.tabBarView.plusButton.isOn.onNext(false)
            })
            .disposed(by: disposeBag)

        
        
        sliderView.rx.panGesture()
            .when(.changed)
            .subscribe(onNext: { gr in
                let deltaY = gr.translation(in: self.sliderView.superview!).y
                self.sliderView.transform = CGAffineTransform(translationX: 0, y: deltaY)
            })
            .disposed(by: disposeBag)
        
        sliderView.rx.panGesture()
            .when(.ended)
            .subscribe(onNext: { gr in
                let deltaY = gr.translation(in: self.sliderView.superview!).y
                if deltaY > 70 {
                    self.tabBarView.plusButton.isOn.onNext(false)
                }
                else {
                    self.tabBarView.plusButton.isOn.onNext(true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setUpLayout() {
        self.view.clip.enabled()
        
        collectionView.clip.enabled().aligned(v: .stretch, h: .stretch)
        view.addSubview(collectionView)
    }
    
    private func setUpViews() {
        collectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            
            let cv = ClipCollectionView<SubCell, SubCell, SubCell>.init(collectionViewLayout: layout)
            cv.alwaysBounceVertical = true
            cv.contentInset.bottom = tabBarView.bounds.height + 6
            cv.backgroundColor = UIColor.Elements.background
            cv.headerEnabled = false
            cv.footerEnabled = false
            return cv
        }()
    }
}

extension MainVC {
    @objc func injected() {
        print("INJECTED")
        let vc = AppDelegate.makeRootVC()

        UIApplication.shared.keyWindow?.rootViewController = vc
    }
}
