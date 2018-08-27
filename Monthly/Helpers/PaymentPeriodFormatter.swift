//
//  PaymentPeriodFormatter.swift
//  Monthly
//
//  Created by Denis Litvin on 26.08.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import Foundation

class PaymentPeriodFormatter {
    
    static func string(from days: Int) -> String {
        var string = ""
        if days < 1 {
            string = "today"
        }
        else if days < 7 {
            let mult = days > 1 ? "s" : ""
            string = "in \(days) day\(mult)"
        }
        else if days < 30 {
            let weeks = days / 7
            let mult = weeks > 1 ? "s" : ""
            string = "in \(weeks) week\(mult)"
        }
        else if days < 365 {
            let months = days / 30
            let mult = months > 1 ? "s" : ""
            string = "in \(months) month\(mult)"
        }
        else {
            let years = days / 365
            let mult = years > 1 ? "s" : ""
            string =  "in \(years) year\(mult)"
        }
        return string
    }
}
