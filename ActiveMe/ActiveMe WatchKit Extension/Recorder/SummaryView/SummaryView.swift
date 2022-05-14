  //
  //  SummaryView.swift
  //  ActiveMe WatchKit Extension
  //
  //  Created by Dima Semenovich on 8.05.22.
  //

import Foundation
import HealthKit
import SwiftUI
import WatchKit

struct SummaryView: View {
  @EnvironmentObject var workoutManager: WorkoutManager
  @Environment(\.presentationMode) var presentationMode
  @State private var durationFormatter: DateComponentsFormatter = {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute, .second]
    formatter.zeroFormattingBehavior = .pad
    return formatter
  }()
  
  var body: some View {
    if workoutManager.workout == nil {
      ProgressView("Saving data")
        .navigationBarHidden(true)
    } else {
      ScrollView {
        VStack(alignment: .leading) {
          SummaryMetricView(title: "Total Time",
                            value: durationFormatter.string(from: workoutManager.workout?.duration ?? 0.0) ?? "")
          .foregroundStyle(.yellow)
          
          SummaryMetricView(title: "Total steps count",
                            value: String(workoutManager.lastStepsRecord))
          .foregroundStyle(.green)
          
          SummaryMetricView(title: "Avg. Heart Rate",
                            value: workoutManager.averageHeartRate.formatted(.number.precision(.fractionLength(0))) + " bpm")
          .foregroundStyle(.red)

          Button("Done") {
            WKInterfaceDevice.current().play(.success)
            workoutManager.showingSummaryView = false
            presentationMode.wrappedValue.dismiss()
          }
        }
        .scenePadding()
      }
      .navigationTitle("Summary")
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}

struct SummaryView_Previews: PreviewProvider {
  static var previews: some View {
    SummaryView()
  }
}

struct SummaryMetricView: View {
  var title: String
  var value: String
  
  var body: some View {
    Text(title)
      .foregroundStyle(.foreground)
    Text(value)
      .font(.system(.title2, design: .rounded).lowercaseSmallCaps())
    Divider()
  }
}
