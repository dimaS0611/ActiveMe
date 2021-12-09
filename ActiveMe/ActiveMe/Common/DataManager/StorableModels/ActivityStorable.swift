//
//  ActivityStorable.swift
//  ActiveMe
//
//  Created by Dzmitry Semianovich on 12/8/21.
//

import Foundation
import GRDB

struct ActivityStorable: Codable, FetchableRecord, PersistableRecord {
    static var databaseTableName: String = "Activity"
    var date: Date
    var startTime: Date
    var endTime: Date
    var activity: String
    
    init(date: Date = Date(),
         start: Date,
         end: Date,
         activity: String) {
        self.date = date
        self.startTime = start
        self.endTime = end
        self.activity = activity
    }
}
