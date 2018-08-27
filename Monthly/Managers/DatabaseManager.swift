
//
//  File.swift
//  Monthly
//
//  Created by Denis Litvin on 11.08.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxRealm

class DatabaseManager {
    
    enum EmptyResult {
        case success
        case failure(Error)
    }
    
    enum Result<Item> {
        case success(Item)
        case failure(Error)
    }
    
    private let database: Realm
    
    init(database: Realm) {
        self.database = database
    }
    
    //MARK: - PUBLIC
    @discardableResult
    func modify<Entry: Object>(_ entry: Entry, closure: (Entry) -> Void) -> EmptyResult {
        do {
            try database.write {
               closure(entry)
            }
            return .success
        }
        catch {
            return .failure(error)
        }
    }
    
    @discardableResult
    func add<Entry: Object>(_ entry: Entry) -> EmptyResult {
        do {
            try database.write {
                database.add(entry)
            }
            return .success
        }
        catch {
            return .failure(error)
        }
    }
    
//    func getAllSubs(filter: String? = nil) -> Single<Result<[Sub]>> {
//        return Single<Result<[Sub]>>.create() { single in
//            self.database.objects(Sub.self).filter("")
//            Observable.coll
//            return Disposables.create()
//        }
//    }
    
    func getSubChanges(filter: String? = nil) -> Observable<(AnyRealmCollection<Sub>, RealmChangeset?)> {
        let objects = database.objects(Sub.self)
        return Observable.changeset(from: objects, synchronousStart: false)
    }
}
