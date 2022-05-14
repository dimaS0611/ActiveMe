  //
  //  StartView.swift
  //  ActiveMe WatchKit Extension
  //
  //  Created by Dima Semenovich on 8.05.22.
  //

import SwiftUI

struct StartView: View {
  @EnvironmentObject var workoutManager: WorkoutManager
  
  var body: some View {
    VStack {
      Text("Hi!✌️\nLet's track your sleep")
        .multilineTextAlignment(.leading)
      
      Spacer()
      
      NavigationLink("Start tracking 😴",
                     destination: {
        SessionView()
          .environmentObject(workoutManager)
      })
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
