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
        
        let feellingSchedule = OCKSchedule(composing: [OCKScheduleElement(start: beforeBrekfast,
                                                                         end: nil,
                                                                         interval: DateComponents(day: 1),
                                                                         text: "How are your feeling today?",
                                                                         targetValues: [],
                                                                         duration: .allDay)])
        
        var feellingTask = OCKTask(id: CareStoreReferenceManager.TaskIdentifiers.feelling.rawValue,
                                   title: "Track feeling",
                                   carePlanID: nil,
                                   schedule: feellingSchedule)
        
        feellingTask.instructions = "How are your feeling today?"
        feellingTask.impactsAdherence = true
        addTask(feellingTask)
    }
    
    func populateStepsTask() {
        let thisMorning = Calendar.current.startOfDay(for: Date())
        guard let beforeBrekfast = Calendar.current.date(byAdding: .hour, value: 8, to: thisMorning)
        else {
            return assertionFailure("Could not create time 8AM this morning")
        }
        
        let stepsSchedule = OCKSchedule(composing: [OCKScheduleElement(start: beforeBrekfast,
                                                                         end: nil,
                                                                         interval: DateComponents(day: 1),
                                                                         text: "",
                                                                       targetValues: [OCKOutcomeValue(Int(), units: "")],
                                                                         duration: .allDay)])
        
        var stepsTask = OCKTask(id: CareStoreReferenceManager.TaskIdentifiers.steps.rawValue,
                                   title: "Today's steps",
                                   carePlanID: nil,
                                   schedule: stepsSchedule)
        
        stepsTask.impactsAdherence = false

        addTask(stepsTask)
    }
}
