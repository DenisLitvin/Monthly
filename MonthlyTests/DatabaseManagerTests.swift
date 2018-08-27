//
//  SubManagerTests.swift
//  MonthlyTests
//
//  Created by Denis Litvin on 11.08.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import Foundation
import XCTest
import RealmSwift

@testable import Monthly

class SubManagerTests: XCTestCase {
    
    var manager: DatabaseManager!
    var realm: Realm!
    
    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        realm = try! Realm()
        manager = DatabaseManager(database: realm)
    }
    
    override func tearDown() {
        super.tearDown()
        manager = nil
    }
    
    func test_persists_sub_when_adds() {
        let a = Sub()
        manager.add(a)
        XCTAssertNotNil(realm.objects(Sub.self).first)
    }
    
    func test_changes_entry_when_modifies() {
        let a = Sub()
        try! realm.write {
            realm.add(a)
        }
        manager.modify(a) { (a) in
            a.name = "name"
        }
        XCTAssertEqual(a.name, "name")
    }
}
