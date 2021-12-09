//
//  StepsStorable.swift
//  ActiveMe
//
//  Created by Dzmitry Semianovich on 12/8/21.
//

import Foundation
import GRDB

struct StepsStorable: Codable, FetchableRecord, PersistableRecord {
//    var id: Int = 0
    static var databaseTableName: String = "Steps"
    var date: Date
    var timeStart: Date
    var timeEnd: Date
    var steps: Int
    
    init(date: Date = Date(),
         start: Date,
         end: Date,
         steps: Int) {
        self.date = date
        self.timeStart = start
        self.timeEnd = end
        self.steps = steps
    }
}
