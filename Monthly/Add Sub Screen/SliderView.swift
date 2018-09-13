//
//  NewSubView.swift
//  Monthly
//
//  Created by Denis Litvin on 26.08.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture
import RxKeyboard

import VisualEffectView

class SliderView: UIScrollView {
    private var disposeBag = DisposeBag()
    
    private var viewModel: SliderViewViewModel!
    
    private let contentView = UIView()
    
    var lineView: UIImageView!
    var iconView: UIImageView!
    var youSpendLabel: SliderLabel!
    var youSpendTextField: SliderTextField!
    var everyLabel: SliderLabel!
    var everyCategoryPicker: CategoryPicker!
    var firstBillLabel: SliderLabel!
    var firstBillTextField: SliderDateTextField!
    var nameLabel: SliderLabel!
    var nameTextField: SliderTextField!
    var notesLabel: SliderLabel!
    var notesTextField: SliderTextField!
    var remindLabel: SliderLabel!
    var remindSwitch: UISwitch!

    init() {
        super.init(frame: .zero)
        setUpViews()
        setUplayout()
        setUpSelf()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        Animator.stopAllAnimations(view: self)
        super.touchesBegan(touches, with: event)
    }
    
    //MARK: - PRIVATE
    
    private func setUpBindings() {
        var old = ""
        youSpendTextField.textField.rx.text.orEmpty
            .subscribe(onNext: { new in
                if !new.isEmpty {
                    var string = new.trimmingCharacters(in: .whitespacesAndNewlines)
                    if string.starts(with: "0") {
                        string.remove(at: string.startIndex)
                    }
                    let number = NumberFormatter.price.number(from: string)
                    if number == nil {
                        string = old
                    }
                    else {
                        old = string
                    }
                    self.youSpendTextField.textField.text = string
                }
            })
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { keyboardVisibleHeight in
                self.contentInset.bottom = keyboardVisibleHeight
            })
            .disposed(by: disposeBag)
//        
//        RxKeyboard.instance.visibleHeight
//            .drive(onNext: { keyboardVisibleHeight in
//                self.contentOffset.y += keyboardVisibleHeight
//            })
//            .disposed(by: disposeBag)
    }
    
    private func setUplayout() {
        
        contentView.clip.enabled().withDistribution(.column)
        self.addSubview(contentView)
        
        lineView.clip.insetTop(16).insetBottom(17)
        contentView.addSubview(lineView)
        
        let paddingsContainer = UIView()
        paddingsContainer.clip.enabled().withDistribution(.column)
            .insetLeft(50).insetRight(50).insetBottom(80)
        contentView.addSubview(paddingsContainer)
        
        //main content
        let firstRow = UIView()
        firstRow.clip.enabled().withDistribution(.row)
        paddingsContainer.addSubview(firstRow)
        
        firstRow.addSubview(iconView)
        youSpendLabel.clip.insetRight(10).insetLeft(10).horizontallyAligned(.stretch)
        firstRow.addSubview(youSpendLabel)
        firstRow.addSubview(youSpendTextField)
        
        let secondRow = UIView()
        secondRow.clip.enabled().withDistribution(.row).insetTop(10)
        paddingsContainer.addSubview(secondRow)
        
        everyLabel.clip.horizontallyAligned(.stretch)
        secondRow.addSubview(everyLabel)
        secondRow.addSubview(everyCategoryPicker)
        
        let thirdRow = UIView()
        thirdRow.clip.enabled().withDistribution(.row).insetTop(10)
        paddingsContainer.addSubview(thirdRow)
        
        firstBillLabel.clip.insetRight(10).horizontallyAligned(.stretch)
        thirdRow.addSubview(firstBillLabel)
        thirdRow.addSubview(firstBillTextField)
        
        nameLabel.clip.horizontallyAligned(.stretch).insetTop(25).insetBottom(10)
        paddingsContainer.addSubview(nameLabel)
        nameTextField.clip.insetLeft(-3)
        paddingsContainer.addSubview(nameTextField)
        
        notesLabel.clip.horizontallyAligned(.stretch).insetTop(19).insetBottom(10)
        paddingsContainer.addSubview(notesLabel)
        notesTextField.clip.insetLeft(-3)
        paddingsContainer.addSubview(notesTextField)
    }
    
    private func setUpViews() {
        lineView = UIImageView(image: #imageLiteral(resourceName: "line"))
        lineView.clip.enabled()
        
        iconView = UIImageView(image: #imageLiteral(resourceName: "icon_holder"))
        iconView.clip.enabled()
        
        youSpendLabel = {
            let view = SliderLabel()
            view.textAlignment = .right
            view.attributedText = "YOU SPEND"
                .localized()
                .attributedForSliderText()
            return view
        }()
        youSpendTextField = {
            let view = SliderTextField()
            view.textField.keyboardType = UIKeyboardType.decimalPad
            view.textField.textAlignment = .right
            view.textField.attributedPlaceholder = NumberFormatter.priceWithCurrencyMark
                .string(from: NSNumber(value: 0))!
                .attributedForSliderPlaceholder()
            view.layer.cornerRadius = 11
            view.clip.withWidth(90)
            return view
        }()
        everyLabel = {
            let view = SliderLabel()
            view.textAlignment = .right
            view.attributedText = "EVERY"
                .localized()
                .attributedForSliderText()
            return view
        }()
        everyCategoryPicker = CategoryPicker()
        firstBillLabel = {
            let view = SliderLabel()
            view.attributedText = "FIRST BILL WAS"
                .localized()
                .attributedForSliderText()
            return view
        }()
        firstBillTextField = {
            let view = SliderDateTextField()
            view.textField.attributedPlaceholder = DateFormatter.billDate
                .string(from: Date())
                .attributedForSliderPlaceholder()
            view.textField.textAlignment = .center
            view.clip.withWidth(105)
            return view
        }()
        nameLabel = {
            let view = SliderLabel()
            view.attributedText = "NAME"
                .localized()
                .attributedForSliderText()
            return view
        }()
        nameTextField = {
            let view = SliderTextField()
            view.textField.attributedPlaceholder = "Enter company name …"
                .localized()
                .attributedForSliderPlaceholder()
            return view
        }()
        notesLabel = {
            let view = SliderLabel()
            view.attributedText = "NOTES"
                .localized()
                .attributedForSliderText()
            return view
        }()
        notesTextField = SliderNotesTextField()
        remindLabel = {
            let view = SliderLabel()
            view.attributedText = "REMIND ME"
                .localized()
                .attributedForSliderText()
            return view
        }()
        
        youSpendTextField.next(textField: firstBillTextField)
        firstBillTextField.next(textField: nameTextField)
        nameTextField.next(textField: notesTextField)
    }
    
    private func setUpSelf() {
        clipsToBounds = false
        alwaysBounceVertical = true
        backgroundColor = .clear
        isHidden = true
        
        let screenSize = UIScreen.main.bounds.size
        let contentHeight = contentView.clip.measureSize(within: CGSize(width: screenSize.width,
                                                                        height: .greatestFiniteMagnitude)).height
        contentView.frame.size = CGSize(width: screenSize.width, height: contentHeight)
        var maxFrameHeight = screenSize.height - 70
        if #available(iOS 11.0, *) {
            maxFrameHeight -= safeAreaInsets.top
        }
        let height = min(maxFrameHeight, contentHeight)
        frame = CGRect(x: 0, y: screenSize.height - height, width: screenSize.width, height: height)
        contentSize = CGSize(width: UIScreen.main.bounds.width, height: contentHeight)
        transform = CGAffineTransform(translationX: 0, y: frame.height)

        let layer = CAGradientLayer.Elements.slider
        layer.cornerRadius = 35
        layer.frame.size = CGSize(width: screenSize.width, height: contentHeight + screenSize.height)
        contentView.layer.insertSublayer(layer, at: 0)
    }
}

extension SliderView: MVVMBinder {
    func set(viewModel: SliderViewViewModel) {
        self.disposeBag = DisposeBag()
        self.viewModel = viewModel
        self.firstBillTextField.set(viewModel: viewModel.dateTextFieldViewModel)
        setUpBindings()
    }
}
