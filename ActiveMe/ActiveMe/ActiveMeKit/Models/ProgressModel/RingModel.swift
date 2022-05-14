//
//  ProgressModel.swift
//  ActiveMe
//
//  Created by Dima Semenovich on 13.05.22.
//

import SwiftUI

struct Ring: Identifiable, Hashable {
  let id = UUID()
  var progress: CGFloat
  var value: String
  var keyIcon: String
  var keyColor: Color
  var isText: Bool = false
}


var rings: [Ring] = [
  Ring(progress: 72, value: "Steps", keyIcon: "figure.walk", keyColor: Color("highlighter")),
  Ring(progress: 36, value: "Calories", keyIcon: "flame.fill", keyColor: Color("primary")),
  Ring(progress: 91, value: "Sleep time", keyIcon: "😴", keyColor: Color("secondary"), isText: true)
]

