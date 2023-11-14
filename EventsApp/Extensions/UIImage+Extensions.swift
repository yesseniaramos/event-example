//
//  UIImage.swift
//  EventsApp
//
//  Created by yessenia ramos on 30/09/23.
//

import UIKit 

extension UIImage {
    func sameAspectRatio(newHeight: CGFloat) -> UIImage  {
        let scale = newHeight / size.height
        let newWidth =  size.width * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        return  UIGraphicsImageRenderer(size: newSize)
            .image{ _ in
                self.draw(in: .init(origin: .zero, size: newSize))
            }
    }
}
