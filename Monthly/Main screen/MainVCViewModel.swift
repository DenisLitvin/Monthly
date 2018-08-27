//
//  MainVCViewModel.swift
//  Monthly
//
//  Created by Denis Litvin on 10.08.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import Foundation
import RxSwift

class MainVCViewModel {
    struct Update {
        let deleted: [Int]
        let inserted: [Int]
        let reloaded: [Int]
    }

    private let disposeBag = DisposeBag()
    var databaseManager: DatabaseManager!

    var cellViewModels = BehaviorSubject<[SubCellViewModel]>.init(value: [])
    var collectionUpdate = PublishSubject<Update>()
    var collectionReloadAllItems = PublishSubject<Void>()
    
    init() {

    }
}

extension MainVCViewModel: Routable {
    
    func didSetDependencies() {
        databaseManager
            .getSubChanges()
            .subscribe(onNext: { (results, changes) in
                if let changes = changes {
                    // it's an update
                    print(results)
                    print("deleted: \(changes.deleted)")
                    print("inserted: \(changes.inserted)")
                    print("updated: \(changes.updated)")

                    self.cellViewModels.onNext(results.map({
                        let cellvm = SubCellViewModel()
                        cellvm.model.onNext($0)
                        return cellvm
                    }))
                    self.collectionUpdate.onNext(Update(deleted: changes.deleted, inserted: changes.inserted, reloaded: changes.updated))
                    
                } else {
                    // it's the initial data
//                    print(results)
                    var cellVMs = [SubCellViewModel]()
                    results.forEach { (sub) in
                        let cellVM = SubCellViewModel.init()
                        cellVM.model.onNext(sub)
                        cellVMs.append(cellVM)
                    }
                    self.cellViewModels.onNext(cellVMs)
                    self.collectionReloadAllItems.onNext(())
                }
            })
        .disposed(by: disposeBag)
    }
    
    var input: [Input] {
        return [
         Route.subManager.input({ self.databaseManager = $0 })
        ]
    }
    var output: [Output] {
        return [
        
        ]
    }
}
