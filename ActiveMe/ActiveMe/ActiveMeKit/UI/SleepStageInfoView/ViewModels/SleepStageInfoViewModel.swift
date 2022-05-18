//
//  SleepStageInfoViewModel.swift
//  ActiveMe
//
//  Created by Dima Semenovich on 15.05.22.
//

import Foundation
import SwiftUI
import Combine

class SleepStageInfoViewModel: ObservableObject {

  @Published var title: String = ""
  @Published var info: String = ""
  @Published var width: CGFloat = 0

  private var infoText: String = ""
  private var linesToAnimate: [String] = []
  private var stage: Stage

  private let dispatchQueue = DispatchQueue(label: "TypewriterLabelQueue")

  var bag = Set<AnyCancellable>()

  init(stage: Stage) {
    self.stage = stage
    initText()

    bind()
  }

  func bind() {
    let correctedWidthPublisher = $width
      .filter { $0 > 0 }

    correctedWidthPublisher
      .throttle(for: .milliseconds(1000), scheduler: DispatchQueue.main, latest: true)
      .sink(receiveValue: { [weak self] input in
        guard let self = self else { return }
        self.startAnimation()
      }).store(in: &bag)
  }

  func initText() {
    switch stage {
    case .n1:
      title = "N1 (NREM)"
      infoText = """
      During N1 sleep, the body hasn’t fully relaxed,
      though the body and brain activities start to slow
      with periods of brief movements.
      There are light changes in brain activity
      associated with falling asleep in this stage.
      """
    case .n2:
      title = "N2 (NREM)"
      infoText = """
    During stage 2, the body enters a more subdued state including a drop in temperature,
    relaxed muscles, and slowed breathing and heart rate.
    At the same time, brain waves show a new pattern and eye movement stops.
    On the whole, brain activity slows, but there are short bursts of activity
    that actually help resist being woken up by external stimuli.
    """
    case .n3:
      title = "N3 (NREM)"
      infoText = """
Stage 3 sleep is also known as deep sleep,
and it is harder to wake someone up if they are in this phase.
Muscle tone, pulse, and breathing rate decrease in N3 sleep
 as the body relaxes even further.
Experts believe that this stage is critical to restorative sleep,
allowing for bodily recovery and growth.
It may also bolster the immune system and other key bodily processes.
"""
    case .rem:
      title = "REM"
      infoText = """
During REM sleep, brain activity picks up,
nearing levels seen when you’re awake.
REM sleep is known for the most vivid dreams,
which is explained by the significant uptick in brain activity.
"""
    }
  }

  func startAnimation() {
    linesToAnimate = getLinesForText(infoText, width: width)
    animate()
  }

  private func animate() {
    guard linesToAnimate.count > 0 else {
      return
    }

    let animation = linesToAnimate.removeFirst()
    type(text: animation, withInterval: 0.025)
  }

  private func type(text: String, withInterval interval: TimeInterval) {
    DispatchQueue.main.async {
      guard let nextChar = text.first else {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
          self.animate()
        }
        return
      }

      self.info += String(nextChar)

      self.dispatchQueue.asyncAfter(deadline: .now() + interval, execute: { [weak self] in
        self?.type(text: String(text.dropFirst()), withInterval: interval)
      })
    }
  }

  private func getLinesForText(_ title: String, width: CGFloat) -> [String] {
    let uiFont = UIFont.preferredFont(forTextStyle: .callout)
    return title
      .splittingLinesThatFitIn(width: width+5, font: uiFont)
  }
}

extension SleepStageInfoViewModel {
  enum Stage {
    case n1
    case n2
    case n3
    case rem
  }
}
