//
//  ImageProcessor.swift
//  Nifty
//
//  Created by Mac-LAB on 11/5/26.
//

import UIKit

enum ImageProcessor {
    /// Returns JPEG data no larger than `maxDimension` points on its longest side, or nil if the data isn't an image.
    static func optimizedJPEG(from data: Data, maxDimension: CGFloat = 1200, quality: CGFloat = 0.8) -> Data? {
        guard let image = UIImage(data: data) else { return nil }

        let longestSide = max(image.size.width, image.size.height)
        guard longestSide > 0 else { return nil }

        let scale = min(1, maxDimension / longestSide)
        let targetSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)

        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
        let resized = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        return resized.jpegData(compressionQuality: quality)
    }
}
