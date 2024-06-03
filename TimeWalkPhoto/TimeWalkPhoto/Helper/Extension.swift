//
//  Extension.swift
//  TimeWalkPhoto
//
//  Created by iMac on 03/06/24.
//

import Foundation
import UIKit

// MARK: - UIView
extension UIView {
    func getSnapshotImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        drawHierarchy(in: bounds, afterScreenUpdates: false)
        let snapshotImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return snapshotImage
    }
}

// MARK: - UILabel
extension UIView {
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        self.layer.shadowOffset = offset
        self.layer.shadowColor = color.cgColor
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.masksToBounds = false
    }
}

// MARK: - UIImage
extension UIImage {
    func merge(with stackViewSnapshot: UIImage) -> UIImage? {
        let maxSize = CGSize(width: self.size.width,
                             height: self.size.height)

        UIGraphicsBeginImageContextWithOptions(maxSize, false, UIScreen.main.scale)

        // Draw the main image at its original size
        self.draw(at: .zero)

        // Draw the stack view snapshot at (20, 20) from the top-left corner
        print(stackViewSnapshot.size)
        stackViewSnapshot.draw(in: CGRect(x: 50, y: 50, width: 2000, height: 900))

        // Get the merged image from the current image context
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()

        // End the image context
        UIGraphicsEndImageContext()

        return mergedImage
    }
    
    
}
