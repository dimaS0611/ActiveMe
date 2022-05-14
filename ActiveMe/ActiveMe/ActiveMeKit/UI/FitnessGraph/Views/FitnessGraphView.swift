//
//  FitnessGraphView.swift
//  ActiveMe
//
//  Created by Dima Semenovich on 14.05.22.
//

import SwiftUI

struct FitnessGraphView: View {
  var body: some View {
    VStack(spacing: 15) {
      Text("Steps by hours")
        .fontWeight(.semibold)
        .frame(maxWidth: .infinity, alignment: .leading)

      BarGraph(data: steps)
        .padding(.top, 15)
    }
    .padding(.vertical, 20)
    .padding(.horizontal, 25)
    .background(
      RoundedRectangle(cornerRadius: 25, style: .continuous)
        .fill(.ultraThinMaterial)
    )
  }
}
