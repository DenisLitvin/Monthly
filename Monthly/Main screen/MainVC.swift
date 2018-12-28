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

extension MainVC: MVVMView {
    func didSetDependencies() {
        disposeBag = DisposeBag()
        sliderView.set(viewModel: viewModel.sliderViewModel)
        tabBarView.set(viewModel: viewModel.tabBarViewModel)
        statSliderView.set(viewModel: viewModel.statSliderViewViewModel)
        setUpBindings()
    }
}

final class MainVC: UIViewController {
    var disposeBag = DisposeBag()
    
    let viewModel = MainVCViewModel()
    
    let blurView: VisualEffectView
    let tabBarView: TabBarView
    let sliderView: SliderView
    let statSliderView: StatSliderView
    var collectionView: CollectionView<SubCell, SubCell, SubCell>!
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            Animator.presentCells(self.collectionView.visibleCells)
        })
    }
    
    init(with tabBarView: TabBarView,
         sliderView: SliderView,
         blurView: VisualEffectView,
         statSliderView: StatSliderView) {
        
        self.tabBarView = tabBarView
        self.sliderView = sliderView
        self.blurView = blurView
        self.statSliderView = statSliderView
        
        super.init(nibName: nil, bundle: nil)
        
        setUpSelf()
        setUpViews()
        setUpLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - PRIVATE
    private func setUpBindings() {
        
        //VIEW MODEL
        viewModel.cellViewModels
            .drive(onNext: { (subModel) in
                self.collectionView.cellData = [subModel]
            })
            .disposed(by: disposeBag)
        
        //        viewModel.updateCollectionViewItems
        //            .drive(onNext: { (change) in
        //                self.collectionView.performBatchUpdates({
        //                    self.collectionView.reloadItems(at: change.updated)
        //                    self.collectionView.deleteItems(at: change.deleted)
        //                    self.collectionView.insertItems(at: change.inserted)
        //                })
        //            })
        //            .disposed(by: disposeBag)
        
        viewModel.reloadAllItems
            .drive(onNext: {
                self.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        //VIEWS
        let present: () -> Void = {
            self.tabBarView.searchButton.isOn.onNext(false)
            self.tabBarView.statButton.isOn.onNext(false)
            self.tabBarView.sortButton.isOn.onNext(false)
            self.tabBarView.menuButton.isOn.onNext(false)
            Animator.showSave(button: self.sliderView.saveButton)
            Animator.hideTabBar(view: self.tabBarView)
            Animator.showBlur(view: self.blurView)
            Animator.slideUp(view: self.sliderView)
        }
        
        let hide: () -> Void = {
            Animator.hideSave(button: self.sliderView.saveButton)
            Animator.showTabBar(view: self.tabBarView)
            Animator.hideBlur(view: self.blurView)
            Animator.slideDown(view: self.sliderView)
        }
        
        tabBarView.statButton.isOn
            .skip(1)
            .subscribe(onNext: { isOn in
                if isOn {
                    Animator.slideUp(view: self.statSliderView)
                    Animator.showBlur(view: self.blurView)
                }
                else {
                    Animator.slideDown(view: self.statSliderView)
                    Animator.hideBlur(view: self.blurView)
                }
            })
            .disposed(by: disposeBag)
        
        statSliderView.rx.didEndDragging
            .subscribe(onNext: { _ in
                if self.statSliderView.contentOffset.y < -self.statSliderView.contentInset.top - 10 {
                    self.tabBarView.statButton.isOn.asObserver().onNext(false)
                }
            })
            .disposed(by: disposeBag)
        
        
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
        
        sliderView.saveButton.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                self.tabBarView.plusButton.isOn.onNext(false)
            })
            .disposed(by: disposeBag)

        sliderView.rx.didEndDragging
            .subscribe(onNext: { _ in
                if self.sliderView.contentOffset.y < -self.sliderView.contentInset.top - 10 {
                    self.tabBarView.plusButton.isOn.onNext(false)
                }
            })
            .disposed(by: disposeBag)

    }
    
    private func setUpLayout() {
        self.view.clip.enable()
        
        collectionView.clip.enable().aligned(v: .stretch, h: .stretch)
        view.addSubview(collectionView)
    }
    
    private func setUpViews() {
        collectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            
            let cv = CollectionView<SubCell, SubCell, SubCell>.init(collectionViewLayout: UICollectionViewFlowLayout())
            cv.alwaysBounceVertical = true
            cv.contentInset.bottom = tabBarView.bounds.height + 6
            cv.backgroundColor = UIColor.Elements.background
            return cv
        }()
    }
    
    private func setUpSelf() {
        view.backgroundColor = UIColor.Elements.background
        //title
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        titleLabel.font = UIFont.fixed(13, family: .avenirNext).bolded
        titleLabel.textColor = .black
        let str = "MONTHLY".localized()
        titleLabel.attributedText = NSAttributedString(string: str, attributes: [.kern: 3.15])
        navigationItem.titleView = titleLabel
    }
}
