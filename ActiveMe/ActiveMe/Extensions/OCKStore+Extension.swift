//
//  OCKStore.swift
//  ActiveMe
//
//  Created by Dzmitry Semianovich on 12/8/21.
//

import Foundation
import CareKitStore

extension OCKStore {
    
    func populateDailyTask() {
        
        let thisMorning = Calendar.current.startOfDay(for: Date())
        guard let beforeBrekfast = Calendar.current.date(byAdding: .hour, value: 8, to: thisMorning)
        else {
            return assertionFailure("Could not create time 8AM this morning")
        }
        
        let dailySchedule = OCKSchedule(composing: [OCKScheduleElement(start:
                                                                            beforeBrekfast,
                                                                         end: nil,
                                                                         interval: DateComponents(day: 1),
                                                                         text: "Glass of water",
                                                                         targetValues: [],
                                                                         duration: .allDay),
                                                      OCKScheduleElement(start: beforeBrekfast,
                                                                         end: nil,
                                                                         interval: DateComponents(day: 1),
                                                                         text: "Morning workout ", targetValues: [], duration: .allDay),
                                                      OCKScheduleElement(start: beforeBrekfast,
                                                                         end: nil,
                                                                         interval: DateComponents(day: 1),
                                                                         text: "Great mood",
                                                                         targetValues: [],
                                                                         duration: .allDay)])
        
        var dailyTask = OCKTask(id: CareStoreReferenceManager.TaskIdentifiers.dailyTracker.rawValue,
                                   title: "Daily tracker",
                                   carePlanID: nil,
                                   schedule: dailySchedule)
        
        dailyTask.impactsAdherence = true
        
        addTask(dailyTask)
    }
    
    func populateMoodTask() {
        let thisMorning = Calendar.current.startOfDay(for: Date())
        guard let beforeBrekfast = Calendar.current.date(byAdding: .hour, value: 8, to: thisMorning)
        else {
            return assertionFailure("Could not create time 8AM this morning")
        }
        
        let moodSchedule = OCKSchedule(composing: [OCKScheduleElement(start: beforeBrekfast,
                                                                         end: nil,
                                                                         interval: DateComponents(day: 1),
                                                                         text: "🙂",
                                                                       targetValues: [],
                                                                       duration: .allDay),
                                                    OCKScheduleElement(start: beforeBrekfast,
                                                                       end: nil,
                                                                       interval: DateComponents(day: 1),
                                                                       text: "😕",
                                                                       targetValues: [],
                                                                       duration: .allDay),
                                                    OCKScheduleElement(start: beforeBrekfast,
                                                                       end: nil,
                                                                       interval: DateComponents(day: 1),
                                                                       text: "☹️",
                                                                       targetValues: [],
                                                                       duration: .allDay)])
        
        var moodTask = OCKTask(id: CareStoreReferenceManager.TaskIdentifiers.mood.rawValue,
                                   title: "Today's mood",
                                   carePlanID: nil,
                                   schedule: moodSchedule)
        
        moodTask.impactsAdherence = false
        addTask(moodTask)
    }
}
