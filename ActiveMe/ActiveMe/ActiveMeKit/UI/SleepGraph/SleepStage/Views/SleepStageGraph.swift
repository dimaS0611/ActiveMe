//
//  SleepGraph.swift
//  ActiveMe
//
//  Created by Dima Semenovich on 15.05.22.
//

import SwiftUI

struct SleepStageGraph: View {

  @StateObject var viewModel: SleepStageViewModel

  @Binding var data: [SleepModel]

  @GestureState var isDragging: Bool = false
  @State var offset: CGFloat = .zero

  @State var viewSize: CGSize = .zero
  @State var graphWidth: CGFloat = .zero

  @State var currentDatumnId: UUID = UUID()

  init(data: Binding<[SleepModel]>) {
    self._viewModel = StateObject(wrappedValue: SleepStageViewModel(data: data))
    self._data = data
  }

    var body: some View {
      VStack {
        graph
          .readSize { size in
            graphWidth = size.width
          }

        HStack {
          ForEach(viewModel.guides.indices, id: \.self) { idx in
            if idx == 0 || idx == viewModel.guides.count - 1 {
              Text(viewModel.guides[idx])
                .font(.callout)
            } else {
              Spacer()

              Text(viewModel.guides[idx])
                .font(.callout)

              Spacer()
            }
          }
        }
      }
      .frame(maxWidth: UIScreen.main.bounds.width * 0.75)
      .readSize { size in
        viewSize = size
      }
      .onChange(of: data) { newData in
        viewModel.data = newData
        viewModel.refresh()
      }
    }

  var graph: some View {
    HStack(alignment: .bottom, spacing: 2) {
      ForEach(viewModel.data.indices, id: \.self) { idx in
        cardView(data: $viewModel.data[idx], index: idx)
      }
    }
    .frame(height: 30)
    .animation(.easeOut, value: isDragging)
    .gesture(
      DragGesture()
        .updating($isDragging) { _, out, _ in
          out = true
        }
        .onChanged { value in
          offset = isDragging ? value.location.x : 0

          let draggingSpace = graphWidth

          self.currentDatumnId = viewModel.processGestureLocation(offset, availableWidth: draggingSpace)//viewModel.data[index].id
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

  func cardView(data: Binding<SleepModel>, index: Int) -> some View {
    AnimatedSleepBarGraphView(data: data, index: index)
      .opacity(isDragging ? (currentDatumnId == data.id ? 1 : 0.35) : 1)
      .frame(width: viewModel.getWidth(value: Double(data.wrappedValue.duration),
                                       availableWidth: viewSize.width),
             alignment: .bottom)
      .overlay(
        Text(data.wrappedValue.stage)
          .font(.caption2)
          .foregroundColor(data.wrappedValue.color)
          .opacity(isDragging && currentDatumnId == data.wrappedValue.id ? 1 : 0)
          .offset(y: -25)
          .frame(width: 30)
        , alignment: .top
      )
  }
}

struct AnimatedSleepBarGraphView: View {
  @Binding var data: SleepModel
  var index: Int

  @State var showBar: Bool = false

  var body: some View {
    HStack(spacing: 0) {
      Spacer(minLength: 0)

      Rectangle()
        .fill(data.color)
        .frame(width: showBar ? nil : 0, alignment: .bottom)
    }
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + (Double(index) * 0.1)) {
        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.8).delay(Double(index) * 0.1)) {
          showBar = true
        }
      }
    }
  }
}
