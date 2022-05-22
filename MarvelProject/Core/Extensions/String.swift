//
//  String.swift
//  MarvelProject
//
//  Created by Manuel Alvarez Marin on 18/5/22.
//

import Foundation
import CryptoKit

extension String {
    public var md5: String {
        let data = self.data(using: .utf8) ?? Data()
        return Insecure.MD5
            .hash(data: data)
            .map { String(format: "%02x", $0) }
            .joined()
    }
}
