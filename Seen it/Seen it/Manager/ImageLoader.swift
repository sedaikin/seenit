//
//  ImageLoader.swift
//  Seen it
//
//  Created by Sedaykin Aleksey on 01.09.2025.
//

import UIKit

final class ImageLoader {
    static let shared = ImageLoader()
    
    private init() {}
    
    private let cache: NSCache<NSURL, UIImage> = NSCache<NSURL, UIImage>()
    
    func loadImage(from url: URL) async throws -> UIImage {
        if let cachedImage = cache.object(forKey: url as NSURL) {
            return cachedImage
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        if let image = UIImage(data: data) {
            self.cache.setObject(image, forKey: url as NSURL)
            return image
        } else {
            throw NSError(domain: "Image loading error", code: -1, userInfo: nil)
        }
    }
}
