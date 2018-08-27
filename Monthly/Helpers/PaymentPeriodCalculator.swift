//
//  DatePeriodFormatter.swift
//  Monthly
//
//  Created by Denis Litvin on 26.08.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import Foundation

class PaymentPeriodCalculator {
    
    static func daysUntilNextPayment(firstPayment date: Date, category: Sub.Category) -> Int {
        let futureDate = Calendar.current.date(
            byAdding: PaymentPeriodCalculator.componentsFromFirstToNextPayment(for: category, firstPayment: date),
            to: date
        )
        let duration = DateInterval(start: Date(), end: futureDate!).duration
        return Int(duration / (3600 * 24))
    }
    
    private static func componentsFromFirstToNextPayment(for category: Sub.Category, firstPayment date: Date) -> DateComponents {
        var components: DateComponents
        switch category {
        case .daily: components = daysFromFirstToNextPayment(from: date)
        case .weekly: components = weeksFromFirstToNextPayment(from: date)
        case .monthly: components = monthsFromFirstToNextPayment(from: date)
        case .yearly: components = yearsFromFirstToNextPayment(from: date)
        }
        return components
    }
    
    private static func monthsFromFirstToNextPayment(from: Date) -> DateComponents {
        var componentsPassed = Calendar.current.dateComponents([.month], from: from, to: Date())
        componentsPassed.month = (componentsPassed.month ?? 0) + 1
        return componentsPassed
    }
    
    private static func yearsFromFirstToNextPayment(from: Date) -> DateComponents {
        var componentsPassed = Calendar.current.dateComponents([.year], from: from, to: Date())
        componentsPassed.year = (componentsPassed.year ?? 0) + 1
        return componentsPassed
    }
    
    private static func weeksFromFirstToNextPayment(from: Date) -> DateComponents {
        var componentsPassed = Calendar.current.dateComponents([.weekOfYear], from: from, to: Date())
        componentsPassed.weekOfYear = (componentsPassed.weekOfYear ?? 0) + 1
        return componentsPassed
    }
    
    private static func daysFromFirstToNextPayment(from: Date) -> DateComponents {
        var componentsPassed = Calendar.current.dateComponents([.day], from: from, to: Date())
        componentsPassed.day = (componentsPassed.day ?? 0) + 1
        return componentsPassed
    }
}
