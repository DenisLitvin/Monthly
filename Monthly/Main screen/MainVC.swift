//
//  ViewController.swift
//  Monthly
//
//  Created by Denis Litvin on 10.08.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import UIKit
import MobileCoreServices

import RxSwift
import RxCocoa

import ClipLayout
import Pinner

import VisualEffectView

class MainVC: UIViewController {
    var disposeBag = DisposeBag()
    
    let viewModel = MainVCViewModel()
    
    var blurView: VisualEffectView!
    var tabBarView: TabBarView!
    var sliderView: SliderView!
    var collectionView: CollectionView<SubCell, SubCell, SubCell>!
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            Animator.presentCells(self.collectionView.visibleCells)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setUpSelf()
//        setUpViews()
//        setUpLayout()
    }
    init(with tabBarView: TabBarView,
         sliderView: SliderView,
         blurView: VisualEffectView) {
        super.init(nibName: nil, bundle: nil)
        
        self.tabBarView = tabBarView
        self.sliderView = sliderView
        self.blurView = blurView
        
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
        
        viewModel.updateCollectionViewItems
            .drive(onNext: { (change) in
                self.collectionView.performBatchUpdates({
                    self.collectionView.reloadItems(at: change.updated)
                    self.collectionView.deleteItems(at: change.deleted)
                    self.collectionView.insertItems(at: change.inserted)
                })
            })
            .disposed(by: disposeBag)

        viewModel.reloadAllItems
            .drive(onNext: {
                    self.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
//        viewModel.didRequestImagePicker
//            .drive(onNext: { _ in
//                let picker = UIImagePickerController()
//                picker.delegate = self
//                picker.mediaTypes = [kUTTypeImage as String]
//                self.present(picker, animated: true)
//            })
//            .disposed(by: disposeBag)
        
        
        //VIEWS
        let present: () -> Void = {
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
        titleLabel.font = UIFont.fixed(13, family: .proximaNova).bolded
        titleLabel.textColor = .white
        let str = "MONTHLY".localized()
        titleLabel.attributedText = NSAttributedString(string: str, attributes: [.kern: 3.15])
        navigationItem.titleView = titleLabel
    }
}

//extension MainVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        picker.dismiss(animated: true)
//        let image = info[UIImagePickerControllerEditedImage] ??
//            info[UIImagePickerControllerOriginalImage] ??
//            info[UIImagePickerControllerCropRect] ?? UIImage()
//        viewModel.imageData = UIImagePNGRepresentation(image)
//    }
//
//}

extension MainVC: MVVMView {
    func didSetDependencies() {
        disposeBag = DisposeBag()
        sliderView.set(viewModel: viewModel.sliderViewModel)
        tabBarView.set(viewModel: viewModel.tabBarViewModel)
        setUpBindings()
    }
}
