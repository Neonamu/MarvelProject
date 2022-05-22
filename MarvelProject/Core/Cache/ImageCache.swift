//
//  ImageCache.swift
//  MarvelProject
//
//  Created by Manuel Alvarez Marin on 20/5/22.
//

import Foundation


class ImageCache {
    public static let shared = ImageCache()
    private var dictImages: [String: Data]

    private init() {
        dictImages = [:]
    }

    func save (url: String, data: Data) {
        dictImages[url] = data
    }

    func get (url: String) -> Data? {
        guard let result = dictImages[url] else {
            return nil
        }
        return result
    }
}
