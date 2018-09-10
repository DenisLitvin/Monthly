//
//  SliderDateTextFieldViewModel.swift
//  Monthly
//
//  Created by Denis Litvin on 09.09.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SliderDateTextFieldViewModel {
    //MARK: INPUT
    var date: AnyObserver<Date>!
    
    //MARK: OUTPUT
    //view
    var dateString: Driver<String>!
    
    //view model
    var didChangeDate: Driver<Date>!
    
    init() {
        setUpBindings()
    }
    
    //MARK: PRIVATE
    private func setUpBindings() {
        
        let dateSubject = PublishSubject<Date>.init()
        date = dateSubject.asObserver()
        didChangeDate = dateSubject.asDriver(onErrorJustReturn: Date())
        
        dateString = dateSubject
            .map { date in
                return DateFormatter.billDate.string(from: date)
            }
            .asDriver(onErrorJustReturn: "")
    }
    
}
