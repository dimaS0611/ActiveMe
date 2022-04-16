//
//  SessionView.swift
//  ActiveMe Watch WatchKit Extension
//
//  Created by Dzmitry Semenovich on 10.04.22.
//

import SwiftUI
import WatchKit

struct SessionView: View {
  @EnvironmentObject var workoutManager: WorkoutManager
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
        workoutManager.startWorkoutTracking()
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

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        SessionView()
    }
}
