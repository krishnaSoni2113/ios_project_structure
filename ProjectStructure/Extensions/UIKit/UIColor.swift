//
//  UIColor.swift
//  ProjectStructure
//
//  Created by mac-0005 on 09/09/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import UIKit

// UIColor's functions
extension UIColor {
    
    static func opaque(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return fromRGB(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    static func fromRGB(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        
        return UIColor(
            red: red / 255.0,
            green: green / 255.0,
            blue: blue / 255.0,
            alpha: alpha
        )
    }
}

// App's static Color
extension UIColor {
    
    /// App's theme color
    static let baseAppThemeColor = UIColor.opaque(red: 16.0, green: 142.0, blue: 233.0)
}
