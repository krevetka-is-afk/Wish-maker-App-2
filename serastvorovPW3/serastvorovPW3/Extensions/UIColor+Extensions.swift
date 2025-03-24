import UIKit

extension UIColor {
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        guard getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        
        return (red, green, blue, alpha)
    }
    
    var isDark: Bool {
        guard let components = components else { return false }
        let brightness = (components.red * 299 + components.green * 587 + components.blue * 114) / 1000
        return brightness < 0.5
    }
} 