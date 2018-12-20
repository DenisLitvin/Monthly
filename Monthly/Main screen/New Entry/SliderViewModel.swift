//
//  File.swift
//  Monthly
//
//  Created by Denis Litvin on 09.09.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class SliderViewModel: SliderViewModelProtocol {
    
    var saveSubject = PublishSubject<Sub>()
    var iconRequestSubject = PublishSubject<String>()
    var iconImageSubject = PublishSubject<UIImage>()

    //SliderViewModelProtocol
    lazy var save: AnyObserver<Sub> = {
        return saveSubject.asObserver()
    }()
    
    lazy var iconImage: Driver<UIImage> = {
        return iconImageSubject.asDriver(onErrorJustReturn: .signature)
    }()
    lazy var iconRequest: AnyObserver<String> = {
        return iconRequestSubject.asObserver()
    }()
    
    
}
