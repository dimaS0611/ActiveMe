//
//  CareStoreRefrenceManager.swift
//  ActiveMe
//
//  Created by Dzmitry Semianovich on 12/8/21.
//

import Foundation
import CareKit

final class CareStoreReferenceManager {
    
    enum TaskIdentifiers: String, CaseIterable {
      case dailyTracker
        case mood
    }
    
    static let shared = CareStoreReferenceManager()
    
    lazy var synchronizedStoreManager: OCKSynchronizedStoreManager = {
        let store = OCKStore(name: "Daily tracker")
        store.populateDailyTask()
       // store.populateMoodTask()
        let manager = OCKSynchronizedStoreManager(wrapping: store)
        return manager
    }()
    
    private init() {}
}
