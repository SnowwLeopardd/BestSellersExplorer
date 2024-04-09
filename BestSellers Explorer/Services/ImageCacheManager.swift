//
//  ImageCacheManager.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 2/14/24.
//

import UIKit

class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    
    private init() {}
}
