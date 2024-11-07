//
//  ColorModel.swift
//  serastvorovPW2
//
//  Created by Сергей Растворов on 11/5/24.
//

import SwiftUI

struct ColorModel {
    var red: Double
    var green: Double
    var blue: Double
    
    // return UIColor by variables init
    func makeColor() -> UIColor {
        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1.0)
    }
    
    // invert color to make more contrast
    func invertedColor() -> UIColor {
        return UIColor(red: 1 - 0.299 * CGFloat(red), green: 1 - 0.587 * CGFloat(green), blue: 1 - 0.587 * CGFloat(blue), alpha: 1.0)
    }
}

