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
      case feelling
        case steps
    }
    
    static let shared = CareStoreReferenceManager()
    
    lazy var synchronizedStoreManager: OCKSynchronizedStoreManager = {
        let store = OCKStore(name: "Steps tracker")
        store.populateDailyTask()
        store.populateStepsTask()
        let manager = OCKSynchronizedStoreManager(wrapping: store)
        return manager
    }()
    
    private init() {}
}
