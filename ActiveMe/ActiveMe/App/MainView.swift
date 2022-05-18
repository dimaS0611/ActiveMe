//
//  ContentView.swift
//  ActiveMe
//
//  Created by Dima Semenovich on 8.05.22.
//

import SwiftUI

struct MainView: View {
  @EnvironmentObject var appViewModel: AppViewModel

  @State var selectedtab: Int = 0

  var body: some View {
    Splash {
      SplashScreen()
    } content: {
      ZStack(alignment: .bottom) {
        mainContent

        FloatingTabBar(selected: $selectedtab)
          .padding(.bottom)
      }
    }
  }

  @ViewBuilder
  var mainContent: some View {
    switch selectedtab {
    case 0:
      HomeView()
        .environmentObject(appViewModel)
    case 1:
      SleepView()
        .environmentObject(appViewModel)
    default:
      EmptyView()
    }
  }
}

