//
//  BarGraph.swift
//  ActiveMe
//
//  Created by Dima Semenovich on 14.05.22.
//

import SwiftUI

struct BarGraph: View {
  // TO-DO: protocol/ generic
  var data: [Step]

  @GestureState var isDragging: Bool = false
  @State var offset: CGFloat = .zero

  @State var viewSize: CGSize = .zero
  @State var graphWidth: CGFloat = .zero

  @State var currentDatumnId: UUID = UUID()

  var body: some View {
    ZStack {
      grid

      graph
        .padding(.leading, 25)
        .readSize { size in
          graphWidth = size.width
        }
    }
    .frame(height: 190)
    .readSize { size in
      viewSize = size
    }
  }

  var grid: some View {
    VStack(spacing: 0) {
      ForEach(getGraphLines(), id: \.self) { line in
        HStack(spacing: 8) {
          Text("\(Int(line))")
            .font(.caption)
            .foregroundColor(.gray)
            .frame(height: 20)

          Rectangle()
            .fill(.gray.opacity(0.2))
            .frame(height: 1)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    .offset(y: -15)
  }

  var graph: some View {
    HStack(alignment: .bottom) {
      ForEach(data.indices, id: \.self) { idx in
        cardView(data[idx], index: idx)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    .frame(height: 190)
    .animation(.easeOut, value: isDragging)
    .gesture(
      DragGesture()
        .updating($isDragging) { _, out, _ in
          out = true
        }
        .onChanged { value in
          offset = isDragging ? value.location.x : 0

          let draggingSpace = graphWidth//UIScreen.main.bounds.width - 60

          let eachBlock = draggingSpace / CGFloat(data.count)

          let tmp = Int(offset/eachBlock)

          let index = max(min(tmp, data.count - 1), 0)

          self.currentDatumnId = data[index].id
        }
        .onEnded { value in
          withAnimation {
            offset = .zero
            currentDatumnId = UUID()
          }
        }
    )
    .onChange(of: currentDatumnId) { _ in
      let impact = UIImpactFeedbackGenerator(style: .soft)
      impact.impactOccurred()
    }
  }

  func cardView(_ datumn: Step, index: Int) -> some View {
    VStack(spacing: 5) {
      AnimatedBarGraphView(step: datumn, index: index)
        .padding(.horizontal, 8)
        .opacity(isDragging ? (currentDatumnId == datumn.id ? 1 : 0.35) : 1)
        .frame(height: barHeight(point: datumn.value, size: viewSize), alignment: .bottom)//(datumn.value / getMax()) * size.height)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .overlay(
          Text("\(Int(datumn.value))")
            .font(.callout)
            .foregroundColor(datumn.color)
            .opacity(isDragging && currentDatumnId == datumn.id ? 1 : 0)
            .offset(y: -20)

          , alignment: .top
        )

      Text(datumn.key
        .replacingOccurrences(of: " AM", with: "")
        .replacingOccurrences(of: " PM", with: ""))
      .font(.callout)
      .foregroundColor(currentDatumnId == datumn.id ? datumn.color : .gray)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
  }

  func barHeight(point: CGFloat, size: CGSize) -> CGFloat {
    let max = getMax()

    let height = (point / max) * (size.height - 37)

    return height
  }

  func getGraphLines() -> [CGFloat] {
    let max = getMax()
    var lines: [CGFloat] = []

    lines.append(max)

    for idx in 1...4 {
      let progress = max  / 4

      lines.append(max - (progress * CGFloat(idx)))
    }

    return lines
  }

  func getMax() -> CGFloat {
    let max = data.max { lhs, rhs in
      return rhs.value > lhs.value
    }

    return max?.value ?? 0
  }
}

struct AnimatedBarGraphView: View {
  var step: Step
  var index: Int

  @State var showBar: Bool = false

  var body: some View {
    VStack(spacing: 0) {
      Spacer(minLength: 0)

      RoundedRectangle(cornerRadius: 5, style: .continuous)
        .fill(step.color)
        .frame(height: showBar ? nil : 0, alignment: .bottom)
    }
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.8).delay(Double(index) * 0.1)) {
          showBar = true
        }
      }
    }
  }
}
