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

class SliderViewViewModel {
    
    var dateTextFieldViewModel = SliderDateTextFieldViewModel()

    //MARK: INPUT

    //MARK: OUTPUT
    //view
    
    //view model
    var didChangeDate: Driver<Date>!
    
    init() {
        didChangeDate = dateTextFieldViewModel.didChangeDate
    }
}
