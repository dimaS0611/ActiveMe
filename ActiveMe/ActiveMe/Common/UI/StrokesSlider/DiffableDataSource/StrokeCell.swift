//
//  StrokeCell.swift
//  ActiveMe
//
//  Created by Dzmitry Semenovich on 26.11.21.
//

import Foundation

public class StrokeCell: Hashable {
    let id = UUID()
    public var title: Int
    
    public init(titile: Int) {
        self.title = titile
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: StrokeCell, rhs: StrokeCell) -> Bool {
        lhs.id == rhs.id
    }
}
