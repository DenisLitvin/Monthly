//
//  MainVCViewModel.swift
//  Monthly
//
//  Created by Denis Litvin on 10.08.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import Foundation

import RxRealm
import RealmSwift
import Moya

import RxCocoa
import RxSwift

class MainVCViewModel {
    
    struct Changeset {
        let deleted: [IndexPath]
        let inserted: [IndexPath]
        let updated: [IndexPath]
    }
    
    private let disposeBag = DisposeBag()
    
    var databaseManager: DatabaseManager!
    var networkManager: MoyaProvider<General>!
    
    var sliderViewModel = SliderViewModel()
    var tabBarViewModel = TabBarViewModel()
    
    //MARK: - OUTPUT
    //views
    var cellViewModels: Driver<[SubCellViewModel]>!
    var updateCollectionViewItems: Driver<MainVCViewModel.Changeset>!
    var reloadAllItems: Driver<Void>!
    
    
    //MARK: - PRIVATE
    private func setUpBindings() {
        sliderViewModel.iconImage =
            sliderViewModel.iconRequest.asObservable()
                .flatMapLatest { self.networkManager.rx.request(.image($0)).mapImage().catchErrorJustReturn(UIImage(named: "signature")) }
                .filter { $0 != nil }
                .map { $0! }
                .asDriver(onErrorJustReturn: UIImage(named: "signature")!)
        
        sliderViewModel.save.asObservable()
            .flatMap { self.databaseManager.add($0) }
            .subscribe(onNext: {
                print("save is successful")
            })
            .disposed(by: disposeBag)
        
        
        let queryObs = Observable.combineLatest(
            tabBarViewModel.performSort.asObservable().startWith(.none),
            tabBarViewModel.performSearch.asObservable().startWith("").distinctUntilChanged()
            )
        
        let emptySearch = queryObs
            .filter { $0.1.isEmpty }
            .flatMapLatest { self.databaseManager.getAllEntries(sort: $0.0).share() }
        
        
        let nonEmptySearch = queryObs
            .filter { !$0.1.isEmpty }
            .flatMapLatest { self.databaseManager.getFilteredEntriesByName($0.1, sort: $0.0).share() }
        
//        updateCollectionViewItems = emptySearch
//            .map {(results, changeset) in changeset }
//            .filter { $0 != nil }
//            .map { (result: RealmChangeset?) -> Changeset in
//                let result = result!
//                let deleted = result.deleted.map { IndexPath(item: $0, section: 0) }
//                let inserted =  result.inserted.map { IndexPath(item: $0, section: 0) }
//                let updated =  result.updated.map { IndexPath(item: $0, section: 0) }
//                return Changeset.init(deleted: deleted,
//                                      inserted: inserted,
//                                      updated: updated)
//            }
//            .delay(0.01, scheduler: MainScheduler.instance)
//            .asDriver(onErrorJustReturn: Changeset.init(deleted: [], inserted: [], updated: []))
        
//        let unfilteredResults = emptySearch
//            .map { (results, changeset) in results }
//            .map { (results: AnyRealmCollection<Sub>) -> [SubCellViewModel] in
//                return results.map { (sub) in
//                    let vm = SubCellViewModel.init()
//                    vm.model.onNext(sub)
//                    return vm
//                }
        //            }
        
        //        let reloadAllUnfiltered = emptySearch
        //            .filter { $0.1 == nil }
        //            .map { (results, changeset) in results }
        //            .map { _ in () }
        //
        //        let reloadAllFiltered =
        
        
        
        cellViewModels = Observable
            .merge(emptySearch, nonEmptySearch)
            .map { (results: Results<Sub>) -> [SubCellViewModel] in
                return results.map { (sub) in
                    let vm = SubCellViewModel.init()
                    vm.model.onNext(sub)
                    return vm
                }
            }
            .asDriver(onErrorJustReturn: [])
    
        reloadAllItems = cellViewModels
            .map { _ in () }

    }
}

extension MainVCViewModel: Routable {
    
    func didSetDependencies() {
        setUpBindings()
    }
    
    var input: [Input] {
        return [
            Route.databaseManager.input({ self.databaseManager = $0 }),
            Route.networkManager.input({ self.networkManager = $0 })
        ]
    }
    var output: [Output] {
        return [
            
        ]
    }
}
