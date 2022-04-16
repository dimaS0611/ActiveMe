//
//  ContentView.swift
//  ActiveMe Watch WatchKit Extension
//
//  Created by Dzmitry Semenovich on 27.03.22.
//

import SwiftUI

struct StartView: View {
  @EnvironmentObject var workoutManager: WorkoutManager

  var body: some View {
    VStack {
      Text("Hi!✌️\nLet's track your sleep")
        .multilineTextAlignment(.leading)

      Spacer()

      NavigationLink("Start tracking 😴", destination: { SessionView() })
        .padding()
    }
    .onAppear {
      workoutManager.requestAuthorization()
    }
  }
}

struct StertView_Previews: PreviewProvider {
  static var previews: some View {
    StartView()
  }
}
