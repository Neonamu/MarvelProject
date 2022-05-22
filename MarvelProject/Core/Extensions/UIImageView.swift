//
//  UIImageView.swift
//  MarvelProject
//
//  Created by Manuel Alvarez Marin on 19/5/22.
//

import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = ImageCache.shared.get(url: url.absoluteString) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            } else if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        ImageCache.shared.save(url: url.absoluteString, data: data)
                        self?.image = image
                    }
                }
            }
        }
    }
}
