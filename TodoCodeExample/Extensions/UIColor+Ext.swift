import UIKit

extension UIColor {
    convenience init(hex: String) {
        var cleanHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanHex = cleanHex.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: cleanHex).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgb & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

extension UIColor {
    struct TodoColors {
        static let navBarTint: UIColor = .init(hex: "#FED702")
        static let bgColor: UIColor = .init(hex: "#040404")
        static let textWhite: UIColor = .init(hex: "#F4F4F4")
        static let bgGray: UIColor = .init(hex: "#272729")
        static let destrRed: UIColor = .init(hex: "#D70015")
    }
}
