//
//  SplashScreen.swift
//  ActiveMe
//
//  Created by Dima Semenovich on 16.05.22.
//

import SwiftUI
import Foundation

struct Splash<Splash: View, Content: View>: View {

  var splashDuration: CGFloat = 1.2
  @State var showingSplash: Bool = true

  var splash: Splash
  var content: Content

  init(@ViewBuilder splash: () -> Splash,
       @ViewBuilder content: () -> Content) {
    self.splash = splash()
    self.content = content()
  }

  var body: some View {
    if showingSplash {
      splash
        .onAppear { scheduleHideSplash() }
        .transition(.opacity.animation(.default))
    } else {
      content
        .transition(.opacity.animation(.default))
    }
  }

  func scheduleHideSplash() {
    DispatchQueue.main
      .asyncAfter(deadline: .now() + splashDuration) {
        showingSplash = false
      }
  }
}

struct SplashScreen: View {
  var body: some View {
      ZStack {
        BackgroundView()
          .preferredColorScheme(.dark)
          .ignoresSafeArea()

        Image("ActiveMeName")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .foregroundColor(Color("primary"))
          .frame(width: 350, height: 150)
      }
  }
}

struct SplashScreen_Previews: PreviewProvider {
  static var previews: some View {
    SplashScreen()
  }
}
