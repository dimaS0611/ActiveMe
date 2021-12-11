//
//  StorageManager.swift
//  ActiveMe
//
//  Created by Dzmitry Semianovich on 12/8/21.
//

import Foundation
import GRDB

final class StorageManager {
    
    private var db: DatabaseQueue!
    
    private var migration = DatabaseMigrator()
    
    static let shared = StorageManager()
    
    private init() {
        setupDB()
    }
    
    private func setupDB() {
        do {
            let path = try FileManager.default.url(for: .documentDirectory,
                                                      in: .userDomainMask,
                                                      appropriateFor: nil,
                                                      create:true)
                .appendingPathComponent("ActiveMe.sqlite")
            
            db = try DatabaseQueue(path: path.absoluteString)
            registerMigration()
            try migration.migrate(db)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func registerMigration() {
        migration.registerMigration("v1") { db in
            try db.create(table: "Steps") { t in
                t.column("date", .date)
                t.column("timeStart", .datetime)
                t.column("timeEnd", .datetime)
                t.column("steps", .integer)
                
                t.autoIncrementedPrimaryKey("id", onConflict: .replace)
                t.uniqueKey(["id"], onConflict: .replace)
            }
            
            try db.create(table: "Activity"){ t in
                t.column("date", .date)
                t.column("timeStart", .integer)
                t.column("timeEnd", .integer)
                t.column("activity", .text)
                
                t.autoIncrementedPrimaryKey("id", onConflict: .replace)
                t.uniqueKey(["id"], onConflict: .replace)
            }
        }
    }
}

extension StorageManager: StorageManagerProtocol {
    func storeSteps(model: StepsStorable) {
        do {
            guard let db = db else { return }
            try db.write({ db in
                try model.insert(db)
            })
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func obtainSteps(by date: Date) -> Int {
        do {
            let steps = try db?.read({ db in
                try StepsStorable
                    .filter(Column("date") == date)
                    .fetchAll(db)
            })
            
            let stepsCount = steps?
                .compactMap { $0.steps }
                .reduce(0, +)
            
            return stepsCount ?? 0
        } catch let error {
            print(error.localizedDescription)
            return 0
        }
    }
    
    func obtainStepsAndTime(by date: Date) -> [DateInterval : Int] {
        do {
            let start = Calendar.current.startOfDay(for: date)
            let end = (Calendar.current.date(byAdding: .hour, value: 24, to: start) ?? Date())
            
            let steps = try db?.read({ db in
                try StepsStorable
                    .filter(Column("date") > start)
                    .filter(Column("date") < end)
                    .fetchAll(db)
            })
            
            guard let steps = steps,
                  !steps.isEmpty else { return [:] }
            
            var hours = [DateInterval]()
            for i in 0..<24 {
                var start: Date
                
                if hours.isEmpty {
                    start = Calendar.current.startOfDay(for: date)
                } else {
                    start = hours[i-1].end
                }
                
                hours.append(DateInterval(start: start, duration: 3600))
            }
            
            var stepsPerHour: [DateInterval:Int] = [:]
            
            for hour in hours {
                stepsPerHour[hour] = 0
            }
            
            for step in steps {
                for hour in hours {
                    if hour.contains(step.timeEnd) {
                        let cuurentSteps = stepsPerHour[hour] ?? 0
                        stepsPerHour.updateValue(cuurentSteps + step.steps, forKey: hour)
                    }
                }
            }
            return stepsPerHour
        } catch let error {
            print(error.localizedDescription)
            return [:]
        }
    }
    
    func obtainAllSteps() -> Int {
        do {
            let allSteps = try db?.read({ db in
                try StepsStorable.fetchAll(db)
            })
            
            let steps = allSteps?
                .compactMap { $0.steps }
                .reduce(0, +)
            
            return steps ?? 0
        } catch let error {
            print(error.localizedDescription)
            return 0
        }
    }
    
    func storeActivity(model: ActivityStorable) {
        do {
            try db?.write({ db in
                try model.insert(db)
            })
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func obtainActivity(by date: Date) -> [String : DateInterval] {
        do {
            let activity = try db?.read({ db in
                try ActivityStorable
                    .filter(Column("date") == date)
                    .fetchAll(db)
            })
            
            guard let activity = activity else { return [:] }
            return activitiesArrToDict(activities: activity)
        } catch let error {
            print(error.localizedDescription)
            return [:]
        }
    }
    
    func obtainAllActivity() -> [String : DateInterval] {
        do {
            let allActivity = try db?.read({ db in
                try ActivityStorable.fetchAll(db)
            })
            
            
            guard let allActivity = allActivity else { return [:] }
            return activitiesArrToDict(activities: allActivity)
        } catch let error {
            print(error.localizedDescription)
            return [:]
        }
    }
    
    private func activitiesArrToDict(activities: [ActivityStorable]) -> [String : DateInterval] {
        let activity = Dictionary(grouping: activities) { $0.activity }
        var result: [String : DateInterval] = [:]
        
        activity.values.forEach { el in
            let time = el
                .map { DateInterval(start: $0.timeStart, end: $0.timeEnd) }
                .sorted { $0.duration < $1.duration }
            
            if let type = el.first?.activity,
               let first = time.first,
               let last = time.last {
                
                result[type] = DateInterval(start: first.start, end: last.end)
            }
        }
        
        return result
    }
}
