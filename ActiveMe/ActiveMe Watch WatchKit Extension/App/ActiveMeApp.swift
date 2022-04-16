//
//  ActiveMeApp.swift
//  ActiveMe Watch WatchKit Extension
//
//  Created by Dzmitry Semenovich on 27.03.22.
//

import SwiftUI

@main
struct ActiveMeApp: App {
  @StateObject private var workoutManager = WorkoutManager()

    @SceneBuilder var body: some Scene {
        WindowGroup {
          NavigationView {
              StartView()
              .navigationTitle {
                  HStack {
                      Image("ActiveMeName")
                          .resizable()
                          .scaledToFit()
                      Spacer()
                  }
              }
          }
          .sheet(isPresented: $workoutManager.showingSummaryView) {
              SummaryView()
          }
          .environmentObject(workoutManager)
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
