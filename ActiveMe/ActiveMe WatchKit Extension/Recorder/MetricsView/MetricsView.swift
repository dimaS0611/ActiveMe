//
//  MetricsView.swift
//  ActiveMe WatchKit Extension
//
//  Created by Dima Semenovich on 8.05.22.
//

import SwiftUI

struct MetricsView: View {
  @EnvironmentObject var workoutManager: WorkoutManager
  @EnvironmentObject var sleepClassifier: SleepClassifier

  var body: some View {
    TimelineView(MetricsTimelineSchedule(from: workoutManager.builder?.startDate ?? Date())) { context in
      VStack(alignment: .leading) {
        header
        
        ElapsedTimeView(elapsedTime: workoutManager.builder?.elapsedTime ?? 0, showSubseconds: context.cadence == .live)
          .foregroundStyle(Color("primary"))
          .font(.system(.title, design: .rounded).monospacedDigit().lowercaseSmallCaps())
        Text("Steps count \(workoutManager.lastStepsRecord)")
          .font(.system(.title3, design: .rounded).monospacedDigit().lowercaseSmallCaps())
        Text(workoutManager.heartRate.formatted(.number.precision(.fractionLength(0))) + " bpm")
          .font(.system(.title3, design: .rounded).monospacedDigit().lowercaseSmallCaps())
        Text("Sleep stage " + sleepClassifier.sleepStage)
          .font(.system(.title3, design: .rounded).monospacedDigit().lowercaseSmallCaps())
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .ignoresSafeArea(edges: .bottom)
      .scenePadding()
    }
  }
  
  var header: some View {
    HStack {
      Capsule()
        .frame(height: 1)
      
      Image(systemName: "powersleep")
      
      Capsule()
        .frame(height: 1)
      
    }
    .foregroundColor(Color("primary"))
  }
}

struct MetricsView_Previews: PreviewProvider {
  static var previews: some View {
    MetricsView()
  }
}

private struct MetricsTimelineSchedule: TimelineSchedule {
  var startDate: Date

  init(from startDate: Date) {
    self.startDate = startDate
  }

  func entries(from startDate: Date, mode: TimelineScheduleMode) -> PeriodicTimelineSchedule.Entries {
    PeriodicTimelineSchedule(from: self.startDate, by: (mode == .lowFrequency ? 1.0 : 1.0 / 30.0))
      .entries(from: startDate, mode: mode)
  }
}
