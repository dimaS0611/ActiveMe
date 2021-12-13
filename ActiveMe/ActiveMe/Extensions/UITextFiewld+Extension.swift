//
//  UITextFiewld+Extension.swift
//  ActiveMe
//
//  Created by Dzmitry Semianovich on 12/13/21.
//

import Foundation
import UIKit

extension UITextField {
    func addBottomBorder(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width - 60.0, height: 1)
        bottomLine.backgroundColor = UIColor.systemFill.cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
}
