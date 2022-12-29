//
//  File.swift
//  
//
//  Created by Aleksei Grachev on 15/12/22.
//
import UIKit

protocol ImageManagerProtocol: AnyObject {
    func getImage(pathImage: String?) -> UIImage?
}
final class ImageManager {
    
}

extension ImageManager: ImageManagerProtocol {
    //get image from path
    func getImage(pathImage: String?) -> UIImage? {
        var image: UIImage?
        if let path = pathImage {
            let tempDirectoryUrl = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(path)
            if let imageFromURL = UIImage(fileURLWithPath: tempDirectoryUrl) {
                image = imageFromURL
            }
        }
        return image
    }
}
