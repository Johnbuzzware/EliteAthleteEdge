//
//  UIImage+Additions.swift
//  TradeAir
//
//  Created by Adeel on 19/09/2019.
//  Copyright © 2019 Buzzware. All rights reserved.
//

import UIKit

class UIImage_Additions: NSObject {

}
extension UIImage {
    func makeImageWithColorAndSize(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
extension UIImage {
    static func radialGradientImageWithSize(size: CGSize, outerColor: UIColor, innerColor: UIColor) -> UIImage {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: colorSpace, colors: [outerColor.cgColor, innerColor.cgColor] as CFArray, locations: [1.0, 0.0])!
        let center = CGPoint(x: size.width / 2.0, y: size.height / 2.0)

        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let imageContext = UIGraphicsGetCurrentContext()!

        imageContext.drawRadialGradient(gradient, startCenter: center, startRadius: 0.0, endCenter: center, endRadius: size.width / 2.0, options: CGGradientDrawingOptions.drawsAfterEndLocation)

        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
extension UIImage {
    //    public func urlToImage(urlString: String) -> UIImage{
    //
    //        let url = NSURL(string: Variables.SERVER_IP + "/" + urlString)
    //        let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
    //        return  UIImage(data: data!)!
    //
    //    }
    //
    //    public func absoluteURL(ImageUrl: String) -> NSURL{
    //
    //        let profileImageUrl = Variables.SERVER_IP + "/" + ImageUrl
    //
    //        return NSURL(string: profileImageUrl)!
    //
    //    }
    
    
    var rounded: UIImage? {
        let imageView = UIImageView(image: self)
        imageView.layer.cornerRadius = min(size.height/2, size.width/2)
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContext(imageView.bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    var circle: UIImage? {
        let square = CGSize(width: min(size.width, size.height), height: min(size.width, size.height))
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
        imageView.contentMode = .scaleToFill
        imageView.image = self
        imageView.layer.cornerRadius = square.width/2
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContext(imageView.bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    //    func compressImage(imageUrl:String)-> UIImage {
    //        let imagenew:UIImage = UIImage().urlToImage(imageUrl)
    //        return UIImage.compressImage(imagenew, compressRatio:0.9)
    //    }
    func RBSquareImageTo(_ image: UIImage, size: CGSize) -> UIImage? {
        return RBResizeImage(RBSquareImage(image), targetSize: size)
    }
    
    func RBSquareImage(_ image: UIImage) -> UIImage? {
        let originalWidth  = image.size.width
        let originalHeight = image.size.height
        
        var edge: CGFloat
        if originalWidth > originalHeight {
            edge = originalHeight
        } else {
            edge = originalWidth
        }
        
        let posX = (originalWidth  - edge) / 2.0
        let posY = (originalHeight - edge) / 2.0
        
        let cropSquare = CGRect(x: posX, y: posY, width: edge, height: edge)
        
        let imageRef = image.cgImage?.cropping(to: cropSquare);
        return UIImage(cgImage: imageRef!, scale: UIScreen.main.scale, orientation: image.imageOrientation)
    }
    
    func RBResizeImage(_ image: UIImage?, targetSize: CGSize) -> UIImage? {
        if let image = image {
            let size = image.size
            
            let widthRatio  = targetSize.width  / image.size.width
            let heightRatio = targetSize.height / image.size.height
            
            // Figure out what our orientation is, and use that to form the rectangle
            var newSize: CGSize
            if(widthRatio > heightRatio) {
                newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
            } else {
                newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
            }
            
            // This is the rect that we've calculated out and this is what is actually used below
            let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
            
            // Actually do the resizing to the rect using the ImageContext stuff
            UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
            image.draw(in: rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return newImage
        } else {
            return nil
        }
    }
}
class UITurtlePath {
    let path = UIBezierPath()

    init() {
        path.move(to: .zero)
    }

    func scuttle(_ amount: CGFloat) {
        path.addLine(to: .init(x: amount, y: 0))
        path.apply(CGAffineTransform(translationX: -amount, y: 0))
    }

    func hop(_ amount: CGFloat) {
        path.move(to: .init(x: amount, y: 0))
        path.apply(CGAffineTransform(translationX: -amount, y: 0))
    }

    func turn(_ radians: CGFloat) {
        path.apply(CGAffineTransform(rotationAngle: radians))
    }

    func close() {
        let pt = path.currentPoint
        path.addLine(to: .init(x: 0, y: 0))
        path.apply(CGAffineTransform(translationX: -pt.x, y: -pt.y))
        path.close()
    }
}
