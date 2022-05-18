//
//  ProgressModel.swift
//  ActiveMe
//
//  Created by Dima Semenovich on 13.05.22.
//

import SwiftUI

struct Ring: Identifiable, Hashable, Equatable {
  let id = UUID()
  var progress: CGFloat
  var value: String
  var keyIcon: String
  var keyColor: Color
  var isText: Bool = false
}

