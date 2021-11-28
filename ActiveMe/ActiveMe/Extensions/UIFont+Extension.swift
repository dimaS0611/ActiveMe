//
//  UIFont+Extension.swift
//  ActiveMe
//
//  Created by Dzmitry Semenovich on 28.11.21.
//

import Foundation
import UIKit

extension UIFont {
    public static var bold: UIFont {
        return UIFont(name: "Roboto-Bold", size: 12)!
    }
    
    public static var regular: UIFont {
        return UIFont(name: "Roboto-Regular", size: 12)!
    }
    
    public static var light: UIFont {
        return UIFont(name: "Roboto-Light", size: 12)!
    }
    
    public static var thin: UIFont {
        return UIFont(name: "Roboto-Thin", size: 12)!
    }
    
    public static var medium: UIFont {
        return UIFont(name: "Roboto-Medium", size: 12)!
    }
}

extension UIFont {
    public static func regular(with size: CGFloat) -> UIFont {
        return UIFont.regular.withSize(size)
    }
    
    public static func bold(with size: CGFloat) -> UIFont {
        return UIFont.bold.withSize(size)
    }
    
    public static func light(with size: CGFloat) -> UIFont {
        return UIFont.light.withSize(size)
    }
    
    public static func thin(with size: CGFloat) -> UIFont {
        return UIFont.thin.withSize(size)
    }
    
    public static func medium(with size: CGFloat) -> UIFont {
        return UIFont.medium.withSize(size)
    }
}
