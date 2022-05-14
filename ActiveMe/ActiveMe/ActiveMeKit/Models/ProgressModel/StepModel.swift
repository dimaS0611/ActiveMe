//
//  StepModel.swift
//  ActiveMe
//
//  Created by Dima Semenovich on 13.05.22.
//

import SwiftUI

struct Step: Identifiable, Hashable {
  let id = UUID()
  var value: CGFloat
  var key: String
  var color: Color = Color("primary")
}

var steps: [Step] = [
  Step(value: 500, key: "1-4 AM"),
  Step(value: 100, key: "5-8 AM", color: Color("secondary")),
  Step(value: 50, key: "9-11 AM"),
  Step(value: 200, key: "12-4 PM", color: Color("secondary")),
  Step(value: 250, key: "5-8 PM"),
  Step(value: 600, key: "9-12 PM", color: Color("secondary")),
]
