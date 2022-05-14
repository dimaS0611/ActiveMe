//
//  AppViewModel.swift
//  ActiveMe
//
//  Created by Dima Semenovich on 8.05.22.
//

import SwiftUI
import Combine
import WatchConnectivity

final class AppViewModel: ObservableObject {
  @Published var connectivityProvider: PhoneConnectionProvider
  
  private var disposeBag = Set<AnyCancellable>()
  
  init() {
    self._connectivityProvider = Published(wrappedValue: PhoneConnectionProvider())
    if WCSession.isSupported() {
      self.connectivityProvider.connect()
    }
    bindInputs()
  }
  
  private func bindInputs() {
    connectivityProvider
      .$receivedSleepClassification
      .receive(on: DispatchQueue.main)
      .sink { [weak self] data in
        self?.saveReceivedData(data)
      }
      .store(in: &disposeBag)
  }
  
  private func saveReceivedData(_ data: [SleepClassificationData]) {
    PersistenceController.shared.saveSleepData(data)
  }
}
