//
//  StepModel.swift
//  ActiveMe
//
//  Created by Dima Semenovich on 13.05.22.
//

import SwiftUI

struct Step: Identifiable, Hashable, Equatable {
  let id = UUID()
  var value: CGFloat
  var key: String
  var color: Color = Color("primary")
}
