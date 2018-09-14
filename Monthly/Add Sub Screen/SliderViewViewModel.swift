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

struct NotEnoughInfoError: Error {
    
}

class SliderViewViewModel {
    var disposeBag = DisposeBag()
    
    //MARK: INPUT
    //    var imageData: AnyObserver<Data>!
    var save: AnyObserver<Sub>!
    
    //MARK: OUTPUT
    //view model
    var didTryToSave: Observable<Sub>!
//    var didRequestedImagePicker: Driver<Void>!
    
    init() {
       let didTryToSave = PublishSubject<Sub>()
        self.didTryToSave = didTryToSave.asObservable()
        self.save = didTryToSave.asObserver()
    }
}
