//
//  TabBarViewModel.swift
//  Monthly
//
//  Created by Denis Litvin on 31.08.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum SortType {
    case alphabetical(SortOrder)
    case value(SortOrder)
    case none
}

enum SortOrder {
    case ascending
    case descending
}

class TabBarViewModel {    
    var performSearch = PublishSubject<String>()
    var performSort = PublishSubject<SortType>()
}
