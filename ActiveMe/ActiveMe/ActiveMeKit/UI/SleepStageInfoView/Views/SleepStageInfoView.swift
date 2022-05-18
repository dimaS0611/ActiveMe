//
//  SleepStageInfoView.swift
//  ActiveMe
//
//  Created by Dima Semenovich on 15.05.22.
//

import SwiftUI

struct SleepStageInfoView: View {
  @Environment(\.presentationMode) var presentationMode

  @StateObject var viewModel: SleepStageInfoViewModel

  init(stage: SleepStageInfoViewModel.Stage) {
    self._viewModel = StateObject(wrappedValue: SleepStageInfoViewModel(stage: stage))
  }

  var body: some View {
    ZStack {
      BackgroundBlurView(style: .systemUltraThinMaterialDark).ignoresSafeArea()
        .onTapGesture {
          presentationMode.wrappedValue.dismiss()
        }.frame(width: UIScreen.main.bounds.width,
                height: UIScreen.main.bounds.height)

      ZStack {
        RoundedRectangle(cornerRadius: 20)
          .fill(.ultraThickMaterial)
          .frame(width: 250, height: 350)

        VStack(alignment: .leading) {
          Text(viewModel.title)
            .multilineTextAlignment(.leading)
            .font(.system(.title3, design: .rounded))

          ScrollView(.vertical,
                     showsIndicators: true) {
            Text(viewModel.info)
              .font(.system(.callout, design: .rounded))
              .foregroundColor(.white.opacity(0.8))
              .animation(.linear)
              .frame(maxWidth: .infinity, alignment: .topLeading)
              .background(
                GeometryReader(content: { proxy in
                  Color.clear
                    .onAppear(perform: {
                      RunLoop.main.perform {
                        self.viewModel.width = proxy.size.width - 20
                      }
                    })
                })
              )
          }
        }
        .frame(width: 200, height: 300)
      }
    }
    .preferredColorScheme(.dark)
  }
}

struct SleepStageInfoView_Previews: PreviewProvider {
  static var previews: some View {
    SleepStageInfoView(stage: .n1)
  }
}
