//
//  FitnessRingCardView.swift
//  ActiveMe
//
//  Created by Dima Semenovich on 13.05.22.
//

import SwiftUI

struct FitnessRingCardView: View {
  @EnvironmentObject var appViewModel: AppViewModel

  var body: some View {
    VStack(spacing: 15) {
      Text("Progress")
        .fontWeight(.semibold)
        .frame(maxWidth: .infinity, alignment: .leading)

      HStack(spacing: 20) {
        ZStack {
          ForEach(appViewModel.rings.indices, id: \.self) { idx in
            AnimatedRingView(ring: $appViewModel.rings[idx], index: idx)
          }
        }
        .frame(width: 130, height: 130)

        VStack(alignment: .leading,
               spacing: 12) {
          ForEach(appViewModel.rings) { ring in
            Label {
              HStack(alignment: .bottom, spacing: 6) {
                Text("\(Int(ring.progress))%")
                  .font(.title3.bold())

                Text(ring.value)
                  .font(.caption)
              }
            } icon: {
              Group {
                if ring.isText {
                  Text(ring.keyIcon)
                    .font(.title2)
                } else {
                  Image(systemName: ring.keyIcon)
                    .font(.title2)
                }
              }
              .frame(width: 30)
            }
          }
        }
      }
      .padding(.top, 20)
    }
    .padding(.vertical, 20)
    .padding(.horizontal, 25)
    .background(
      RoundedRectangle(cornerRadius: 25, style: .continuous)
        .fill(.ultraThinMaterial)
    )
  }
}


struct AnimatedRingView: View {
  @EnvironmentObject var appViewModel: AppViewModel
  @Binding var ring: Ring
  var index: Int

  @State var showRing: Bool = false

  var body: some View {
    ZStack {
      Circle()
        .stroke(.gray.opacity(0.3), lineWidth: 10)

      Circle()
        .trim(from: 0, to: showRing ? appViewModel.rings[index].progress / 100 : 0)
        .stroke(appViewModel.rings[index].keyColor, style: StrokeStyle(lineWidth: 10,
                                                          lineCap: .round,
                                                          lineJoin: .round))
        .rotationEffect(.init(degrees: -90))
    }
    .padding(CGFloat(index) * 16)
    .onAppear {
      animate()
    }
    .onChange(of: ring) { _ in
      showRing = false
      animate()
    }
  }

  func animate() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
      withAnimation(.interactiveSpring(response: 1,
                                       dampingFraction: 1,
                                       blendDuration: 1).delay(Double(index) * 0.1)) {
        showRing = true
      }
    }
  }
}
