//
//  ImageCache.swift
//  MarvelProject
//
//  Created by Manuel Alvarez Marin on 20/5/22.
//

import Foundation

public protocol ImageCacheProtocol {
    static var shared: ImageCacheProtocol { get }
    func save (url: String, data: Data)
    func get (url: String) -> Data?
    func remove (url: String)
}

public class ImageCache: ImageCacheProtocol {
    public static let shared: ImageCacheProtocol = ImageCache()
    private var dictImages: [String: Data]

    private init() {
        dictImages = [:]
    }

    public func save (url: String, data: Data) {
        dictImages[url] = data
    }

    public func get (url: String) -> Data? {
        guard let result = dictImages[url] else {
            return nil
        }
        return result
    }

    public func remove (url: String) {
        dictImages.removeValue(forKey: url)
    }
}
