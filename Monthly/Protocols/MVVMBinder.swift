//
//  MVVMBinder.swift
//  Monthly
//
//  Created by Denis Litvin on 09.09.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import Foundation
import ClipLayout

protocol MVVMBinder: DataBinder {
    associatedtype ViewModel
    func set(viewModel: ViewModel)
}

extension MVVMBinder {
    func set(data: ViewModel) {
        set(viewModel: data)
    }
}
