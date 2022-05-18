//
//  SleppAnalyticsView.swift
//  ActiveMe
//
//  Created by Dima Semenovich on 15.05.22.
//

import SwiftUI

struct SleepAnalyticsView: View {

  @StateObject var viewModel: SleepAnalyticsViewModel

  @Binding var data: [SleepModel]

  init(sleepData: Binding<[SleepModel]>) {
    self._viewModel = StateObject(wrappedValue: SleepAnalyticsViewModel(sleepData: sleepData))
    self._data = sleepData
  }

  var body: some View {
    VStack(alignment: .leading,
           spacing: 15) {
      quality

      Divider()
        .frame(width: 250)

      duration

      Divider()
        .frame(width: 250)

      sleepAtTime
    }
           .padding(.vertical, 20)
           .padding(.horizontal, 25)
           .background(
            RoundedRectangle(cornerRadius: 25, style: .continuous)
              .fill(.ultraThinMaterial)
           )
           .onChange(of: data) { _ in
             viewModel.refresh()
           }
  }

  var quality: some View {
    Label {
      Text("Your sleep quality \(viewModel.sleepQuality)%")
        .font(.callout)
    } icon: {
      Image(systemName: "moon")
        .resizable()
        .scaledToFit()
        .frame(width: 20, height: 20)
        .foregroundColor(Color("primary"))
    }
  }

  var duration: some View {
    HStack {
      Image(systemName: "bed.double")
        .resizable()
        .scaledToFit()
        .frame(width: 20, height: 20)
        .foregroundColor(Color("primary"))

      VStack(alignment: .leading) {
        Text(viewModel.sleepEnough ? "You slept enough" : "You haven't slept enough")
          .font(.callout)

        Text("It is recommended to sleep 7-9 hours. Lack of sleep can lead to physical and mental disorders")
          .font(.caption.italic())
          .foregroundColor(.gray)
          .padding(.leading, 3)
      }
      .padding(.leading, 3)
    }
  }

  var sleepAtTime: some View {
    HStack {
      Image(systemName: "clock")
        .resizable()
        .scaledToFit()
        .frame(width: 20, height: 20)
        .foregroundColor(Color("primary"))

      VStack(alignment: .leading) {
        Text(viewModel.sleepAtTime ? "You went to bed at time" : "You went to bed not at time")
          .font(.callout)

        Text("Try to go to bed before 22:00. Staying up late can harm your immune system.")
          .font(.caption.italic())
          .foregroundColor(.gray)
          .padding(.leading, 3)
      }
      .padding(.leading, 3)
    }
  }
}
