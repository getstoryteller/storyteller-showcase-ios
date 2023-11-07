import Foundation
import UIKit

extension UIColor {
    // MARK: Lifecycle

    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexInt = Int(UIColor.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexInt & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hexInt & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((hexInt & 0xFF) >> 0) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    // MARK: Internal

    var hexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb = Int(r * 255) << 16 | Int(g * 255) << 8 | Int(b * 255) << 0

        return String(format: "#%06x", rgb)
    }

    // MARK: Private

    private static func intFromHexString(hexStr: String) -> UInt64 {
        var hexInt: UInt64 = 0
        // Create scanner
        let scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        // Scan hex value
        scanner.scanHexInt64(&hexInt)
        return hexInt
    }
}
