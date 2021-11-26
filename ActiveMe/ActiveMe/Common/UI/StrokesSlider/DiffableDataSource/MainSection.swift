//
//  MainSection.swift
//  ActiveMe
//
//  Created by Dzmitry Semenovich on 26.11.21.
//

import Foundation

class Section: Hashable {
    let id = UUID()
    var cells = [StrokeCell]()
    
    init(cells: [StrokeCell]) {
        self.cells.append(contentsOf: cells)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Section, rhs: Section) -> Bool {
        lhs.id == rhs.id
    }
}
