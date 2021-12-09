//
//  HomeModel.swift
//  ActiveMe
//
//  Created by Dzmitry Semianovich on 12/9/21.
//

import Foundation
import RxSwift

protocol HomeModelProtocol: AnyObject {
    func obtainStepsPerDay(date: Date) -> Single<Int>
    func obtainActivityPerDay(date: Date) -> Single<[String : DateInterval]>
    func obtainStepsPerTime(date: Date) -> [DateInterval : Int]
}

class HomeModel: HomeModelProtocol {
    let storage = StorageService()
    
    func obtainStepsPerDay(date: Date) -> Single<Int> {
        Single<Int>.create { [weak self] event -> Disposable in
            let steps = self?.storage.obtainSteps(by: date)
            event(.success(steps ?? 0))
            return Disposables.create()
        }
    }
    
    func obtainActivityPerDay(date: Date) -> Single<[String : DateInterval]> {
        Single<[String : DateInterval]>.create { [weak self] event -> Disposable in
            let activities = self?.storage.obtainActivity(by: date)
            event(.success(activities ?? [:]))
            return Disposables.create()
        }
    }
    
    func obtainStepsPerTime(date: Date) -> [DateInterval : Int] {
        return self.storage.obtainStepsAndTime(by: date)
    }
}
