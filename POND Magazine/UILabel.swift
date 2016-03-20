import UIKit

extension UILabel {
    func resizeToText() {
        self.numberOfLines = 0
        self.sizeToFit()
    }
}