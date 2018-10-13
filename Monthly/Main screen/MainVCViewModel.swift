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
    
    //MARK: - INPUT
    //    var imageData: AnyObserver<Data>!
    
    //MARK: - OUTPUT
    //views
    var didSetCellViewModels: Driver<[SubCellViewModel]>!
    var didUpdateCollectionViewItems: Driver<MainVCViewModel.Changeset>!
    var didReloadAllItems: Driver<Void>!
//    var didRequestImagePicker: Driver<Void>!
  
    
    //MARK: - PRIVATE
    private func setUpBindings() {
        let subChanges = databaseManager.getSubChanges().share()
        
        didUpdateCollectionViewItems = subChanges
            .map {(results, changeset) in changeset }
            .filter { $0 != nil } //has changes
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
        
        didSetCellViewModels = subChanges
            .map { (results, changeset) in results }
            .map { (results: AnyRealmCollection<Sub>) -> [SubCellViewModel] in
                return results.map { (sub) in
                    let vm = SubCellViewModel.init()
                    vm.model.onNext(sub)
                    return vm
                }
            }
            .asDriver(onErrorJustReturn: [])
        
        didReloadAllItems = subChanges
            .map { (results, changeset) in results }
            .map { _ in () }
            .asDriver(onErrorJustReturn: ())
        
        sliderViewModel.save.asObservable()
            .flatMap { self.databaseManager.add($0) }
            .subscribe(onNext: {
                print("success")
            })
        
            .disposed(by: disposeBag)

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
