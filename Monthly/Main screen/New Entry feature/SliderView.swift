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
import RxOptional

import VisualEffectView

protocol SliderViewModelProtocol {
    var save: AnyObserver<Sub> { get }
    var iconRequest: AnyObserver<String> { get }
    var iconImage: Driver<UIImage> { get }
}

final class SliderView: UIScrollView {
    private var disposeBag = DisposeBag()
    
    private var viewModel: SliderViewModelProtocol!
    
    private let contentView = UIView()
    
    var saveButton = SaveButton()
    
    var lineView: UIImageView!
    var iconView: UIImageView!
    var youSpendLabel: SliderLabel!
    var youSpendTextField: SliderTextField!
    var everyLabel: SliderLabel!
    var categoryPicker: CategoryPicker!
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
    
    //MARK: PRIVATE
    private func setUpBindings() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { keyboardVisibleHeight in
                self.contentInset.bottom = keyboardVisibleHeight
            })
            .disposed(by: disposeBag)
        
        nameTextField.textField.rx.text.orEmpty
            .filter { !$0.isEmpty }
            .bind(to: viewModel.iconRequest)
            .disposed(by: disposeBag)

        var old = ""
        youSpendTextField.textField.rx.text.orEmpty
            .filter { !$0.isEmpty }
            .subscribe(onNext: { new in
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
            })
            .disposed(by: disposeBag)
        
        saveButton.rx.tapGesture().when(.recognized)
            .map { _ -> Sub? in
                //todo move in VM
                let sub = Sub()
                sub.id = UUID().uuidString
                guard
                    let name = self.nameTextField.textField.text,
                    let price = Float(self.youSpendTextField.textField.text ?? "")
                    else { return nil }
                let date = DateFormatter.billDate.date(
                    from: self.firstBillTextField.textField.text ?? ""
                    ) ?? Date()
                sub.value = price
                sub.name = name
                sub.firstPayout = date
                sub.notes = self.notesTextField.textField.text
                sub.category = self.categoryPicker.selectedRow(inComponent: 0)
                sub.remind = self.remindSwitch.isOn
                if let image = self.iconView.image {
                    sub.icon = UIImagePNGRepresentation(image)
                }
                return sub
            }
            .filterNil()
            .bind(to: viewModel.save)
            .disposed(by: disposeBag)
        
        viewModel.iconImage.drive(iconView.rx.image).disposed(by: disposeBag)

    }
    
    private func setUplayout() {
        
        contentView.clip.enable().withDistribution(.column)
        self.addSubview(contentView)
        
        lineView.clip.insetTop(16).insetBottom(17)
        contentView.addSubview(lineView)
        
        let paddingsContainer = UIView()
        paddingsContainer.clip.enable().withDistribution(.column)
            .insetLeft(40).insetRight(40).insetBottom(80)
        contentView.addSubview(paddingsContainer)
        
        //main content
        let firstRow = UIView()
        firstRow.clip.enable().withDistribution(.row)
        paddingsContainer.addSubview(firstRow)
        
        firstRow.addSubview(iconView)
        iconView.clip.withHeight(45).withWidth(45)
        youSpendLabel.clip.insetRight(20).insetLeft(10).horizontallyAligned(.stretch)
        firstRow.addSubview(youSpendLabel)
        firstRow.addSubview(youSpendTextField)
        
        let secondRow = UIView()
        secondRow.clip.enable().withDistribution(.row).insetTop(20)
        paddingsContainer.addSubview(secondRow)
        
        everyLabel.clip.horizontallyAligned(.stretch)
        everyLabel.clip.insetRight(20)
        secondRow.addSubview(everyLabel)
        secondRow.addSubview(categoryPicker)
        
        let thirdRow = UIView()
        thirdRow.clip.enable().withDistribution(.row).insetTop(10)
        paddingsContainer.addSubview(thirdRow)
        
        firstBillLabel.clip.insetRight(10).horizontallyAligned(.stretch)
        thirdRow.addSubview(firstBillLabel)
        thirdRow.addSubview(firstBillTextField)
        
        nameLabel.clip.horizontallyAligned(.stretch).insetTop(30).insetBottom(10)
        paddingsContainer.addSubview(nameLabel)
        nameTextField.clip.insetLeft(-3)
        paddingsContainer.addSubview(nameTextField)
        
        notesLabel.clip.horizontallyAligned(.stretch).insetTop(30).insetBottom(10)
        paddingsContainer.addSubview(notesLabel)
        notesTextField.clip.insetLeft(-3)
        paddingsContainer.addSubview(notesTextField)
        
        let lastRow = UIView()
        lastRow.clip.enable().withDistribution(.row).insetTop(30)
        paddingsContainer.addSubview(lastRow)
        
        remindLabel.clip.horizontallyAligned(.stretch)
        lastRow.addSubview(remindLabel)
        lastRow.addSubview(remindSwitch)
    }
    
    private func setUpViews() {
        lineView = UIImageView(image: #imageLiteral(resourceName: "line"))
        lineView.clip.enable()
        
        iconView = UIImageView(image: #imageLiteral(resourceName: "signature"))
        iconView.contentMode = .scaleAspectFit
        iconView.clip.enable()
        
        youSpendLabel = {
            let view = SliderLabel()
            view.textAlignment = .right
            view.attributedText = "I spend"
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
            view.attributedText = "every"
                .localized()
                .attributedForSliderText()
            return view
        }()
        categoryPicker = CategoryPicker()
        firstBillLabel = {
            let view = SliderLabel()
            view.attributedText = "First bill"
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
            return view
        }()
        nameLabel = {
            let view = SliderLabel()
            view.attributedText = "Name"
                .localized()
                .attributedForSliderText()
            return view
        }()
        nameTextField = {
            let view = SliderTextField()
            view.textField.attributedPlaceholder = "Type company's name"
                .localized()
                .attributedForSliderPlaceholder()
            return view
        }()
        notesLabel = {
            let view = SliderLabel()
            view.attributedText = "Notes"
                .localized()
                .attributedForSliderText()
            return view
        }()
        notesTextField = SliderNotesTextField()
        remindLabel = {
            let view = SliderLabel()
            view.attributedText = "Reminder"
                .localized()
                .attributedForSliderText()
            return view
        }()
        remindSwitch = UISwitch()
        remindSwitch.clip.enable()
        remindSwitch.onTintColor = UIColor(red: 0/255, green: 161/255, blue: 213/255, alpha: 1)
        
        youSpendTextField.next(textField: firstBillTextField)
        firstBillTextField.next(textField: nameTextField)
        nameTextField.next(textField: notesTextField)
    }
    
    private func setUpSelf() {
        clipsToBounds = false
        showsVerticalScrollIndicator = false
        alwaysBounceVertical = true
        backgroundColor = .clear
        isHidden = true
        
        let screenSize = UIScreen.main.bounds.size
        let contentHeight = contentView.clip.measureSize(within: CGSize(width: screenSize.width,
                                                                        height: .greatestFiniteMagnitude)).height
        contentView.frame.size = CGSize(width: screenSize.width, height: contentHeight)
        contentInset.top = max(80, screenSize.height - contentHeight - 80)
        frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        contentSize = CGSize(width: UIScreen.main.bounds.width, height: contentHeight)
        transform = CGAffineTransform(translationX: 0, y: frame.height)
        
        let layer = CAGradientLayer.Elements.slider
        layer.cornerRadius = 35
        layer.frame.size = CGSize(width: screenSize.width, height: contentHeight + screenSize.height)
        contentView.layer.insertSublayer(layer, at: 0)
    }
}

extension SliderView: ViewModelBindable {
    func set(viewModel: SliderViewModel) {
        self.disposeBag = DisposeBag()
        self.viewModel = viewModel
        setUpBindings()
    }
}
