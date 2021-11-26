//
//  UICollectionViewCell+Extension.swift
//  ActiveMe
//
//  Created by Dzmitry Semenovich on 26.11.21.
//

import Foundation
import UIKit

extension UICollectionViewCell {
    public static var reuseIdentifier: String {
        String(describing: self)
    }
}
