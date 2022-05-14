//
//  ControlsView.swift
//  ActiveMe WatchKit Extension
//
//  Created by Dima Semenovich on 8.05.22.
//

import SwiftUI

struct ControlsView: View {
  @Environment(\.presentationMode) var presentationMode
  
  @EnvironmentObject var workoutManager: WorkoutManager
  @EnvironmentObject var sleepClassifier: SleepClassifier

  var body: some View {
    HStack {
      VStack {
        Button {
          sleepClassifier.stopClassification()
          workoutManager.endWorkout()
          presentationMode.wrappedValue.dismiss()
        } label: {
          Image(systemName: "xmark")
        }
        .tint(.red)
        .font(.title2)
        Text("End")
      }

      VStack {
        Button {
          sleepClassifier.toggleClassification()
          workoutManager.togglePause()
        } label: {
          Image(systemName: workoutManager.workoutHasStarted ? "pause" : "play")
        }
        .tint(.yellow)
        .font(.title2)
        Text(workoutManager.workoutHasStarted ? "Pause" : "Resume")
      }
    }
  }
}

struct ControlsView_Previews: PreviewProvider {
  static var previews: some View {
    ControlsView()
  }
}
