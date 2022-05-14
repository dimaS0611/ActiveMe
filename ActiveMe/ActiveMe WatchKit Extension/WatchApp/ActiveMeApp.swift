  //
  //  ActiveMeApp.swift
  //  ActiveMe WatchKit Extension
  //
  //  Created by Dima Semenovich on 8.05.22.
  //

import SwiftUI

@main
struct ActiveMeApp: App {
  @Environment(\.scenePhase) var scenePhase
  
  @StateObject private var workoutManager: WorkoutManager
  @StateObject private var sleepClassifier: SleepClassifier
  
  let persistenceController = WatchPersistenceController.shared
  @StateObject private var connect: WatchConnectionProvider
  
  init() {
    let workoutManager = WorkoutManager()
    let connect = WatchConnectionProvider()
    self._connect = StateObject(wrappedValue: connect)
    self._workoutManager = StateObject(wrappedValue: workoutManager)
    self._sleepClassifier = StateObject(wrappedValue: SleepClassifier(workoutManager: workoutManager,
                                                                      motionManager: MotionManager(),
                                                                      sleepDataProcessor: SleepDataProcessor(connectionProvider: connect)))
  }
  
  @SceneBuilder var body: some Scene {
    WindowGroup {
      NavigationView {
        StartView()
//          .navigationTitle {
//            HStack {
//              Image("ActiveMeName")
//                .resizable()
//                .scaledToFit()
//              Spacer()
//            }
//          }
      }
      .environment(\.managedObjectContext, persistenceController.container.viewContext)
      .environmentObject(workoutManager)
      .environmentObject(sleepClassifier)
      .onAppear {
        persistenceController.deleteData()
      }
      .fullScreenCover(isPresented: $workoutManager.showingSummaryView) {
        SummaryView()
          .environmentObject(workoutManager)
      }
    }
    .onChange(of: scenePhase) { _ in
        persistenceController.save()
    }
    
    WKNotificationScene(controller: NotificationController.self, category: "myCategory")
  }
}
