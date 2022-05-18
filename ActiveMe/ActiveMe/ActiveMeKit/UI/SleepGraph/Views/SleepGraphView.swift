//
//  SleepGraphView.swift
//  ActiveMe
//
//  Created by Dima Semenovich on 15.05.22.
//

import SwiftUI

struct SleepGraphView: View {
  @StateObject var viewModel: SleepGraphViewModel

  @Binding var data: [SleepModel]

  @State var showInfo: Bool = false

  @State var selectedStage: SleepStageInfoViewModel.Stage = .rem

  init(data: Binding<[SleepModel]>) {
    self._viewModel = StateObject(wrappedValue: SleepGraphViewModel(data: data))
    self._data = data
  }

  var body: some View {
    VStack(spacing: 15) {
      Text("Sleep stages")
        .fontWeight(.semibold)
        .frame(maxWidth: .infinity, alignment: .leading)

      SleepStageGraph(data: $data)
        .padding(.top, 15)

      stagePercents
    }
    .padding(.vertical, 20)
    .padding(.horizontal, 25)
    .background(
      RoundedRectangle(cornerRadius: 25, style: .continuous)
        .fill(.ultraThinMaterial)
    )
    .fullScreenCover(isPresented: $showInfo) {
      SleepStageInfoView(stage: selectedStage)
    }
    .onChange(of: data) { _ in
      viewModel.data = data
      viewModel.refresh()
    }
  }

  var stagePercents: some View {
    HStack(alignment: .top, spacing: 70) {
      ForEach(0..<viewModel.columnsCount, id: \.self) { idx in
        if let columnData = viewModel.stagesGridData[idx] {
          stagesColumn(stages: columnData)
        }
      }
    }
  }

  @ViewBuilder
  func stagesColumn(stages: [SleepGraphModel]) -> some View {
    VStack(alignment: .leading) {
      ForEach(stages, id: \.self) { stage in
        Button {
          selectedStage = stage.plainType
          showInfo.toggle()
        } label: {
          stageCard(stage)
        }
      }
    }
  }

  @ViewBuilder
  func stageCard(_ stage: SleepGraphModel) -> some View {
    VStack(alignment: .leading) {
      Text(stage.durationStringFormat)
        .font(.title3.bold())

      HStack {
        Circle()
          .fill(stage.color)
          .frame(width: 10, height: 10)

        Text("\(stage.stage) \(stage.percent)%")
          .font(.caption)
          .foregroundColor(.gray)

        Image(systemName: "questionmark.circle")
          .resizable()
          .foregroundColor(.gray)
          .frame(width: 10, height: 10)
      }
    }
  }
}

