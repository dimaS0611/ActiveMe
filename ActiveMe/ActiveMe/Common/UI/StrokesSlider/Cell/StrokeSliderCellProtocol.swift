//
//  StrokeSliderCellProtocol.swift
//  ActiveMe
//
//  Created by Dzmitry Semenovich on 26.11.21.
//

import Foundation

protocol StrokeSliderCellProtocol: AnyObject {
    func setTitle(title: Int)
    func setActiveCell()
    func setInactiveCell()
    func getValueOfCell() -> Int
}
