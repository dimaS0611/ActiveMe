//
//  AppViewModel.swift
//  ActiveMe WatchKit Extension
//
//  Created by Dima Semenovich on 11.05.22.
//

import Combine
import SwiftUI

class AppViewModel: ObservableObject {
  
  var connectionProvider: WatchConnectionProvider
  
  init(connectionProvider: WatchConnectionProvider) {
    self.connectionProvider = connectionProvider
  }
  
  func checkPreviousSaveState() {
    let lastRecordSaved = UserDefaults.standard.bool(forKey: "saving_sate")
    
    if !lastRecordSaved {
      WatchPersistenceController.shared.fetchLastRecord()
    }
  }
}
