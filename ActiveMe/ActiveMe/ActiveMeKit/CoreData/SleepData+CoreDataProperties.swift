//
//  SleepData+CoreDataProperties.swift
//  ActiveMe
//
//  Created by Dima Semenovich on 9.05.22.
//
//

import Foundation
import CoreData


extension SleepData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SleepData> {
        return NSFetchRequest<SleepData>(entityName: "SleepData")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var startTime: Date?
    @NSManaged public var endTime: Date?
    @NSManaged public var sleepStage: String?
    @NSManaged public var date: Date?
    @NSManaged public var sessionId: UUID?
    @NSManaged public var stringDate: String?

}

extension SleepData : Identifiable {

}
