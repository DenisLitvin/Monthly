//
//  MainVCViewModel.swift
//  Monthly
//
//  Created by Denis Litvin on 10.08.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import Foundation

import RealmSwift
import Moya
import Charts

import RxCocoa
import RxSwift
import RxRealm

class MainVCViewModel: StatSliderViewViewModelProtocol {
    
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
    var statSliderViewViewModel: StatSliderViewViewModelProtocol {
        return self
    }
    
    //MARK: - OUTPUT
    //views
    var chartData: Driver<[ChartDataEntry]>!
    var cellViewModels: Driver<[SubCellViewModel]>!
    var updateCollectionViewItems: Driver<MainVCViewModel.Changeset>!
    var reloadAllItems: Driver<Void>!
    
    
    //MARK: - PRIVATE
    private func setUpBindings() {
        sliderViewModel.iconImage =
            sliderViewModel.iconRequestSubject.asObservable()
                .flatMapLatest {
                    self.networkManager.rx
                        .request(.image($0)).mapImage()
                        .catchErrorJustReturn(UIImage(named: "signature"))
                }
                .filterNil()
                .asDriver(onErrorJustReturn: UIImage(named: "signature")!)
        
        sliderViewModel.saveSubject.asObservable()
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
            .flatMapLatest {
                self.databaseManager
                    .getFilteredEntriesByName($0.1,sort:$0.0)
                    .share()
        }
        
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
        
        chartData = databaseManager.getAllEntries()
//            .take(1)
            .map { (subs: Results<Sub>) -> [PartialSub] in
                var arr = [PartialSub]()
                for sub in subs {
                    arr.append(PartialSub(from: sub))
                }
                return arr
            }
            .flatMap { $0.plotMonths() }
            .do(onNext: { months in
                print(months.count)
                print(months)
            })
            .map { months in
                return months.map { (key: Int, value: Float) -> (TimeInterval, Float) in
                    let date = Calendar.current.date(byAdding: .month,
                                             value: key,
                                             to: Date(timeIntervalSince1970: 0))
                    print(date)
                    return (date!.timeIntervalSince1970, value)
                    }
                    .sorted { $0.0 < $1.0 }
                    .map { value -> ChartDataEntry in
                        let (key, value) = value
                        return ChartDataEntry(x: Double(key), y: Double(value))
                }
            }
            .asDriver(onErrorJustReturn: [])
        
        
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
        return []
    }
}

struct PartialSub {
    let value: Float
    let category: Sub.Category
    let firstPayout: Date
    
    init(from sub: Sub) {
        self.value = sub.value
        self.firstPayout = sub.firstPayout
        self.category = Sub.Category.get(index: sub.category)!
    }
}
extension Collection where Element == PartialSub {
    
    func plotMonths() -> Single<[Int: Float]> {
        return Single.create(subscribe: { (single) -> Disposable in
            DispatchQueue.global().async {
                let calendar = Calendar.current
                var months = [Int: Float]()
                
                for entry in self {

                    let traversalComponent = entry.category.calendarComponent
                    var currentDate = entry.firstPayout
                    let referenceDate = Date().addingTimeInterval(-(60 * 60 * 24)) //up to yesterday
                    
                    while currentDate < referenceDate {
                        guard let date = calendar.date(byAdding: traversalComponent,
                                                       value: 1,
                                                       to: currentDate)
                            else { break }
                        
                        let monthsX = calendar.dateComponents([.month],
                                                              from: Date(timeIntervalSince1970: 0),
                                                              to: currentDate).month!
                        
                        months[monthsX] = (months[monthsX] ?? 0) + entry.value
                        currentDate = date
                    }
                }
                single(.success(months))
            }
            return Disposables.create()
        })
    }
    
    func plotDays() -> Single<[Int: Float]> {
        return Single.create(subscribe: { (single) -> Disposable in
            DispatchQueue.global().async {
                let calendar = Calendar.current
                var days = [Int: Float]()
                
                for entry in self {
                    let traversalComponent = entry.category.calendarComponent
                    var currentDate = entry.firstPayout
                    let referenceDate = Date().addingTimeInterval(-(60 * 60 * 24)) //up to yesterday
                    
                    while currentDate < referenceDate {
                        guard let date = calendar.date(byAdding: traversalComponent,
                                                       value: 1,
                                                       to: currentDate)
                            else { break }
                        
                        let daysX = calendar.dateComponents([.day],
                                                            from: Date(timeIntervalSince1970: 0),
                                                            to: currentDate).day!
                        days[daysX] = (days[daysX] ?? 0) + entry.value
                        currentDate = date
                    }
                }
                single(.success(days))
            }
            return Disposables.create()
        })
    }
}
