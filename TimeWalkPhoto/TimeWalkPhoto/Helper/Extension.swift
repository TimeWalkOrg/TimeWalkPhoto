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
    func merge(with image: UIImage) -> UIImage? {
        let maxSize = CGSize(width: self.size.width,
                             height: self.size.height)
        UIGraphicsBeginImageContextWithOptions(maxSize, false, UIScreen.main.scale)
        self.draw(at: .zero)

        var orientation: UIInterfaceOrientation = .unknown
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            orientation = windowScene.interfaceOrientation
        }
        
        let width = self.size.width
        let height = self.size.height
        let imageWidth: Double = 800
        let imageHeight: Double = 1400
        
        switch orientation {
        case .landscapeLeft:
            let rotatedImage = image.rotate(radians: -.pi / 2.0)
            rotatedImage.draw(in: CGRect(x: 50, y: (height-imageHeight-50), width: imageWidth, height: imageHeight))
        case .landscapeRight:
            let rotatedImage = image.rotate(radians: .pi / 2.0)
            rotatedImage.draw(in: CGRect(x: (width-imageWidth-50), y: 50, width: imageWidth, height: imageHeight))
        case .portraitUpsideDown:
            image.draw(in: CGRect(x: 50, y: 50, width: imageHeight, height: imageWidth))
        default:
            image.draw(in: CGRect(x: 50, y: 50, width: imageHeight, height: imageWidth))
        }
        
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return mergedImage
    }
    
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: radians))
            .integral.size
        
        UIGraphicsBeginImageContextWithOptions(rotatedSize, false, scale)
        
        guard let context = UIGraphicsGetCurrentContext() else { return self }
        context.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        context.rotate(by: radians)
        draw(in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))
        
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return rotatedImage ?? self
    }
}

// MARK: - Double
extension Double {
    func adjustPitchForOrientation() -> Double {
        var adjustedPitch = self
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene  {
            switch  windowScene.interfaceOrientation {
            case .landscapeLeft:
                adjustedPitch += 90.0
                return adjustedPitch
            case .landscapeRight:
                adjustedPitch -= 90.0
                return adjustedPitch
            default:
                return adjustedPitch
            }
        } else {
            return adjustedPitch
        }
    }
}
