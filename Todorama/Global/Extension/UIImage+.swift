//
//  UIImage+.swift
//  Todorama
//
//  Created by 최정안 on 3/21/25.
//

import UIKit
extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
