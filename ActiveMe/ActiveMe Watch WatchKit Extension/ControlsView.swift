//
//  ControlsView.swift
//  ActiveMe Watch WatchKit Extension
//
//  Created by Dzmitry Semenovich on 10.04.22.
//

import SwiftUI

struct ControlsView: View {
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var workoutManager: WorkoutManager

  var body: some View {
    HStack {
      VStack {
        Button {
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
