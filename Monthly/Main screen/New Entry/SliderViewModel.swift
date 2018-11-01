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

class SliderViewModel {
    
    var save = PublishRelay<Sub>()
    var iconRequest = PublishRelay<String>()
    var iconImage: Driver<UIImage>!
}
