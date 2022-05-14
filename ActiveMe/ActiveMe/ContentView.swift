//
//  ContentView.swift
//  ActiveMe
//
//  Created by Dima Semenovich on 8.05.22.
//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject var appViewModel: AppViewModel

  @State var selectedtab: Int = 0

    var body: some View {
      ZStack(alignment: .bottom) {
        HomeView()

        FloatingTabBar(selected: $selectedtab)
          .padding(.bottom)
      }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
