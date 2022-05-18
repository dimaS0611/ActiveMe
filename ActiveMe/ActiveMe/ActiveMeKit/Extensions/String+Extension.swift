//
//  String+Extension.swift
//  ActiveMe
//
//  Created by Dima Semenovich on 15.05.22.
//

import UIKit

extension String {
  func splittingLinesThatFitIn(width: CGFloat, font: UIFont) -> [String] {

    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineBreakMode = .byWordWrapping

    // set up styled text for the container
    let storage = NSTextStorage(string: self, attributes: [
      NSAttributedString.Key.font: font,
      NSAttributedString.Key.paragraphStyle: paragraphStyle
    ])

    // add a layout manage for the storage
    let layout = NSLayoutManager()
    storage.addLayoutManager(layout)

    // Set up the size of the container
    // width is what we care about, height is maximum
    let container = NSTextContainer(size: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))

    // add the container to the layout
    layout.addTextContainer(container)

    var lines = [String]()

    // generate the layout and add each line to the array

    // swiftlint:disable legacy_constructor
    layout.enumerateLineFragments(forGlyphRange: NSMakeRange(0, storage.length)) { _, _, _, range, _ in
      lines.append(storage.attributedSubstring(from: range).string)
    }

    debugPrint(lines)

    return lines
  }
}
