//
//  BackgroundBlurView.swift
//  ActiveMe
//
//  Created by Dima Semenovich on 15.05.22.
//

import UIKit
import SwiftUI

struct BackgroundBlurView: UIViewRepresentable {

  let style: UIBlurEffect.Style
  let alpha: CGFloat

  init(style: UIBlurEffect.Style = .light, alpha: CGFloat = 1.0) {
    self.style = style
    self.alpha = alpha
  }

  func makeUIView(context: Context) -> UIView {
    let blurEffect = UIBlurEffect(style: style)
    let view = UIVisualEffectView(effect: blurEffect)
    DispatchQueue.main.async {
      view.superview?.superview?.backgroundColor = .clear
    }
    if alpha > 1 || alpha < 0 {
      view.alpha = 1
    }
    view.alpha = alpha
    return view
  }

  func updateUIView(_ uiView: UIView, context: Context) {}
}
