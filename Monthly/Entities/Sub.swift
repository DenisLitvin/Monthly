//
//  Sub.swift
//  Monthly
//
//  Created by Denis Litvin on 10.08.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
class Sub: Object {
    
    enum Category: String {
        case daily
        case weekly
        case monthly
        case yearly
        
        static func get(index: Int) -> Category? {
            switch index {
            case 0: return Category.daily
            case 1: return Category.weekly
            case 2: return Category.monthly
            case 3: return Category.yearly
            default: return nil
            }
        }
        
        var calendarComponent: Calendar.Component {
            switch self {
            case .daily: return Calendar.Component.day
            case .weekly: return Calendar.Component.weekOfYear
            case .monthly: return Calendar.Component.month
            case .yearly: return Calendar.Component.year
            }
        }
    }
    
    dynamic var id = ""
    dynamic var name = ""
    dynamic var firstPayout = Date()
    dynamic var category = 0
    dynamic var value: Float = 0.0
    dynamic var remind = false
    dynamic var icon: Data? = nil
    dynamic var notes: String? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

