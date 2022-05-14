//
//  SessionView.swift
//  ActiveMe WatchKit Extension
//
//  Created by Dima Semenovich on 8.05.22.
//

import SwiftUI
import WatchKit

struct SessionView: View {
  @EnvironmentObject var workoutManager: WorkoutManager
  @EnvironmentObject var sleepClassifier: SleepClassifier
  
  @Environment(\.isLuminanceReduced) var isLuminanceReduced

  @State var currentTab: Tab = .metrics
  
    var body: some View {
      TabView(selection: $currentTab) {
        ControlsView().tag(Tab.controls)
        MetricsView().tag(Tab.metrics)
      }
      .navigationBarBackButtonHidden(true)
      .tabViewStyle(PageTabViewStyle(indexDisplayMode: isLuminanceReduced ? .never : .automatic))
      .onChange(of: isLuminanceReduced) { _ in
          displayMetricsView()
      }
      .onAppear {
        WKInterfaceDevice.current().play(.start)
        workoutManager.startWorkoutTracking()
        sleepClassifier.startClassification()
      }
    }

  private func displayMetricsView() {
      withAnimation {
        currentTab = .metrics
      }
  }
}

extension SessionView {
  enum Tab {
    case metrics
    case controls
  }
}
