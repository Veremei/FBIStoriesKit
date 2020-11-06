import UIKit

extension UIColor {
    func hexString(withAlpha: Bool = true) -> String? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        guard getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return nil
        }

        let components = withAlpha ? [r, g, b] : [r, g, b, a]

        return components.reduce(into: "#", { result, value in
            result += String(format: "%02lX", Int((value * 255).rounded()))
        })
    }

    convenience init?(hexString string: String) {
        guard string.count == 7 else {
            return nil
        }

        var hexString = string
        hexString.removeFirst()

        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)

        let r = CGFloat(0xFF & (rgb >> 16)) / 255
        let g = CGFloat(0xFF & (rgb >> 8)) / 255
        let b = CGFloat(0xFF & rgb) / 255
        self.init(red: r, green: g, blue: b, alpha: 1)
    }
}
