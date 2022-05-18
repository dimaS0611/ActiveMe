//
//  FloatingTabBar.swift
//  ActiveMe
//
//  Created by Dima Semenovich on 14.05.22.
//

import SwiftUI

struct FloatingTabBar: View {

  @Binding var selected : Int

  var body: some View {
    HStack(spacing: 15) {
      Button(action: {
        self.selected = 0
      }) {
        Image(systemName: "house")
          .foregroundColor(self.selected == 0 ? Color("secondary") : .gray)
          .padding(.horizontal)
      }
      Button(action: {
        self.selected = 1
      }) {
        Image(systemName: "moon.zzz.fill")
          .foregroundColor(self.selected == 1 ? Color("secondary") : .gray)
          .padding(.horizontal)
      }
    }
    .padding(.vertical, 20)
    .padding(.horizontal, 10)
    .background(
      background
        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
    )
    .clipShape(Capsule())
    .padding(22)
    .animation(.interactiveSpring(response: 0.6,
                                  dampingFraction: 0.6,
                                  blendDuration: 0.6),
               value: 0)
  }

  var background: some View {
    ZStack {
      HStack {
        Circle()
          .fill(Color("bgColorPurple"))
          .scaleEffect(0.7)
          .offset(x: 0)
          .blur(radius: 25)

        Circle()
          .fill(Color("bgColorPurple"))
          .scaleEffect(0.7)
          .offset(x: 5, y: -10)
          .blur(radius: 25)

        Circle()
          .fill(Color("bgColorPurple"))
          .scaleEffect(0.7)
          .offset(x: 5, y: 20)
          .blur(radius: 25)

      }
      Rectangle()
        .fill(.ultraThinMaterial)
    }
  }
}

struct FloatingTabBar_Previews: PreviewProvider {
  static var previews: some View {
    FloatingTabBar(selected: .constant(1))
  }
}
