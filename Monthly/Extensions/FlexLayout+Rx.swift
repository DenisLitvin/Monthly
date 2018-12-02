//
//  FlexLayout+Rx.swift
//  Monthly
//
//  Created by Denis Litvin on 12/2/18.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import FlexLayout

extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy {

    public func driveAndLayout<O: ObserverType>(_ observer: O, view: UIView, superview: UIView) -> Disposable where O.E == E {
        view.flex.markDirty()
        defer { superview.flex.layout() }
        return drive(observer)
    }

    public func driveAndLayout<O: ObserverType>(_ observer: O, view: UIView, superview: UIView) -> Disposable where O.E == E? {
        view.flex.markDirty()
        defer { superview.flex.layout() }
        return drive(observer)
    }
}
