//
//  ColorViewModel.swift
//  serastvorovPW3
//
//  Created by Сергей Растворов on 3/24/25.
//

import UIKit

final class ColorViewModel {
    // MARK: - Properties
    private var colorModel: ColorModel
    var onColorUpdate: ((UIColor) -> Void)?
    var onTextColorUpdate: ((UIColor) -> Void)?
    
    // MARK: - Initialization
    init(colorModel: ColorModel = ColorModel(red: 0, green: 0, blue: 0)) {
        self.colorModel = colorModel
    }
    
    // MARK: - Public Methods
    func updateColor(red: Double, green: Double, blue: Double) {
        colorModel.red = red
        colorModel.green = green
        colorModel.blue = blue
        
        let backgroundColor = colorModel.makeColor()
        let textColor = colorModel.invertedColor()
        
        onColorUpdate?(backgroundColor)
        onTextColorUpdate?(textColor)
    }
    
    func getCurrentColor() -> UIColor {
        return colorModel.makeColor()
    }
    
    func getCurrentTextColor() -> UIColor {
        return colorModel.invertedColor()
    }
    
    func generateRandomColor() {
        let red = Double.random(in: 0...1)
        let green = Double.random(in: 0...1)
        let blue = Double.random(in: 0...1)
        updateColor(red: red, green: green, blue: blue)
    }
} 
