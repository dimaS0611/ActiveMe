//
//  BackgroundView.swift
//  ActiveMe
//
//  Created by Dima Semenovich on 15.05.22.
//

import SwiftUI

struct BackgroundView: View {
  var body: some View {
    ZStack {
      VStack {
        Circle()
          .fill(Color("bgColorPurple"))
          .scaleEffect(0.7)
          .offset(x: 20)
          .blur(radius: 120)

        Circle()
          .fill(Color("bgColorPurple"))
          .scaleEffect(0.7, anchor: .leading)
          .offset(x: -20)
          .blur(radius: 120)
      }

      Rectangle()
        .fill(.ultraThinMaterial)
    }
  }
}
