//
//  ActiveMeApp.swift
//  ActiveMe
//
//  Created by Dima Semenovich on 8.05.22.
//

import SwiftUI

@main
struct ActiveMeApp: App {
  @Environment(\.scenePhase) var scenePhase
  
  @StateObject var appViewModel: AppViewModel
  let persistenceController = PersistenceController.shared
  
  init() {
    self._appViewModel = StateObject(wrappedValue: AppViewModel())
  }
  
    var body: some Scene {
        WindowGroup {
          MainView()
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .environmentObject(appViewModel)
        }
        .onChange(of: scenePhase) { _ in
            persistenceController.save()
        }
    }
}
