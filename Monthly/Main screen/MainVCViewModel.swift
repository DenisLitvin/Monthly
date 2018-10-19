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
    var sliderViewModel = SliderViewModel()
    var tabBarViewModel = TabBarViewModel()
    
    //MARK: - OUTPUT
    //views
    var cellViewModels: Driver<[SubCellViewModel]>!
    var updateCollectionViewItems: Driver<MainVCViewModel.Changeset>!
    var reloadAllItems: Driver<Void>!
    
    
    //MARK: - PRIVATE
    private func setUpBindings() {
        
        let searchTextObs = tabBarViewModel.searchTextEntered.asObservable().startWith("")
        
        let emptySearch = searchTextObs
            .filter { $0.isEmpty }
            .flatMapLatest { _ in self.databaseManager.getAllEntries().share() }
        
        let nonEmptySearch = searchTextObs
            .filter { !$0.isEmpty }
            .flatMapLatest { self.databaseManager.getFilteredEntriesByName($0).share() }
        
        let subChanges = emptySearch
        
        updateCollectionViewItems = subChanges
            .map {(results, changeset) in changeset }
            .filter { $0 != nil }
            .map { (result: RealmChangeset?) -> Changeset in
                let result = result!
                let deleted = result.deleted.map { IndexPath(item: $0, section: 0) }
                let inserted =  result.inserted.map { IndexPath(item: $0, section: 0) }
                let updated =  result.updated.map { IndexPath(item: $0, section: 0) }
                return Changeset.init(deleted: deleted,
                                      inserted: inserted,
                                      updated: updated)
            }
            .delay(0.01, scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: Changeset.init(deleted: [], inserted: [], updated: []))
        
        let unfilteredResults = subChanges
            .map { (results, changeset) in results }
            .map { (results: AnyRealmCollection<Sub>) -> [SubCellViewModel] in
                return results.map { (sub) in
                    let vm = SubCellViewModel.init()
                    vm.model.onNext(sub)
                    return vm
                }
            }
        
        let filteredResults = nonEmptySearch
            .map { (results: Results<Sub>) -> [SubCellViewModel] in
                return results.map { (sub) in
                    let vm = SubCellViewModel.init()
                    vm.model.onNext(sub)
                    return vm
                }
        }
        
        cellViewModels = Observable
            .merge(filteredResults, unfilteredResults)
            .asDriver(onErrorJustReturn: [])
        
        let reloadAllUnfiltered = subChanges
            .filter { $0.1 == nil }
            .map { (results, changeset) in results }
            .map { _ in () }
            .asDriver(onErrorJustReturn: ())
        
        let reloadAllFiltered = filteredResults
            .map { _ in () }
            .asDriver(onErrorJustReturn: ())
        
        reloadAllItems = Driver
            .merge(reloadAllFiltered, reloadAllUnfiltered)
        
        sliderViewModel.save.asObservable()
            .flatMap { self.databaseManager.add($0) }
            .subscribe(onNext: {
                print("save is successful")
            })
            .disposed(by: disposeBag)
        
 
//                .subscribe(onNext: { text in
//                print("search", text)
//            })
//            .disposed(by: disposeBag)
    }
}

extension MainVCViewModel: Routable {
    
    func didSetDependencies() {
        setUpBindings()
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
