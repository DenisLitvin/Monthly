
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

    struct Error {
        static let write = NSError(domain: "DatabaseManager", code: 0, userInfo: nil)
    }
    
    enum EmptyResult {
        case success
        case error(NSError)
    }
    
    enum Result<Item> {
        case success(Item)
        case error(NSError)
    }
    
    private let mainDatabaseRef: Realm
    private let backgroundQueue = DispatchQueue(label: "databaseBackgroundQueue", qos: .background)
    private let config: Realm.Configuration
    
    init(with configuration: Realm.Configuration = Realm.Configuration.defaultConfiguration) {
        self.config = configuration
        self.mainDatabaseRef = try! Realm(configuration: configuration)
    }
    
    //MARK: - PUBLIC
    @discardableResult
    func modify<Entry: Object>(_ entry: Entry, closure: @escaping (Entry) -> Void) -> Single<Void> {
        return Single.create(subscribe: { (single) -> Disposable in
            self.backgroundQueue.async {
                do {
                    try Realm.init(configuration: self.config).write {
                        closure(entry)
                    }
                    single(.success(()))
                }
                catch { single(.error(Error.write)) }
            }
            return Disposables.create()
        })
    }

        func add<Entry: Object>(_ entry: Entry) -> Single<Void> {
            return Single.create(subscribe: { (single) -> Disposable in
                self.backgroundQueue.async {
                    do {
                        let realm = try Realm.init(configuration: self.config)
                        try realm.write {
                            realm.add(entry)
                        }
                        single(.success(()))
                    }
                    catch { single(.error(Error.write)) }
                }
                return Disposables.create()
            })
    }

    
//    func add<Entry: Object>(_ entry: Entry, completion: @escaping (EmptyResult) -> Void) {
//        self.backgroundQueue.async {
//            do {
//                let realm = try  Realm.init(configuration: self.config)
//                try realm.write {
//                    realm.add(entry)
//                }
//            }
//            catch {
//                DispatchQueue.main.async { completion(.error(Error.write)) }
//            }
//            DispatchQueue.main.async { completion(.success) }
//        }
//
//    }
    
    
//    func getAllSubs(filter: String? = nil) -> Single<Result<[Sub]>> {
//        return Single<Result<[Sub]>>.create() { single in
//            self.database.objects(Sub.self).filter("")
//            Observable.coll
//            return Disposables.create()
//        }
//    }
    
    func getAllEntries() -> Observable<(AnyRealmCollection<Sub>, RealmChangeset?)> {
        let objects = mainDatabaseRef.objects(Sub.self)
        return Observable.changeset(from: objects)
    }
    
    func getFilteredEntriesByName(_ name: String) -> Observable<Results<Sub>> {
        let objects = mainDatabaseRef.objects(Sub.self).filter("name = %@", name)
        return Observable.collection(from: objects)
    }
}

