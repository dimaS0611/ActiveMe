//
//  StorageService.swift
//  ActiveMe
//
//  Created by Dzmitry Semianovich on 12/8/21.
//

import Foundation

protocol StorageServiceProtocol: AnyObject {
    func storeSteps(model: StepsStorable)
    func obtainSteps(by date: Date) -> Int
    func obtainStepsAndTime(by date: Date) -> [DateInterval : Int]
    func obtainAllSteps() -> Int
    
    func storeActivity(model: ActivityStorable)
    func obtainActivity(by date: Date) -> [String : DateInterval]
    func obtainAllActivity() -> [String : DateInterval]
}

class StorageService: StorageServiceProtocol {
    
    let storage = StorageManager.shared
    
    func storeSteps(model: StepsStorable) {
        storage.storeSteps(model: model)
    }
    
    func obtainSteps(by date: Date) -> Int {
        storage.obtainSteps(by: date)
    }
    
    func obtainStepsAndTime(by date: Date) -> [DateInterval : Int] {
        storage.obtainStepsAndTime(by: date)
    }
    
    func obtainAllSteps() -> Int {
        storage.obtainAllSteps()
    }
    
    func storeActivity(model: ActivityStorable) {
        storage.storeActivity(model: model)
    }
    
    func obtainActivity(by date: Date) -> [String : DateInterval] {
        storage.obtainActivity(by: date)
    }
    
    func obtainAllActivity() -> [String : DateInterval] {
        storage.obtainAllActivity()
    }
}

protocol StorageManagerProtocol: AnyObject {
    func storeSteps(model: StepsStorable)
    func obtainSteps(by date: Date) -> Int
    func obtainAllSteps() -> Int
    
    func storeActivity(model: ActivityStorable)
    func obtainActivity(by date: Date) -> [String : DateInterval]
    func obtainStepsAndTime(by date: Date) -> [DateInterval : Int]
    func obtainAllActivity() -> [String : DateInterval]
}
